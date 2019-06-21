global class LoadAccounts implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.stateful {

    global Auxiliar saved = new Auxiliar();
    global Integer limitCallouts = 99;
    global List<Account> acct = new List<Account>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Start');

        String query = 'SELECT UserName__c,Password__c,Token__c,ClientId__c,' + 
            'ClientSecret__c,EndPointURL__c, LastSync__c FROM IntegrationSetup__c' +
            ' WHERE IntegrationType__c = \'Account\'';

        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<IntegrationSetup__c> orgs) {
        List<Account> pf = new List<Account>();
        List<Account> pj = new List<Account>();
        String pftipo = 'pf';
        String pjtipo = 'pj';
        Integer page = saved.page;
        
        acct = addAccountsFromOrg(orgs, acct, page);

        System.debug('Contas a adicionar: ' + acct.size());

        pf = splitAccounts(acct, pftipo);
        System.debug('Contas pf a adicionar: '+ pf.size());

        pj = splitAccounts(acct, pjtipo);
        System.debug('Contas pj a adicionar: ' + pj.size());
        
        System.debug('callouts: ' + saved.numCallouts);
        saved.numCallouts = 0;
        
        //upsertAccounts(pf, pj);

        //updateLastSync(orgs);
    }    
    global void finish(Database.BatchableContext bc){
        System.debug('Finish value of isFinished: ' + saved.isFinished);
        if(saved.isFinished == false) {
            Database.executeBatch(this);
        }
    } 
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    public List<Account> addAccountsFromOrg(List<IntegrationSetup__c> orgs, List<Account> acct, Integer page) {
        for(IntegrationSetup__c a : orgs) {     
            if(saved.isFinished == true) {
                saved.page = 0;
                page = 0;
                saved.org = null;
                saved.isFinished = false;
            }
            
            if(saved.org != null) {
                if(a != saved.org) 
                    continue;
            }

            String token = Token.getToken(a);

            saved.numCallouts += 1;

            loopCallouts(acct, a, page, token);
        }
        System.debug('tamanho lista org: ' + orgs.size());
        System.debug('tamanho savedorgs: ' + saved.numOrgs);
        if(saved.numOrgs == orgs.size()) {
            saved.isFinished = true;
        }

        return acct;
    }
    public void loopCallouts(List<Account> acct, IntegrationSetup__c a, Integer page, String token) {
        for(; saved.numCallouts < limitCallouts; saved.numCallouts++) {
            List<Account> found = new List<Account>();

            found = callWebService(page, a, token);
            System.debug('Contas por callout: ' + found.size());

            page += 1; 

            if(found.size() > 0) {
                saved.org = a;
                saved.page = page;
            }

            if(found.size() == 0) { 
                saved.isFinished = true;
                saved.page = 0;
                saved.org = null;
                saved.numOrgs = saved.numOrgs + 1;
                break;
            }
            
            System.debug('finished (for de callouts)' + saved.isFinished);
        }
    }
    public List<Account> callWebService(Integer page, IntegrationSetup__c a, String token) {
        Http http = new Http();
        HttpRequest req =  new HttpRequest();
        HttpResponse res = new HttpResponse();
        List<Account> found = new List<Account>();

        if(a.LastSync__c != null) {
            req.setEndpoint(a.EndPointURL__c + '?LastSync=' +
                EncodingUtil.urlEncode(String.valueOf(a.LastSync__c), 'UTF-8') + '&Pagina=' + page);    
        }
        else {
            req.setEndpoint(a.EndPointURL__c + '?Pagina=' + page);    
        }

        System.debug('endpoint: '+ req.getEndpoint());

        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token);
        res = http.send(req);

        if(res.getStatusCode() == 200) { 
            found.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
            acct.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
        }
        return found;
    }
    public static List<Account> splitAccounts(List<Account> acct, String type) {
        List<Account> separated = new List<Account>();
        if(type.equals('pf')) {
            for(Account ac : acct) {
                ac.Id = null;
                //System.debug('Nome'+ ac.name);
                if(ac.Tipo__c == 'Pessoa Física' || ac.Tipo__c == 'PessoaFisica') {
                    separated.add(ac);
                }
            }
        }
        if(type.equals('pj')) {
            for(Account ac : acct) {
                ac.Id = null;
                //System.debug('Nome'+ ac.name);
                if(ac.Tipo__c == 'Pessoa Jurídica' || ac.Tipo__c == 'PessoaJuridica') {
                    separated.add(ac);
                }
            }
        }
        return separated;
    }
    /* public static void upsertAccounts(List<Account> pf, List<Account> pj) {
        try {
            System.debug('pj: '+pj);
            Schema.SObjectField loadpj = Account.CNPJ__c;
            Database.UpsertResult[] pjAdd = Database.upsert(pj, loadpj, false);
            System.debug('adds '+pjAdd);
            System.debug('Contas a adicionar: ' + contador);
            update orgs;
        }
        catch(Exception e) {
            System.debug('Upsert CNPJ failed '+ e.getMessage());
        }
        try {
            System.debug('pf: '+pf);
            Schema.SObjectField loadpf = Account.CPF__c;
            Database.UpsertResult[] pfAdd = Database.upsert(pf, loadpf, false);
            System.debug('adds '+pfAdd);
            System.debug('Contas a adicionar: ' + contador);
            update orgs;
        }
        catch(Exception e) {
            System.debug('Upsert CPF failed '+ e.getMessage());
        }
    } */
    public static void updateLastSync(List<IntegrationSetup__c> orgs) {
        for(IntegrationSetup__c a : orgs) {
            a.LastSync__c = System.now();
        }
        update orgs;
    }
}