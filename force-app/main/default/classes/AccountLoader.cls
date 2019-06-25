@RestResource(urlMapping='/Account/')
global with sharing class AccountLoader {
    @HttpGet
    global static List<Account> getRecord() {
        
        RestRequest request = RestContext.request;
        System.debug(request);
        String LastSync = request.params.get('LastSync');
        System.debug(LastSync); 
        String pagina = request.params.get('Pagina');
        System.debug(pagina);
        //Integer page = Integer.valueOf(pagina);      
        Integer numPage;
        System.debug(numPage);
        Integer limitLoad = 10;
        System.debug(limitLoad);

        List<Account> result = new List<Account>();


        if(pagina == null) 
            numPage = 0;
        else 
            //Integer page = Integer.valueOf(pagina);
            numPage = Integer.valueOf(pagina);

        List<Account> allAccounts = new List<Account>();

        try {
            allAccounts = [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name, LastModifiedDate FROM Account WHERE SystemModStamp >= :Datetime.valueOf(LastSync) ];
        }
        catch(Exception e) {
            allAccounts = [SELECT Tipo__c,CNPJ__c,CPF__c,LastUpdate__c,SystemModStamp,Name, LastModifiedDate FROM Account ];
        }
        for(Integer i = numPage*limitLoad; i < (numPage*limitLoad)+10 && i < allAccounts.size(); i++) {
            if(numPage*limitLoad <= allAccounts.size()) 
                result.add(allAccounts[i]);
        }
        return result;
    }
}