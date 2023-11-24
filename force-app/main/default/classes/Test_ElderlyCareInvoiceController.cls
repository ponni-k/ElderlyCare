@IsTest
public class Test_ElderlyCareInvoiceController {
    
    @IsTest
    public static void testElderlyCareInvoiceGenerationController() {
        
        Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='example11111@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           CompanyName = 'Zuddhisystems',
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@invalidTest.com');
        insert us;
        
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.BillingStreet = 'test street';
        acc.BillingCity = 'test city';
        acc.BillingState ='test state';
        acc.BillingCountry ='test country';
        acc.BillingPostalCode='43213';
        //acc.Company_Name__c = us.CompanyName;
        acc.Risk_Value_for_Pet__c='test1;test2';
        insert acc;
        
         Date invoiceStartDate = Date.newInstance(2023, 1, 1);
        Date invoiceEndDate = Date.newInstance(2023, 8, 31);
        
        
        
        carer__c cr = new carer__c();
        cr.Name = 'Test carer';
        cr.Hourly_Price__c = 3.81;
        cr.Availability__c ='Not Available';
        cr.Start_Date__c = system.now();
        cr.End_Date__c = system.now();
        cr.User_Name__c = us.id;
        insert cr;
        
        Time_Sheet__c ts = new Time_Sheet__c();
        ts.Start_Date__c = invoiceStartDate;
        ts.End_Date__c = invoiceEndDate;
        ts.Start_Time__c = Time.newInstance(11,5,2,7);
        ts.End_time__c=Time.newInstance(12,5,2,7);
        //ts.ClockIn_Location__Latitude__s = 37.123456;
        //ts.ClockIn_Location__Longitude__s = -122.987654;
        ts.Account_Name__c = acc.Id;
        ts.Carer_Name__c = cr.Id;
        //ts.Service_provider__r.Name=us.Name;
        insert ts;
        
        //list<Event> lstevet = new list<Event>();
        Event eve = new Event();
        eve.Location='test1';
        eve.IsAllDayEvent= True;
        //eve.AccountId = acc.Id;
        eve.ActivityDateTime=System.now();
        eve.ActivityDate=System.today();
        eve.StartDateTime= System.today();
        eve.EndDateTime= System.today();
        //eve.EndDate= System.today()+1;
        eve.Description='test description';
        eve.OwnerId = us.Id;
        eve.Subject='Aged Care';
        eve.Status__c='Not Started';
        eve.Care_Type__c='Gardening';
        eve.User__c=us.Id;
        eve.Time_Sheet__c = ts.id;
        eve.whatid = acc.Id;
        //lstevet.add(eve);
        insert eve;
        
       
        
        
        
        AgedCare_Product__c agedcare = new AgedCare_Product__c();
        agedcare.Name='Test Care';
        agedcare.Care_Type__c = 'Personal Care';
        agedcare.Price__c = 2.0;
        agedcare.Company_Name__c='agedcare';
        insert agedcare;
        
        // Create an instance of the controller
        ElderlyCareInvoiceGenerationController controller = new ElderlyCareInvoiceGenerationController();
        
        
        // Set test parameter values
        controller.clientname = 'Test Client';
        controller.billingstate = 'Test State';
        controller.billingcity= 'Test City';
        controller.billingstreet = 'Test street';
        controller.billingcountry='test country';
        controller.postalcode = '12345';
        controller.startdate = string.valueOf(invoiceStartDate);
        controller.invoicestartdate = invoiceStartDate;
        controller.invoiceenddate = invoiceEndDate;
        controller.clientid = acc.Id;
        controller.enddate =  string.valueOf(invoiceEndDate);
        DateTime currentDateTime = System.now();
        Time currentTime = currentDateTime.time();
        controller.starttime = string.valueOf(currentTime);
        controller.endtime = string.valueOf(currentTime);
        Double price = 3.25;
        controller.price = string.valueOf(price);
        controller.timeduration = string.valueOf(1.3);
        controller.timesheetid = ts.Id;
        controller.totalprice = '20';
        controller.serviceItem = agedcare.Name;
        Decimal gstPercentage = 10.00;
        Double baseValue = 100.00;
        Double GSTValue = (gstPercentage / 100);
        Decimal finalAmnt = 54;
        controller.TotalfinalAmountWithGST = finalAmnt;
        //controller.invoiceenddate = Date.today();
        //controller.invoiceenddate = Date.today().addDays(10);
        
        
        //Date invoiceStartDate = Date.today();
        //Date invoiceEndDate = Date.today().addDays(10);
        
       /* ApexPages.currentPage().getParameters().put('billingstate', acc.BillingState);
        ApexPages.currentPage().getParameters().put('billingcity', acc.BillingCity);
        ApexPages.currentPage().getParameters().put('billingstreet', acc.BillingStreet);
        ApexPages.currentPage().getParameters().put('billingcountry', acc.BillingCountry);
        ApexPages.currentPage().getParameters().put('postalcode', acc.BillingPostalCode);
        ApexPages.currentPage().getParameters().put('invoicestartdate', string.valueOf(ts.Start_Date__c));
        ApexPages.currentPage().getParameters().put('invoiceEndDate', String.valueOf(ts.End_Date__c));
        ApexPages.currentPage().getParameters().put('clientId', acc.Id);*/
        
        
        
        String clientId = acc.Id;
        
        
        
        
        
        //PageReference pageRef = Page.ElderlyCareInvoiceGeneration;
        PageReference pageRef = new PageReference('/apex/ElderlyCareInvoiceGeneration');
        system.debug('pageRef :'+pageRef);
        pageRef.getParameters().put('billingstate', acc.BillingState);
        pageRef.getParameters().put('billingcity', acc.BillingCity);
        pageRef.getParameters().put('billingstreet', acc.BillingStreet);
        pageRef.getParameters().put('billingcountry', acc.BillingCountry);
        pageRef.getParameters().put('postalcode', acc.BillingPostalCode);
        pageRef.getParameters().put('invoicestartdate', string.valueOf(ts.Start_Date__c));
        pageRef.getParameters().put('invoiceEndDate', String.valueOf(ts.End_Date__c));
        pageRef.getParameters().put('clientId', acc.Id);
        Test.setCurrentPage(pageRef);
        
        //pageRef.getParameters().put('invoicestartdate', '2023-07-01');
        
        //pageRef.getParameters().put('invoicestartdate', String.valueOf(invoiceStartDate));
        
        List<Time_Sheet__c> lstTimeSheet = [SELECT Id, Name, Account_Name__c, Account_Name__r.Name, Account_Name__r.Billingstate, Account_Name__r.BillingCity, Account_Name__r.BillingStreet, Account_Name__r.BillingCountry, Account_Name__r.BillingPostalCode, Service_provider__c, Start_Date__c, End_Date__c, Time_Duration__c, Price__c, Homecare_Product__c, Start_Time__c, End_time__c, AgedCare_Product__r.Name FROM Time_Sheet__c WHERE Account_Name__c = :acc.Id AND Start_Date__c >= :invoiceStartDate AND End_Date__c <= :invoiceEndDate];
        system.debug('lstTimeSheet :'+lstTimeSheet);
        Decimal expectedTotalAmount = lstTimeSheet[0].Price__c + (lstTimeSheet[0].Price__c * GSTValue);
        Decimal expectedFinalAmountWithGST = expectedTotalAmount;
        List<Decimal> totalAmounts = new List<Decimal>();
        Map<Time_Sheet__c, Decimal> timeSheetMap = new Map<Time_Sheet__c, Decimal>();
        //	ApexPages.currentPage().getParameters().put('invoiceStartDate', invoiceStartDate);
        System.assertEquals(invoiceStartDate, controller.invoicestartdate);
        System.assertEquals(invoiceEndDate, controller.invoiceenddate);
        System.assertEquals(clientId, controller.clientid);  
        
        test.startTest();
        	ElderlyCareInvoiceGenerationController ec = new ElderlyCareInvoiceGenerationController();
        test.stopTest();
    }
    
}