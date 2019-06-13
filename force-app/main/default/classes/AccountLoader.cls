@RestResource(urlMapping='/Account/')
global with sharing class AccountLoader {
    @HttpGet
    global static List<Account> getRecord() {
        RestRequest request = RestContext.request;
        String LastSync = request.params.get('LastSync');
        List<Account> result = new List<Account>();
        try {
            result =  [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name FROM Account WHERE SystemModStamp >= :Datetime.valueOfGmt(LastSync) ORDER BY SystemModStamp ASC];
        }
        catch(Exception e) {
            result =  [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name FROM Account ORDER BY SystemModStamp ASC];
            System.debug('Erro '+e.getMessage());
        }

        System.debug(result);

        result = addAccountsToList(result, 50);

        System.debug(result);

        return result;
    }

    private static List<Account> addAccountsToList(List<Account> result, Integer x) {
        for(Integer i = result.size() - 1; i >= x; i--) {
            result.remove(i);
        }
        return result;
    }
}