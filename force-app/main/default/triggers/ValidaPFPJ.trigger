trigger ValidaPFPJ on Account (before insert, before update) {
    for(Account a: Trigger.new) {
        if(a.LastUpdate__c == null) {
            a.LastUpdate__c = System.now();
        }
        if(a.Tipo__c == 'Pessoa Física') {
            if(a.CPF__c == null) {
                a.addError('Digite um CPF válido');
            }
            else {    
                if(Valida.validaCPF(a.CPF__c)) {
                    a.CNPJ__c = null;
                    a.CPF__c = a.CPF__c.replaceAll('\\D','');  
                    a.CPF__c = Valida.formatCPF(a.CPF__c);
                }
                else {
                    a.addError('CPF inválido');
                }
            }    
        }
        else {
            if(a.CNPJ__c == null) {
                a.addError('Digite um CNPJ válido');
            }
            else {
                if(Valida.validaCNPJ(a.CNPJ__c)) {
                    a.CPF__c = null;
                    a.CNPJ__c = a.CNPJ__c.replaceAll('\\D','');
                    System.debug('Linha 34');
                    a.CNPJ__c = Valida.formatCNPJ(a.CNPJ__c);
                }
                else {
                    a.addError('CNPJ inválido');
                }
            }
        }
    }
    
}