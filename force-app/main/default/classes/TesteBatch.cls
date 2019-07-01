@isTest
private class TesteBatch {
    @testSetup 
    static void setup() {
        List<IntegrationSetup__c> orgs = new List<IntegrationSetup__c>();
        IntegrationSetup__c org = new IntegrationSetup__c();
            org.EndPointURL__c='https://na132.salesforce.com/services/apexrest/Account/';
            org.UserName__c='gustavo.vieira@nescara.academy.com';
            org.Password__c='morales12345';
            org.Token__c='OqmsV5sxvwNEpv61UFQraXhj';
            org.ClientId__c='3MVG9IHf89I1t8hqah6E4X_Giula.r6_7.hDUTsFOnnd_po7qFru9px8ykPDjE_ehrSwqbrNYurzb8revQjMi';
            org.ClientSecret__c='896547E015019DE64757FFD8E53338BF3665141A0C36EAF5AD5BFE7466772843';
            org.IntegrationType__c = 'Account';
            //orgs.LastSync__c = 
            orgs.add(org);
        
        IntegrationSetup__c org1 = new IntegrationSetup__c();
            org.EndPointURL__c='https://na132.salesforce.com/services/apexrest/Accounts';
            org.UserName__c='zack.correa%40nescara.academy.0001.com';
            org.Password__c='zack1234';
            org.Token__c='LPtBO3jUsHqN72tshS3EVYOs';
            org.ClientId__c='3MVG9IHf89I1t8hqhCZpj2S2z7EhHXtP177jdQqg0snMovoPjgqzKzDaITWC_T5GqTj4zkKk010hjt4Q08xL4';
            org.ClientSecret__c='09E08E7ADC7F379025FE0F114F508B80C6D590AC5E49EC6CF740875E8E2FF4B9';
            org.IntegrationType__c = 'Account';
            //orgs.LastSync__c = 
            orgs.add(org1);

        insert orgs;
        
    }
    static testmethod void test() { 
        Test.setMock(HttpCalloutMock.class, new TesteBatch2());
        Test.startTest();
            new LoadAccounts().start(null);
            new LoadAccounts().execute(null, [SELECT UserName__c,Password__c,Token__c,ClientId__c,ClientSecret__c,
            EndPointURL__c, LastSync__c FROM IntegrationSetup__c WHERE IntegrationType__c = 'Account']);
            new LoadAccounts().finish(null);
            List<Account> ins = [SELECT Name FROM Account WHERE Name = 'Peter Parker'];
        Test.stopTest();
    }
}