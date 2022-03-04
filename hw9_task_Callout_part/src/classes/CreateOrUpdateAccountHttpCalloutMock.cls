/**
 * Task description:
 *
 * Test the integration between two orgs
 * Mock Class for testing POST, PUT, PATCH methods
 */

@IsTest
global class CreateOrUpdateAccountHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HttpRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"0017Q000006pYBRQA2"}');
        response.setStatusCode(200);
        return response;
    }
}