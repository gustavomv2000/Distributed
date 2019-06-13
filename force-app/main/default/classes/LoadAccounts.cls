global class LoadAccounts implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
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
            a.LastSync__c = Datetime.now();

            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + Token.getToken(a));
            
            res = http.send(req);

            if(res.getStatusCode() == 200) { 
                acct.addAll((List<Account>) JSON.deserialize(res.getBody(), List<Account>.class));
            }       
        }
        Integer contador = 0;
        for(Account ac : acct) {
            ac.Id = null;
            if(ac.Tipo__c == 'Pessoa Física' || ac.Tipo__c == 'PessoaFisica') {
                pf.add(ac);
                contador = contador + 1;
            }
            else {
                pj.add(ac);
                contador = contador + 1;
            }
        }

        upsertAccounts(pf, pj, contador);

        /* try {
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
        } */
    }    
    global void finish(Database.BatchableContext bc){} 

    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }

    public static void upsertAccounts(List<Account> pf, List<Account> pj, Integer contador) {
        try {
            System.debug('pj: '+pj);
            Schema.SObjectField loadpj = Account.CNPJ__c;
            Database.UpsertResult[] pjAdd = Database.upsert(pj, loadpj, false);
            System.debug('adds '+pjAdd);
            System.debug('Contas a adicionar: ' + contador);
            //update orgs;
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
            //update orgs;
        }
        catch(Exception e) {
            System.debug('Upsert CPF failed '+ e.getMessage());
        }
    }
 
}

