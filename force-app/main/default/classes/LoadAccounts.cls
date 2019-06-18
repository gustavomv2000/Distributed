global class LoadAccounts implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.stateful {

    global Auxiliar saved = new Auxiliar();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Start');

        String query = 'SELECT UserName__c,Password__c,Token__c,ClientId__c,' + 
            'ClientSecret__c,EndPointURL__c, LastSync__c FROM IntegrationSetup__c' +
            ' WHERE IntegrationType__c = \'Account\'';

        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<IntegrationSetup__c> orgs){
        List<Account> acc = new List<Account>();
        List<Account> acct = new List<Account>();
        List<Account> pf = new List<Account>();
        List<Account> pj = new List<Account>();
        String pftipo = 'pf';
        String pjtipo = 'pj';
        Integer page = saved.page;
        
        acct = addAccountsFromOrg(orgs, acct, page);

        System.debug('Contas a adicionar: ' + acct.size());

        pf = splitAccounts(acct, pftipo);

        pj = splitAccounts(acct, pjtipo);
        
        System.debug('callouts: ' + saved.numCallouts);
        //upsertAccounts(pf, pj);

        //updateLastSync(orgs);
    }    
    global void finish(Database.BatchableContext bc){
        if(saved.isFinished == false) {
            Database.executeBatch(this);
        }
    } 
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    public List<Account> addAccountsFromOrg(List<IntegrationSetup__c> orgs, List<Account> acct, Integer page) {
        for(IntegrationSetup__c a : orgs) {     

            if(saved.org != null) {
                if(a != saved.org) 
                    continue;
            }

            Http http = new Http();
            HttpRequest req =  new HttpRequest();
            HttpResponse res = new HttpResponse();
            Boolean hasNext = true;

            loopCallouts(acct, a);

            for(; saved.numCallouts < 5; saved.numCallouts++) {
                List<Account> found = new List<Account>();
                if(a.LastSync__c != null) {
                    req.setEndpoint(a.EndPointURL__c + '?LastSync=' + EncodingUtil.urlEncode(String.valueOf(a.LastSync__c), 'UTF-8') + '&Pagina=' + page);    
                }
                else {
                    req.setEndpoint(a.EndPointURL__c + '?Pagina=' + page);    
                }

                System.debug('Number of callouts: ' + saved.numCallouts);

                System.debug('endpoint: '+ req.getEndpoint());

                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + Token.getToken(a));
                
                res = http.send(req);

                if(res.getStatusCode() == 200) { 
                    System.debug('Status 200');
                    found.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
                    acct.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
                }

                page += 1; 

                if(found.size() > 0 && saved.numCallouts == 4) {
                    saved.isFinished = false;
                    saved.org = a;
                    saved.page = page;
                    break;
                }
                
                if(found.size() == 0 && saved.numCallouts <= 4) { 
                    saved.isFinished = true;
                    page = 0;
                    saved.org = null;
                    saved.numCallouts = 0;
                }
                
                System.debug('finished ' + saved.isFinished);

                /* if(found.size() == 0 || numCallouts > 50) {
                    hasNext = false;
                } */
            }
            saved.isFinished = true;
        }
        return acct;
    }
    public static void loopCallouts(List<Account> acct, IntegrationSetup__c a) {
        for(; saved.numCallouts < 5; saved.numCallouts++) {
                List<Account> found = new List<Account>();
                if(a.LastSync__c != null) {
                    req.setEndpoint(a.EndPointURL__c + '?LastSync=' + EncodingUtil.urlEncode(String.valueOf(a.LastSync__c), 'UTF-8') + '&Pagina=' + page);    
                }
                else {
                    req.setEndpoint(a.EndPointURL__c + '?Pagina=' + page);    
                }

                System.debug('Number of callouts: ' + saved.numCallouts);

                System.debug('endpoint: '+ req.getEndpoint());

                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + Token.getToken(a));
                
                res = http.send(req);

                if(res.getStatusCode() == 200) { 
                    System.debug('Status 200');
                    found.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
                    acct.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
                }

                page += 1; 

                if(found.size() > 0 && saved.numCallouts == 4) {
                    saved.isFinished = false;
                    saved.org = a;
                    saved.page = page;
                    break;
                }
                
                if(found.size() == 0 && saved.numCallouts <= 4) { 
                    saved.isFinished = true;
                    page = 0;
                    saved.org = null;
                    saved.numCallouts = 0;
                }
                
                System.debug('finished ' + saved.isFinished);

                /* if(found.size() == 0 || numCallouts > 50) {
                    hasNext = false;
                } */
            }
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