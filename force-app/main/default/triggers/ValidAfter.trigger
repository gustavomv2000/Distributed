trigger ValidAfter on Account (before insert) {
    List<Account> orgDefault = [SELECT Id, Name, CPF__c, CNPJ__c, Tipo__c FROM Account];
    List<Account> acct = new List<Account>();
    acct = Trigger.new;
    for(Account acc : acct) {
        for(Integer i = 0; i < orgDefault.size(); i++) {
            Account org = orgDefault[i];
            if(acc.CPF__c == org.CPF__c || acc.CNPJ__c == org.CNPJ__c) {
                if(acc.LastUpdate__c < org.LastUpdate__c) {
                    acct.remove(acct.indexOf(acc));
                }
            }
        }
    }
    insert acct;
}