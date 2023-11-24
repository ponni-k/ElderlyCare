@RestResource(urlMapping='/whatsapp/webhooks/v1/*')
global class WhatsAppWebhook { 
    
    private static Final String SIGNATURE_VALID_MESSAGE = 'Signature Verified';
    private static FInal String SIGNATURE_NOT_VALID_MESSAGE ='Signature could not be verified';
    
    @HttpGet
    global static void doGet()
    {
        RestResponse response= RestContext.response;
        RestRequest request= RestContext.request;
        if(request.params.get('hub.verify_token')== 'WHATSAPPTOKEN'){
            response.responseBody =Blob.valueOf( request.params.get('hub.challenge'));
        }
        
    }
    
    @HttpPost
    global static void doPost(){
        
        RestResponse response = RestContext.response;
        response.addHeader('Content-type', 'application/json');
        String responseString = RestContext.request.requestBody.toString();
        Map<String,String> headers = RestContext.request.headers;
        String responseValid = validateWhatsAppSignature(RestContext.request, responseString);
        
        if(responseValid == SIGNATURE_VALID_MESSAGE){
            System.debug(System.LoggingLevel.DEBUG, ' Headers Response From WhatsApp \n  '+ JSON.serialize(headers) );
            System.debug(System.LoggingLevel.DEBUG, ' Response From WhatsApp \n  '+ responseString);
            // Now payloadValues contains all the "payload" values
            //System.debug(payloadValues);
            String jsonString = responseString; // Your JSON string here
            RootObject root = (RootObject)JSON.deserialize(jsonString, RootObject.class);
            
            // Now you can access and store payload values
            List<Message> messages = root.entry[0].changes[0].value.messages;
            for (Message message : messages) {
                String payload = message.button.payload;
                
                String text = message.button.text;
                // Store or process the payload as needed
                System.debug('Payload: ' + payload);
                System.debug('Text: ' + text);
                //Button btn = new Button();
               // ElderlyCare.updateStatusEvent('null',text);
            }
            
        }else{
            response.responseBody = Blob.valueOf('{success:false, event:"Unknown","message:"'+responseValid+'"}');
            response.statusCode = 401;
            return;
        }
        
        response.statusCode = 200;
        response.responseBody = Blob.valueOf('{success:true, event:"success"}');
    }
    
    private static String validateWhatsAppSignature(RestRequest request, String responseString) {
        // Validate Stripe signature Start 
        Map<String, String> headers = request.headers;
        
        String whatsAppSignature = headers.get('X-Hub-Signature-256');
        
        String whatsAppPayload = RestContext.request.requestBody.toString();
        
        // Verify the signature using 'hmacSHA256'. I have the Webhook key stored in a Custom Label
        String whatsAppSecret = System.Label.WHATSAPPSECRET; // Facebook Application Secret Key
        Blob signedPayload = Crypto.generateMac('hmacSHA256', Blob.valueOf(whatsAppPayload), Blob.valueOf( whatsAppSecret ));
        
        String encodedPayload = 'sha256='+EncodingUtil.convertToHex(signedPayload);
        // Return status code based on whether signed payload matches or not
        
        String response = (encodedPayload == whatsAppSignature)? SIGNATURE_VALID_MESSAGE : SIGNATURE_NOT_VALID_MESSAGE;
        return response;
        // Validate Stripe signature End 
    }
    public class RootObject {
        
        public List<Entry> entry;
    }
    
    public class Entry {
        public String id;
        public List<Change> changes;
    }
    
    public class Change {
        public Value value;
    }
    
    public class Value {
        public String messaging_product;
        public Metadata metadata;
        public List<Contact> contacts;
        public List<Message> messages;
    }
    
    public class Metadata {
        public String display_phone_number;
        public String phone_number_id;
    }
    
    public class Contact {
        public Profile profile;
        public String wa_id;
    }
    
    public class Profile {
        public String name;
    }
    
    public class Message {
        public Context context;
        public String fromx;
        public String id;
        public String timestamp;
        public String typex;
        public Button button;
    }
    
    public class Context {
        public String fromx;
        public String id;
    }
    
    public class Button {
        public String payload;
        public String text;
    }
    
}