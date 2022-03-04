/**
 * Task description:
 *
 * Test the integration between two orgs.
 * Mock Class for testing GET method
 */

@IsTest
global class GetAccountHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HttpRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"attributes":{"type":"Account","url":"/services/data/v53.0/sobjects/Account/0017Q000006pYBRQA2"},"Id":"0017Q000006pYBRQA2","Name":"sForce","AccountNumber":"AN123","Phone":"(415) 901-7000"}');
        response.setStatusCode(200);
        return response;
    }
}