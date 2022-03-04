/**
 * Task description:
 *
 * Test the integration between two orgs.
 * Test Apex Callout Class with HttpCalloutMock
 */

@IsTest
public with sharing class AccountRestCalloutsTest {

    public static String accId = '0017Q000006pYBRQA2';
    public static String accJson = '{"name":"TEST POST","accNumber":"AN0000","phone":"(111) 11111111"}';
    public static String expectedValue = '{"0017Q000006pYBRQA2"}';

    @IsTest
    static void testGetCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GetAccountHttpCalloutMock());
        HttpResponse response = AccountRestCallouts.getAccount(accId);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = '{"attributes":{"type":"Account","url":"/services/data/v53.0/sobjects/Account/0017Q000006pYBRQA2"},"Id":"0017Q000006pYBRQA2","Name":"sForce","AccountNumber":"AN123","Phone":"(415) 901-7000"}';
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testDeleteCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new DeleteAccountHttpCalloutMock());
        HttpResponse response = AccountRestCallouts.deleteAccount(accId);
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testPostCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CreateOrUpdateAccountHttpCalloutMock());
        HttpResponse response = AccountRestCallouts.postAccount(accJson);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testPutCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CreateOrUpdateAccountHttpCalloutMock());
        HttpResponse response = AccountRestCallouts.putAccount(accJson);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @IsTest
    static void testPatchCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CreateOrUpdateAccountHttpCalloutMock());
        HttpResponse response = AccountRestCallouts.patchAccount(accId, accJson);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
}