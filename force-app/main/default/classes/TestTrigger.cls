@isTest
private class TestTrigger {
    @isTest
    static void testTrigger() {
        String assert;
        Test.startTest();

            assert = CPFInvalido();
            System.assertEquals('Erro', assert);

        Test.stopTest();
    }
    @isTest
    static void testTrigger1() {
        String assert;
        Test.startTest();

            assert = CPFValido();
            System.assertEquals('Passou', assert);

        Test.stopTest();
    }
    @isTest
    static void testTrigger2() {
        String assert;
        Test.startTest();

            assert = CPFVazio();
            System.assertEquals('Erro', assert);

        Test.stopTest();
    }
    @isTest
    static void testTrigger3() {
        String assert;
        Test.startTest();

            assert = CNPJInvalido();
            System.assertEquals('Erro', assert);

        Test.stopTest();
    }
    @isTest
    static void testTrigger4() {
        String assert;
        Test.startTest();

            assert = CNPJValido();
            System.assertEquals('Passou', assert);

        Test.stopTest();
    }
    @isTest
    static void testTrigger5() {
        String assert;
        Test.startTest();

            assert = CNPJVazio();
            System.assertEquals('Erro', assert);

        Test.stopTest();
    }



    @isTest
    public static String CPFInvalido() {
        Account acct = new Account(Name = 'Teste',Tipo__c = 'Pessoa Física', CPF__c = '11111111111');
        try {
            insert acct;
        }
        catch(Exception e) {
            return 'Erro';
        }
        return 'Passou';
    }
    @isTest
    public static String CPFValido() {
        Account acct = new Account(Name = 'Teste 1',Tipo__c = 'Pessoa Física', CPF__c = '478.963.938-08');
        try {
            insert acct;
        }
        catch(Exception e) {
            return 'Erro';
        }
        return 'Passou';
    }
    @isTest
    public static String CPFVazio() {
        Account acct = new Account(Name = 'Teste 2',Tipo__c = 'Pessoa Física');
        try {
            insert acct;
        }
        catch(Exception e) {
            return 'Erro';
        }
        return 'Passou';
    }
    @isTest
    public static String CNPJInvalido() {
        Account acct = new Account(Name = 'Teste 3',Tipo__c = 'Pessoa Jurídica', CNPJ__c = '11111111111111');
        try {
            insert acct;
        }
        catch(Exception e) {
            return 'Erro';
        }
        return 'Passou';
    }
    @isTest
    public static String CNPJValido() {
        Account acct = new Account(Name = 'Teste 4',Tipo__c = 'Pessoa Jurídica', CNPJ__c = '51.458.647/0001-00');
        try {
            insert acct;
        }
        catch(Exception e) {
            return 'Erro';
        }
        return 'Passou';
    }
    @isTest
    public static String CNPJVazio() {
        Account acct = new Account(Name = 'Teste 5',Tipo__c = 'Pessoa Jurídica');
        try {
            insert acct;
        }
        catch(Exception e) {
            return 'Erro';
        }
        return 'Passou';
    }

}