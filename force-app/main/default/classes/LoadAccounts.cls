global class LoadAccounts implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
    
    //public Boolean isFinished = true;
    
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

        acct = addAccountsFromOrg(orgs, acct);

        pf = splitAccounts(acct, 'pf');

        pj = splitAccounts(acct, 'pj');

        upsertAccounts(pf, pj);

        updateLastSync(orgs);
    }    
    global void finish(Database.BatchableContext bc){
        /* if(isFinished == false) {
            Database.executeBatch(new LoadAccounts(),1);
        } */
    } 

    public static List<Account> addAccountsFromOrg(List<IntegrationSetup__c> orgs, List<Account> acct) {
        
        for(IntegrationSetup__c a : orgs) {    

            Http http = new Http();
            HttpRequest req =  new HttpRequest();
            HttpResponse res = new HttpResponse();
            
            if(a.LastSync__c != null) {
                req.setEndpoint(a.EndPointURL__c + '?LastSync=' + EncodingUtil.urlEncode(String.valueOf(a.LastSync__c), 'UTF-8'));    
            }
            else {
                req.setEndpoint(a.EndPointURL__c);    
            }
            System.debug('endpoint: '+ req.getEndpoint());

            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + Token.getToken(a));
            
            res = http.send(req);

            if(res.getStatusCode() == 200) { 
                System.debug('Status 200');
                acct.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
            }   
            else {
                System.debug('Erro!');
            }    
        }
        return acct;
    }
    public static List<Account> splitAccounts(List<Account> acct, String type) {
        List<Account> separated = new List<Account>();
        if(type.equals('pf')) {
            for(Account ac : acct) {
                System.debug('Nome'+ ac.name);
                if(ac.Tipo__c == 'Pessoa Física' || ac.Tipo__c == 'PessoaFisica') {
                separated.add(ac);
                }
            }
        }
        if(type.equals('pj')) {
            for(Account ac : acct) {
                if(ac.Tipo__c == 'Pessoa Jurídica' || ac.Tipo__c == 'PessoaJuridica') {
                    separated.add(ac);
                }
            }
        }
        return separated;
    }
    public static void upsertAccounts(List<Account> pf, List<Account> pj) {
        try {
            System.debug('pj: '+pj);

            System.debug('Antes upsert');
            Schema.SObjectField loadpj = Account.CNPJ__c;
            Database.UpsertResult[] pjAdd = Database.upsert(pj, loadpj, false);
            System.debug('Depois upsert');

            System.debug('adds '+pjAdd);
            System.debug('Contas a adicionar: ' + pj.size());
            //update orgs;
        }
        catch(Exception e) {
            System.debug('Upsert CNPJ failed '+ e.getMessage());
        }
        try {
            System.debug('pf: '+pf);

            System.debug('Antes upsert');
            Schema.SObjectField loadpf = Account.CPF__c;
            Database.UpsertResult[] pfAdd = Database.upsert(pf, loadpf, false);
            System.debug('Depois upsert');

            System.debug('adds '+pfAdd);
            System.debug('Contas a adicionar: ' + pf.size());
            //update orgs;
        }
        catch(Exception e) {
            System.debug('Upsert CPF failed '+ e.getMessage());
        }
    }
    public static void updateLastSync(List<IntegrationSetup__c> orgs) {
        for(IntegrationSetup__c a : orgs) {
            a.LastSync__c = System.now();
        }
        update orgs;
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
}

