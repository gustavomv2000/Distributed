@isTest
global class TesteBatch3 implements HttpCalloutMock {   
    global HttpResponse respond1(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"finished": "false","accounts": "[{\"attributes\":{\"type\":\"Account\",\"url\":\"/services/data/v46.0/sobjects/Account/0014P000029PWfgQAG\"}'+
        ',\"Name\":\"Teste Física 1 Zack\",\"Tipo__c\":\"Pessoa Física\",\"CPF__c\":\"241.202.699-81\",\"LastUpdate__c\":\"2019-06-26T16:39:36.000+0000\"'+
        ',\"LastModifiedDate\":\"2019-06-28T12:49:41.000+0000\",\"Id\":\"0014P000029PWfgQAG\"},{\"attributes\":{\"type\":\"Account\",\"url\":\"/services/data/v46.0/sobjects/Account/0014P000029PWfhQAG\"}}');
        res.setStatusCode(200);
        return res;
    }
    global
}
