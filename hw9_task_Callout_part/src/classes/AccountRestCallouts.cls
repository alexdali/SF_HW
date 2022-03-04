/**
 * Task description:
 *
 * On the 2st org:
 * - Implement a new class and methods
 * for each method of REST web service from the 1st org
 */

public class AccountRestCallouts {
    // Inner wrapper classes used to deserialize JSON response body
    public class RespAccount {
        public String id;
        public String name;
        public String accountNumber;
        public String phone;
        Attributes attributes;
    }
    // Attributes wrapper inner class
    public class Attributes {
        public String type;
        public String url;
    }

    public static Http http = new Http();
    public static HttpResponse response;
    public static HttpRequest request;
    // GET callout
    public static HttpResponse getAccount(Id accId) {
        request = new HttpRequest();
        request.setEndpoint('callout:FirstOrgAccountAPI/services/apexrest/Accounts/' + accId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into wrapper Apex class.
            RespAccount respAccount = (RespAccount) JSON.deserialize(response.getBody(), RespAccount.class);
            System.debug('respAccount.attributes.type: ' + respAccount.attributes.type);
            System.debug('respAccount.attributes.url: ' + respAccount.attributes.url);
            System.debug('respAccount.id: ' + respAccount.id);
            System.debug('respAccount.name: ' + respAccount.name);
            System.debug('respAccount.accountNumber: ' + respAccount.accountNumber);
            System.debug('respAccount.phone: ' + respAccount.phone);
            System.debug('respAccount: ' + respAccount);
        }
        return response;
    }
    public static HttpResponse deleteAccount(String accId) {
        request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('callout:FirstOrgAccountAPI/services/apexrest/Accounts/' + accId);
        response = http.send(request);
        // check response Status Code
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response status code: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            System.debug(response.getBody());
        }
        return response;
    }
    public static HttpResponse postAccount(String accountJson) {
        request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:FirstOrgAccountAPI/services/apexrest/Accounts/');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(accountJson);
        HttpResponse response = http.send(request);
        // check response Status Code
        System.debug('response.getBody(): ' + response.getBody());
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response status code: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
        return response;
    }
    public static HttpResponse putAccount(String accountJson) {
        request = new HttpRequest();
        request.setMethod('PUT');
        request.setEndpoint('callout:FirstOrgAccountAPI/services/apexrest/Accounts/');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(accountJson);
        HttpResponse response = http.send(request);
        // check response Status Code
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response status code: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            System.debug(response.getBody());
        }
        return response;
    }
    public static HttpResponse patchAccount(String accId, String accountJson) {
        request = new HttpRequest();
        request.setMethod('PATCH');
        request.setEndpoint('callout:FirstOrgAccountAPI/services/apexrest/Accounts/' + accId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(accountJson);
        HttpResponse response = http.send(request);
        // check response Status Code
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('response status code: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            System.debug(response.getBody());
        }
        return response;
    }
}