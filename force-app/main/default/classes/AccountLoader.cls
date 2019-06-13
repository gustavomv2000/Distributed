@RestResource(urlMapping='/Account/')
global with sharing class AccountLoader {
    @HttpGet
    global static List<Account> getRecord() {
        
        RestRequest request = RestContext.request;
        String LastSync = request.params.get('LastSync');
        Integer pagina = Integer.valueOf(request.params.get('Pagina'));
        Integer offSet = 0;
        Integer limitLoad = 50;
        List<Account> result = new List<Account>();

        if(pagina != 0 && pagina > 0) {
            offSet = pagina * limitLoad;
        }
        else {
            pagina = 0;
        }

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