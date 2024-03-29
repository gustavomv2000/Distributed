@isTest
private class TestSchedule {
    @testSetup 
    static void setup() {
        List<IntegrationSetup__c> orgs = new List<IntegrationSetup__c>();
        IntegrationSetup__c org = new IntegrationSetup__c();
            org.EndPointURL__c='https://na132.salesforce.com/services/apexrest/Account/';
            org.UserName__c='gustavo.vieira@nescara.academy.com';
            org.Password__c='morales12345';
            org.Token__c='LeZaTZ1HF6EenvYp4hGMOausE';
            org.ClientId__c='3MVG9IHf89I1t8hqah6E4X_Giula.r6_7.hDUTsFOnnd_po7qFru9px8ykPDjE_ehrSwqbrNYurzb8revQjMi';
            org.ClientSecret__c='896547E015019DE64757FFD8E53338BF3665141A0C36EAF5AD5BFE7466772843';
            org.IntegrationType__c = 'Account';
            orgs.add(org);
            insert orgs;
    }
    static testmethod void test() { 
        Test.setMock(HttpCalloutMock.class, new TesteBatch2());
        Test.startTest();
        LoadAccounts pa= new LoadAccounts();
        String cronStr = '0 30 * * * ?';
        System.schedule('aaa', '0 0 * * * ?', pa);
        Test.stopTest();
    }
    
}