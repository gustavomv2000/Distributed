public with sharing class Token {
    public static String getToken(IntegrationSetup__c a) {
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        request.setMethod('POST');
        request.setBody('grant_type=password&' + 'client_id=' + a.ClientId__c 
        + '&client_secret=' + a.ClientSecret__c + '&username=' + a.UserName__c 
        + '&password=' + a.Password__c + a.Token__c);

        response = http.send(request);
        system.debug('After send request');

        if(response.getStatusCode() == 200) {
            system.debug('response '+ response.getBody());
            try {
                Map<String, String> responseBody = (Map<String,String>) JSON.deserialize(response.getBody(), Map<String, String>.class);
                System.debug('Get token response: ' + responseBody);
                return responseBody.get('access_token');
            }
            catch(Exception e) {
                System.debug('Erro Token');
            }
        }
        else {
            system.debug('Request '+request.getBody());
            system.debug('response '+response.getBody());
        }
        return null;
    }
}
