/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 07-10-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Test_Highlightpanel {
    @testSetup
    public static void Highlightpanel(){
        
        Contact con = new Contact();
        con.LastName='Test';
        insert con;
        
        Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='testContact@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,CompanyName='ZuddhiSystems',
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@zuddhisystems.com.au');
        insert us;
        
        //Account acc =[select id,Name,Phone,Profile__c, Account_Image__c,AccountImage_URL__c, Birth_date__c, Age__c,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Gander__c, Reports_to__c,Reports_to__r.Name from Account where id=:accountrecordId]; 
        //Account acc =[select id,Name,Phone,Profile__c, Account_Image__c,AccountImage_URL__c, Birth_date__c, Age__c,BillingAddress,Gander__c, Reports_to__c,Selected_Service_Packages__c,Reports_to__r.Name from Account where id=:accountrecordId];
        Account acc = new Account();
        //acc.id='0010l00001akdPBAAY';
        acc.Name='Test';
        acc.Phone= '12345677';
        // acc.Profile__c='';
        // acc.Account_Image__c='';
        acc.AccountImage_URL__c= 'https://i.ibb.co/2ZvfLqB/Mar-jp.jpg';
        acc.Birth_date__c=system.today();
        //acc.Age__c='';
        acc.BillingStreet='Test Address';
        acc.BillingCity='Test Address';
        acc.BillingState='Test Address';
        acc.BillingPostalCode='1234';
        acc.BillingCountry='Test Address';
        acc.Gander__c='Male';
        acc.Reports_to__c= con.Name;
        acc.Annual_Budget__c=10000;
        insert acc;
        
       /* Event eve = new Event();
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
        eve.whatid = acc.Id;
        //lstevet.add(eve);
        insert eve;*/
        
        AgedCare_Product__c agedcare = new AgedCare_Product__c();
        agedcare.Name='Test Care';
        agedcare.CareType__c = 'Personal Care';
        agedcare.Price__c = 2.0;
        agedcare.Company_Name__c = 'ZuddhiSystems';
        insert agedcare; 
        
        HomeCare_Package__c hp = new HomeCare_Package__c();
        hp.Name = 'test name';
        hp.Account_Name__c = acc.Id;
        hp.Select_your_Package__c = 'Homecare Package Level 4';
        hp.Personal_Care__c = true;
        hp.Select_Comprehensive_allied_health_Plans__c='Psychological support and counseling';
        hp.Select_Extensive_home_modification_plans__c='Home assessment and modifications';
        hp.Select_Household_Cares__c ='Cleaning Tasks';
        hp.Select_Meal_plans__c	='Meal planning';
        hp.Select_Medication_plans__c='Medication reminders';
        hp.Select_More_complex_medication_plans__c	='Medication assessment';
        hp.Select_Social_support__c ='Companionship visits';
        hp.Select_Transportation_and_shopping_plans__c	='Grocery shopping assistance';
        hp.Select_advanced_nursing_care_plans__c	='Medical assessment and monitoring';
        hp.Select_allied_health_service_plans__c='Social work';
        hp.Select_great_allied_health_service_plans__c ='Initial assessment and goal-setting';
        hp.Select_personal_Care_Plans__c ='Bathing';
        hp.Select_home_modification_plans__c ='Initial assessment';
        hp.Select_intensive_personal_care_plans__c='Personal care and hygiene';
        hp.Select_specialized_nursing_care__c='Wound care';
        hp.Select_specialized_pallative_care__c	='Palliative care assessment';
        hp.Select_support_for_personal_care__c='Personal grooming and hygiene';
        hp.Select_your_Mobility_Plans__c='Mobility aids and equipment';
        insert hp;
        
        
        Goal__c g = new Goal__c();
        g.Name = 'test name';
        g.Related_Account__c = acc.id;
        g.Type__c ='Personal Care';
        g.Additional_information__c ='Test Info';
        //g.Select_Product__c = agedcare.id;
        g.A_broader_range_of_allied_health_service__c = True;
        g.Advanced_nursing_care__c = true;
        g.Comprehensive_allied_health_services__c= true;
        g.Extensive_home_modifications__c = true;
        g.Greater_access_to_allied_health_services__c = true;
        g.HomeCare_Package_Name__c = hp.id;
        g.Home_modification_and_Safety__c = true;
        g.Home_modifications__c = true;
        g.Household_care__c = true;
        g.Increased_support_for_personal_care__c = true;
        g.Intensive_personal_care_and_suppor__c = true;
        g.Meal_planning__c = true;
        g.Medication_c__c = true;
        g.Mobility_and_Transfer__c = true;
        g.More_complex_medication_management__c = true;
        g.Personal_Care__c = true;
        g.Selected_Comprehensive_allied_healthPlan__c ='Psychological support and counseling;Social work services';
        g.Selected_ExtensiveHomeModification_Plans__c = 'Home assessment and modifications';
        g.Selected_HomeModifications__c = 'Minor home repairs';
        g.Selected_Home_modification_Plans__c ='';
        g.Selected_Medication_plans__c = 'Medication reminders;Medication administration';
        g.Selected_Personal_Care_Plans__c ='Bathing;Toileting';
        g.Selected_SocialSupport_Cares__c	 ='Companionship visits;Emotional support';
        g.Selected_Specialized_nursing_plans__c ='Wound care';
        g.Selected_Support_for_personal_plans__c	 = '';
        g.Selected_Transportation_plans__c	 ='Grocery shopping assistance;Social outings';
        g.Selected_advanced_nursing_care__c	 ='';
        g.Selected_allied_health_plans__c ='Social work';
        g.Selected_great_allied_health_plans__c	 ='Cleaning Tasks;Meal preparation';
        g.Selected_intensive_pesonal_plans__c = '';
        g.Selected_meal_plans__c ='';
        g.Selected_mobility_plans__c ='';
        g.Selected_more_complex_medication__c	 ='Medication assessment';
        g.Selected_specialized_pallative_plans__c	 = '';
        g.Social_support_and_Companionship__c = true;
        g.Specialized_nursing_care__c = true;
        g.Specialized_palliative_ca__c = true;
        g.Transportation_and_shopping__c = true;
        insert g;
    }
    
    public static testMethod void queryTest(){
        Account acc1 =[select id,Name,Phone,AccountImage_URL__c, Birth_date__c,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Gander__c, Reports_to__c,Reports_to__r.Name from Account];
        //string str = acc1[0].id;
        //Goal__c g1= [Select Id,Name, Related_Account__c,Select_Product__c,A_broader_range_of_allied_health_service__c,Advanced_nursing_care__c,Comprehensive_allied_health_services__c,Extensive_home_modifications__c,Greater_access_to_allied_health_services__c,HomeCare_Package_Name__c,Home_modification_and_Safety__c,Home_modifications__c,Household_care__c,Increased_support_for_personal_care__c,Intensive_personal_care_and_suppor__c,Meal_planning__c,Medication_c__c,Mobility_and_Transfer__c,More_complex_medication_management__c,Personal_Care__c,Selected_Comprehensive_allied_healthPlan__c,Selected_ExtensiveHomeModification_Plans__c,Selected_HomeModifications__c,Selected_Home_modification_Plans__c,Selected_Medication_plans__c,Selected_Personal_Care_Plans__c,Selected_SocialSupport_Cares__c,Selected_Specialized_nursing_plans__c,Selected_Support_for_personal_plans__c,Selected_Transportation_plans__c,Selected_advanced_nursing_care__c,Selected_allied_health_plans__c,Selected_great_allied_health_plans__c,Selected_household_cares__c,Selected_intensive_pesonal_plans__c,Selected_meal_plans__c,Selected_mobility_plans__c,Selected_more_complex_medication__c,Selected_specialized_pallative_plans__c,Social_support_and_Companionship__c,Specialized_nursing_care__c,Specialized_palliative_ca__c,Transportation_and_shopping__c from Goal__c limit 1];
        //event eve1 = [select id from event];
        Test.startTest();
        Highlightpanel.getAccount(acc1.id); 
        //Highlightpanel.getRelatedAccountDetails(eve1.id);
        //Highlightpanel.getValues(str);
        Test.stopTest();
    }       
}