public class Valida {
    public static Boolean validaCPF(String cpf) {
        String newCPF = cpf.replaceAll('\\D','');
        
        if (newCPF.equals('00000000000') || newCPF.equals('11111111111') ||
        newCPF.equals('22222222222') || newCPF.equals('33333333333') ||
        newCPF.equals('44444444444') || newCPF.equals('55555555555') ||
        newCPF.equals('66666666666') || newCPF.equals('77777777777') ||
        newCPF.equals('88888888888') || newCPF.equals('99999999999'))
        return(false);

        Integer priDig, segDig, soma=0, num, mult=10;
        String[] cpfString = newCPF.split('');
        for(Integer i = 0; i < 9; i++){
            num = Integer.valueOf(cpfString[i]);
            soma = soma + (num * mult);
            mult = mult - 1;
        }
        priDig = 11 - (math.mod((soma),11));
        if(priDig == 11 || priDig == 10){
            priDig = 0;
        }
        if(priDig == Integer.valueOf(cpfString[9])){
            soma=0;
            mult=11;
            for(Integer i = 0; i < 10; i++){
                num = Integer.valueOf(cpfString[i]);
                soma = soma + (num * mult);
                mult = mult - 1;
            }
            segDig = 11 - (math.mod((soma),11));
            if(segDig == 11 || segDig == 10){
                segDig = 0;
            }
            if(segDig == Integer.valueOf(cpfString[10])){
                return true;       
            }
        }
        return false;
    }
    public static Boolean validaCNPJ(String cnpj) {
        String newCNPJ =cnpj.replaceAll('[^a-zA-Z0-9\\s+]', '');
        
        if (newCNPJ.equals('00000000000000') || newCNPJ.equals('11111111111111') ||
        newCNPJ.equals('22222222222222') || newCNPJ.equals('33333333333333') ||
        newCNPJ.equals('44444444444444') || newCNPJ.equals('55555555555555') ||
        newCNPJ.equals('66666666666666') || newCNPJ.equals('77777777777777') ||
        newCNPJ.equals('88888888888888') || newCNPJ.equals('99999999999999'))
        return false;

        Integer i, num, priDig, segDig, soma = 0, mult = 2;
        String [] cnpjString = newCNPJ.split('');
        for(i = 11; i >= 0; i--) {
            num = Integer.valueOf(cnpjString[i]);
            soma = soma + (num * mult);
            mult = mult + 1;
            if(mult == 10) {
                mult = 2;
            }
        }
        priDig = math.mod((soma),11); 
        if(priDig < 2) {
            priDig = 0;
        }
        else {
            priDig = 11 - priDig;
        }
        if(priDig == Integer.valueOf(cnpjString[12])) {
            
            soma = 0;
            mult = 2;
            for(i = 12; i >= 0; i--) {
                num = Integer.valueOf(cnpjString[i]);
                soma = soma + (num * mult);
                mult = mult + 1;
                if(mult == 10) {
                    mult = 2;
                }
            }
            segDig = math.mod((soma),11); 
        
            if(segDig < 2) {
                segDig = 0;
            }
            else {
                segDig = 11 - segDig;
            }

            if(segDig == Integer.valueOf(cnpjString[13])){
                return true;
            }
        }
        return false;
    }
    public static String formatCPF(String cpf) {
        String cpfFormat = '';
        for(Integer i = 1; i < 3; i++) {
            cpfFormat = cpfFormat + cpf.substring(3 * (i - 1) ,3 * i);
            cpfFormat = cpfFormat + '.';
        }
        cpfFormat = cpfFormat + cpf.substring(6, 9) + '-' + cpf.substring(9,11);
        return cpfFormat;
    }
    public static String formatCNPJ(String cnpj) {
        cnpj = cnpj.replaceAll('[^a-zA-Z0-9\\s+]', '');
        String cnpjFormat = '';
        cnpjFormat = cnpj.substring(0,2) + '.';
        cnpjFormat = cnpjFormat + cnpj.substring(2,5) + '.';
        cnpjFormat = cnpjFormat + cnpj.substring(5,8) + '/';
        cnpjFormat = cnpjFormat + cnpj.substring(8,12) + '-' + cnpj.substring(12,14);
        return cnpjFormat;
    }
}