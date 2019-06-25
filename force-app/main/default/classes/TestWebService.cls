@IsTest
private class TestWebService {
    @isTest static void testGet() {
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='https://na132.salesforce.com/services/apexrest/Account/?Pagina=1';
        request.httpMethod = 'GET';
        RestContext.request = request;
        addAccount();
        // Call the method to test
        Test.startTest();
        List<Account> a = new List<Account>();
        a = AccountLoader.getRecord();
        // Verify results
        System.debug('Lista' + a);
        System.debug([SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name FROM Account].size());
        System.assertEquals(a.size(), [SELECT Name FROM Account].size());
        Test.stopTest();
    }
    @isTest static void testGetNoParameter() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://na132.salesforce.com/services/apexrest/Account/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        addAccount();
        Test.startTest();
        List<Account> a = new List<Account>();
        a = AccountLoader.getRecord();
        System.assertEquals(a.size(), [SELECT Name FROM Account].size());
        Test.stopTest();
    }
    public static void addAccount() {
        List<Account> test = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test';
        ac.Tipo__c = 'Pessoa Física';
        ac.CPF__c = '47896393808';
        test.add(ac);
        insert test;
    }
}