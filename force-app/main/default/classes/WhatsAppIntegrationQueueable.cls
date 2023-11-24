global class WhatsAppIntegrationQueueable implements Queueable {
    global String toPhone { get; set; }
    global String URL { get; set; }
    global String carerName { get; set; }
    global String serviceName { get; set; }
    global String clientName { get; set; }

    global WhatsAppIntegrationQueueable(String toPhone, String URL, String carerName, String serviceName, String clientName) {
        this.toPhone = toPhone;
        this.URL = URL;
        this.carerName = carerName;
        this.serviceName = serviceName;
        this.clientName = clientName;
    }

    global void execute(QueueableContext context) {
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint('https://graph.facebook.com/v17.0/135369036328048/messages');
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Bearer ' + System.Label.WHATSAPPACCESSTOKEN);

        String messageBody = '{' +
            '    "messaging_product": "whatsapp",' +
            '    "recipient_type": "individual",' +
            '    "to": "' + toPhone + '",' +
            '    "type": "template",' +
            '    "template": {' +
            '        "name": "schedule_services",' +
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
            '                        "text": "' + carerName + '"' +
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
            '                            "fallback_value": "October 25, 2023",' +
            '                            "day_of_week": 5,' +
            '                            "year": 2023,' +
            '                            "month": 10,' +
            '                            "day_of_month": 25,' +
            '                            "hour": 15,' +
            '                            "minute": 33,' +
            '                            "calendar": "GREGORIAN"' +
            '                        }' +
            '                    }' +
            '                ]' +
            '            },' +
            '             {' +
            '                "type": "button",' +
            '                "sub_type": "quick_reply",' +
            '                "index": "0",' +
            '                "parameters": [' +
            '                    {' +
            '                        "type": "payload",' +
            '                        "payload": "Yes"' +
            '                    }' +
            '                ]' +
            '            },' +
            '            {' +
            '                "type": "button",' +
            '                "sub_type": "quick_reply",' +
            '                "index": "1",' +
            '                "parameters": [' +
            '                    {' +
            '                        "type": "payload",' +
            '                        "payload": "No"' +
            '                    }' +
            '                ]' +
            '            }' +
            '        ]' +
            '    }' +
            '}';

        httpReq.setBody(messageBody);

        Http http = new Http();

        try {
            HttpResponse response = http.send(httpReq);
            if (response.getStatusCode() == 200) {
                WhatsAppUtils responseFromWA = (WhatsAppUtils) JSON.deserialize(response.getBody(), WhatsAppUtils.class);
            }
        } catch (System.CalloutException ex) {
            System.debug('CalloutException Executed' + ex.getStackTraceString());
            System.debug('CalloutException Executed' + ex.getMessage());
        } catch (System.Exception ex) {
            System.debug('System.Exception Executed' + ex.getStackTraceString());
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