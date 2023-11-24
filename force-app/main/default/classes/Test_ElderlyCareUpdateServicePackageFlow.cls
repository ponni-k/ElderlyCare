@isTest
public class Test_ElderlyCareUpdateServicePackageFlow {
    
    
    
    @IsTest
    static void testUpdateServicePackage() {
        // Create test data
        Id pf = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        
        User us = new User(Alias = 'auser', IsActive=True,FirstName='Test', Email='testContact@zuddhisystems.com.au',
                           EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',LastName='test', 
                           LocaleSidKey='en_US',Country = 'Denmark',
                           ProfileId = pf,
                           TimeZoneSidKey='America/Los_Angeles',Username='testContact111@zuddhisystems.com.au');
        insert us;
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
        HomeCare_Package__c hp =new HomeCare_Package__c();
        hp.Name = 'Test Package';
        hp.Account_Name__c = testAccount.Id;
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
        
        Goal__c testGoal = new Goal__c();
        testGoal.Related_Account__c = testAccount.Id;
        testGoal.Selected_Personal_Care_Plans__c ='';
        testGoal.HomeCare_Package_Name__c = hp.Id;
        insert testGoal;
        
        Goal__c g1 =[select id,name,Selected_Personal_Care_Plans__c from Goal__c limit 1];
        
        g1.Selected_Personal_Care_Plans__c = 'Bathing';
        g1.Selected_ExtensiveHomeModification_Plans__c = 'Home assessment and modifications';
        g1.Selected_HomeModifications__c = 'Initial assessment';
        g1.Selected_Home_modification_Plans__c = 'Safety assessments';
        g1.Selected_Comprehensive_allied_healthPlan__c	='Psychological support and counseling';
        g1.Selected_Medication_plans__c = 'Medication reminders';
        g1.Selected_SocialSupport_Cares__c = 'Companionship visits';
        g1.Selected_Specialized_nursing_plans__c ='Wound care';
        g1.Selected_Support_for_personal_plans__c='Personal grooming and hygiene';
        g1.Selected_Transportation_plans__c = 'Grocery shopping assistance';
        g1.Selected_allied_health_plans__c ='Social work';
        g1.Selected_great_allied_health_plans__c ='Initial assessment and goal-setting';
        g1.Selected_intensive_pesonal_plans__c='Personal care and hygiene';
        g1.Selected_advanced_nursing_care__c='Medical assessment and monitoring';
        g1.Selected_meal_plans__c='Meal planning';
        g1.Selected_specialized_pallative_plans__c='Palliative care assessment';
        g1.Selected_mobility_plans__c='Medication assessment';
        g1.Selected_household_cares__c='Cleaning Tasks';
        update g1;
        
        Product_Line_Item__c prodLineitem = new Product_Line_Item__c();
        prodLineitem.Name = 'Bathing';
        prodLineitem.Goal_Name__c = testGoal.Id;
        prodLineitem.Account_Name__c = testAccount.Id;
        insert prodLineitem;
        

        List<ElderlyCareUpdateServicePackageFlow.InputvariableFromFlow> inputVariables = new List<ElderlyCareUpdateServicePackageFlow.InputvariableFromFlow>();
        ElderlyCareUpdateServicePackageFlow.InputvariableFromFlow inputVariable = new ElderlyCareUpdateServicePackageFlow.InputvariableFromFlow();
        inputVariable.acid = testAccount.Id;
        inputVariables.add(inputVariable);
        system.debug('inputVariables :'+inputVariables);
        // Call the method to be tested
        
        if(inputVariables != null){
            test.startTest();
            ElderlyCareUpdateServicePackageFlow.updateServicePackage(inputVariables);
            test.stopTest();
        } else {
            system.debug('Id is null');
        }
    }
}