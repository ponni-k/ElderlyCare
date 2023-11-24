global class WhatsAppIntegrationQueueableHandler {
    //@InvocableMethod(label='ElderlyCareWhatsappMessage' description='Description of my method')
    global static void enqueueWhatsAppIntegrationJob(list<WhatsAppMessageParameters> inputvariable) {
       // WhatsAppIntegrationQueueable queueable = new WhatsAppIntegrationQueueable(toPhone, URL, carerName, serviceName, clientName);
        for(WhatsAppMessageParameters parameter :inputvariable){
             System.enqueueJob(new WhatsAppIntegrationQueueable(parameter.toPhone,parameter.URL,parameter.carerName,parameter.serviceName,parameter.clientName));
        }
       
    }
    global class WhatsAppMessageParameters {
        @InvocableVariable
         global String toPhone; 
         @InvocableVariable
       global String URL;
         @InvocableVariable
       global String carerName;
         @InvocableVariable
       global String serviceName;
         @InvocableVariable
       global String clientName;
    }
}