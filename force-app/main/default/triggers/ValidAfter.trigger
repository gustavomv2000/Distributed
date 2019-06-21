trigger ValidAfter on Account (before insert) {
    List<Account> orgDefault = [SELECT Id, Name, CPF__c, CNPJ__c, Tipo__c FROM Account];
    List<Account> remove = new List<Account>();
    for(Account acc : Trigger.new) {
        for(Integer i = 0; i < orgDefault.size(); i++) {
            Account org = orgDefault[i];
            if(acc.CPF__c == org.CPF__c || acc.CNPJ__c == org.CNPJ__c) {
                if(acc.LastUpdate__c < org.LastUpdate__c) {
                    
                }
            }
        }
    }
}   