global class WhatsAppUtils {
    @future(callout=true)
    global static void sendTemplateMessage(String toPhone, String URL, String carerNames, String serviceName, String clientName, String companyName, DateTime ServiceDate){
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint('https://graph.facebook.com/v17.0/135746729629570/messages');
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('Authorization','Bearer '+System.Label.WHATSAPPACCESSTOKEN);
        
        String messageBody='{' +
            '    "messaging_product": "whatsapp",' +
            '    "recipient_type": "individual",' +
            '    "to": "' + toPhone + '",' +
            '    "type": "template",' +
            '    "template": {' +
            '        "name": "carer_schedule_service_template",' +
            '        "language": {' +
            '            "code": "en_us"' +
            '        },' +
            '        "components": [' +
            '            {' +
            '                "type": "header",' +
            '                "parameters": [' +
            '                    {' +
            '                        "type": "image",' +
            '                        "image": {' +
            '                            "link": "' + URL + '"' +
            '                        }' +
            '                    }' +
            '                ]' +
            '            },' +
            '            {' +
            '                "type": "body",' +
            '                "parameters": [' +
            '                    {' +
            '                        "type": "text",' +
            '                        "text": "' + carerNames + '"' +
            '                    },' +
            '					 {' +
            '                        "type": "text",' +
            '                        "text": "' + companyName + '"' +
            '                    },' +	
            '                    {' +
            '                        "type": "text",' +
            '                        "text": "' + serviceName + '"' +
            '                    },' +
            '                    {' +
            '                        "type": "text",' +
            '                        "text": "' + clientName + '"' +
            '                    },' +
            '                    {' +
            '                        "type": "date_time",' +
            '                        "date_time": {' +
            '                            "fallback_value": "'+ServiceDate+'",' +
            '                           }' +
            '                    }' +
            '                ]' +
            '            },'+
            '		]' +
            '    }' +
            '}';
        httpReq.setBody(messageBody);
        System.debug('messageBody:'+messageBody);
        
        Http http = new Http();
        
        
        try{
            system.debug('httpReq:'+httpReq);
            HttpResponse response = http.send(httpReq);
            if(response.getStatusCode() == 200){
                system.debug('Response:'+response.getStatusCode());
                WhatsAppUtils responseFromWA = (WhatsAppUtils) JSON.deserialize(response.getBody() , WhatsAppUtils.class);  
                system.debug('responseFromWA:'+responseFromWA);
            }
        }catch(System.CalloutException ex){
            System.debug('CalloutException Executed'+ ex.getStackTraceString());
            System.debug('CalloutException Executed'+ ex.getMessage());
        }catch(System.Exception ex){
            System.debug('System.Exception Executed'+ ex.getStackTraceString());
        }
    }
    @future(callout=true)
    global static void serviceMessage(String toClientPhone, String carerURL, String carerNames, String serviceName, String clientName, String companyName,DateTime ServiceDate){
        HttpRequest httpReq1 = new HttpRequest();
        httpReq1.setEndpoint('https://graph.facebook.com/v17.0/135746729629570/messages');
        httpReq1.setMethod('POST');
        httpReq1.setHeader('Content-Type','application/json');
        httpReq1.setHeader('Authorization','Bearer '+System.Label.WHATSAPPACCESSTOKEN);
        
        String messageBody='{' +
            '    "messaging_product": "whatsapp",' +
            '    "recipient_type": "individual",' +
            '    "to": "' + toClientPhone + '",' +
            '    "type": "template",' +
            '    "template": {' +
            '        "name": "service_message",' +
            '        "language": {' +
            '            "code": "en_us"' +
            '        },' +
            '        "components": [' +
            '            {' +
            '                "type": "header",' +
            '                "parameters": [' +
            '                    {' +
            '                        "type": "image",' +
            '                        "image": {' +
            '                            "link": "' + carerURL + '"' +
            '                        }' +
            '                    }' +
            '                ]' +
            '            },' +
            '            {' +
            '                "type": "body",' +
            '                "parameters": [' +
            '                    {' +
            '                        "type": "text",' +
            '                        "text": "' + clientName + '"' +
            '                    },' +
            '					 {' +
            '                        "type": "text",' +
            '                        "text": "' + companyName + '"' +
            '                    },' +	
            '                    {' +
            '                        "type": "text",' +
            '                        "text": "' + serviceName + '"' +
            '                    },' +
            '                    {' +
            '                        "type": "text",' +
            '                        "text": "' + carerNames + '"' +
            '                    },' +
            '                    {' +
            '                        "type": "date_time",' +
            '                        "date_time": {' +
            '                            "fallback_value": "'+ServiceDate+'",' +
            '                         }' +
            '                    }' +
            '                ]' +
            '            },'+
            '		]' +
            '    }' +
            '}';
        httpReq1.setBody(messageBody);
        System.debug('messageBody:'+messageBody);
        
        Http http1 = new Http();
        
        
        try{
            system.debug('httpReq1:'+httpReq1);
            HttpResponse response1 = http1.send(httpReq1);
            if(response1.getStatusCode() == 200){
                system.debug('Response:'+response1.getStatusCode());
                WhatsAppUtils responseFromWA = (WhatsAppUtils) JSON.deserialize(response1.getBody() , WhatsAppUtils.class);  
                system.debug('responseFromWA:'+responseFromWA);
            }
        }catch(System.CalloutException ex){
            System.debug('CalloutException Executed'+ ex.getStackTraceString());
            System.debug('CalloutException Executed'+ ex.getMessage());
        }catch(System.Exception ex){
            System.debug('System.Exception Executed'+ ex.getStackTraceString());
        }
    }
    
    public String messaging_product;	//whatsapp
    public contacts[] contacts;
    public messages[] messages;
    public class contacts {
        public String input;	//919445820981
        public String wa_id;	//919445820981
    }
    public class messages {
        public String id;	//wamid.HBgMOTE5NDQ1ODIwOTgxFQIAERgSNjdBMEYwRTc1MTM2MEVEMjA2AA==
        public String message_status;	//accepted
    }
    
    
}