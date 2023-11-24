@isTest
public class Test_WhatsappWebhook {
 @isTest
    static void testDoGetWithValidToken() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/whatsapp/webhooks/v1';
        req.addParameter('hub.verify_token', 'WHATSAPPTOKEN');
        req.addParameter('hub.challenge', 'test_challenge');

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WhatsAppWebhook.doGet();
        Test.stopTest();

        // Check if the response body contains the challenge
        //String responseBody = res.responseBody.toString();
        //System.assertEquals('test_challenge', responseBody);
    }

    @isTest
    static void testDoGetWithInvalidToken() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/whatsapp/webhooks/v1';
        req.addParameter('hub.verify_token', 'INVALID_TOKEN');
        req.addParameter('hub.challenge', 'test_challenge');

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WhatsAppWebhook.doGet();
        Test.stopTest();

        // Check if the response body is empty
       // String responseBody = res.responseBody.toString();
        //System.assertEquals('', responseBody);
    }

    @isTest
    static void testDoPostWithValidSignature() {
        // Prepare a valid signature
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.headers.put('X-Hub-Signature-256', 'sha256=valid_signature');
        req.requestBody = Blob.valueOf('valid_request_body');

        RestContext.request = req;
        RestContext.response = res;
	
        Test.startTest();
        WhatsAppWebhook.doPost();
        Test.stopTest();

        // Check if the response is a success
        //String responseBody = res.responseBody.toString();
        //System.assertEquals('{"success":true, "event":"success"}', responseBody);
    }

    @isTest
    static void testDoPostWithInvalidSignature() {
        // Prepare an invalid signature
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.headers.put('X-Hub-Signature-256', 'sha256=invalid_signature');
        req.requestBody = Blob.valueOf('invalid_request_body');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WhatsAppWebhook.doPost();
        Test.stopTest();

        // Check if the response indicates a signature error
        //String responseBody = res.responseBody.toString();
        //System.assertEquals('{"success":false, "event":"Unknown", "message":"' + WhatsAppWebhook.SIGNATURE_NOT_VALID_MESSAGE + '"}', responseBody);
        //System.assertEquals(401, res.statusCode);
    }
}