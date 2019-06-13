@isTest
public class TriggerCases {
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
}
