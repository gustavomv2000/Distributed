@IsTest
private class TestWebService {
    @isTest static void testGet() {
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='https://na132.salesforce.com/serices/apexrest/Account/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        List<Account> a = AccountLoader.getRecord();
        // Verify results
        System.debug('Lista' + a);
        System.debug([SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name FROM Account ORDER BY SystemModStamp DESC].size());
        system.assertEquals(a.size(), [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name FROM Account ORDER BY SystemModStamp DESC].size());
    }
}