@RestResource(urlMapping='/Account/')
global with sharing class AccountLoader {
    @HttpGet
    global static List<Account> getRecord() {
        
        RestRequest request = RestContext.request;
        String LastSync = request.params.get('LastSync');
        String pagina = request.params.get('Pagina');
        Integer numPage;
        Integer offSet = 0;
        Integer limitLoad = 75;
        List<Account> result = new List<Account>();

        if(pagina == null) {
            System.debug('Pagina 0');
            numPage = 0;
        }
        else {
            numPage = Integer.valueOf(pagina);
        }

        offSet = numPage * limitload;

        try {
            result =  [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name FROM Account WHERE SystemModStamp >= :Datetime.valueOfGmt(LastSync) ORDER BY SystemModStamp  ASC LIMIT :limitLoad OFFSET :offSet];
        }
        catch(Exception e) {
            result =  [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name FROM Account ORDER BY SystemModStamp ASC LIMIT :limitLoad OFFSET :offSet];
            System.debug('Erro '+e.getMessage());
        }

        return result;

    }
}