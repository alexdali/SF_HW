/**
 * Task description:
 *
 * Test the integration between two orgs.
 * Mock Class for testing DELETE method
 */

@IsTest
global class DeleteAccountHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HttpRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        return response;
    }
}