@isTest
global class TesteBatch2 implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"attributes": {"type": "Account","url": "/services/data/v45.0/sobjects/Account/0014P000027CY1JQAW"},'+
        '"Name": "Peter Parker","Tipo__c": "Pessoa Física","CPF__c": "491.715.060-47","LastUpdate__c": "2019-06-10T18:02:24.000+0000",'+
        '"SystemModstamp": "2019-06-10T18:02:24.000+0000","Id": "0014P000027CY1JQAW"}]');
        res.setStatusCode(200);
        return res; 
    }
}
