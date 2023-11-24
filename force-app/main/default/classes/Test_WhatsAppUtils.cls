@isTest
public class Test_WhatsAppUtils {
    @isTest
    public static void testSendTemplateMessage() {
        
        
        // Set up test data
        //WhatsAppUtils params = new WhatsAppUtils();
        String toPhone = 'whatsapp_number';
        String URL = 'https://example.com/image.jpg';
        String carerNames = 'Carer Name';
        String serviceName = 'Service Name';
        String clientName = 'Client Name';
        String companyName = 'Company Name';
        String toClientPhone = 'whatsapp_number';
        String carerURL = 'https://example.com/image.jpg';
        DateTime ServiceDate = datetime.newInstance(2014, 9, 15, 13, 30, 0);

        // Mock the HTTP callout
       // Test.setMock(HttpCalloutMock.class, new WhatsAppCalloutMock());

        // Call the method
        Test.startTest();
        WhatsAppUtils.sendTemplateMessage(
           toPhone,
            URL,
            carerNames,
            serviceName,
            clientName,
            companyName,
            ServiceDate
        );
        WhatsAppUtils.serviceMessage(toClientPhone, carerURL, carerNames, serviceName, clientName, companyName, ServiceDate);

        Test.stopTest();
    }
}