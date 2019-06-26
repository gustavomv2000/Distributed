@RestResource(urlMapping='/Account/')
global with sharing class AccountLoader {
    @HttpGet
    global static List<Account> getRecord() {
        
        RestRequest request = RestContext.request;
        String LastSync = request.params.get('LastSync');
        String pagina = request.params.get('Pagina');
        Integer numPage;
        Integer limitLoad = 10;

        List<Account> result = new List<Account>();


        if(pagina == null) 
            numPage = 0;
        else 
            numPage = Integer.valueOf(pagina);

        List<Account> allAccounts = new List<Account>();

        try {
            allAccounts = [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name, LastModifiedDate FROM Account WHERE SystemModStamp >= :Datetime.valueOf(LastSync)];
        }
        catch(Exception e) {
            allAccounts = [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name, LastModifiedDate FROM Account];
        }
        for(Integer i = numPage*limitLoad; i < (numPage*limitLoad)+10 && i < allAccounts.size(); i++) {
            if(numPage*limitLoad <= allAccounts.size()) 
                result.add(allAccounts[i]);
        }
        return result;
    }
}