@isTest
Global class Test_selectedServices {
    @testSetup
    public static void ElderlyCareSelectedServices(){
        Account testAccount = new Account(Name = 'Test Account',AccountImage_URL__c = 'https://i.ibb.co/Lp3RMJb/Lucy.jpg');
        AgedCare_Product__c agedcare = new AgedCare_Product__c();
        agedcare.Name='Test Care';
        agedcare.CareType__c = 'Personal Care';
        agedcare.Price__c = 2.0;
        agedcare.Company_Name__c = 'ZuddhiSystems';
        insert agedcare; 
        
        insert testAccount;
        List<Product_Line_Item__c> testProductLineItems = new List<Product_Line_Item__c>{
            new Product_Line_Item__c(Name = 'Service 1', Account_Name__c = testAccount.Id, CareType__c = agedcare.CareType__c, Price__c = agedcare.Price__c ),
                new Product_Line_Item__c(Name = 'Service 2', Account_Name__c = testAccount.Id, CareType__c = agedcare.CareType__c, Price__c = agedcare.Price__c),
                new Product_Line_Item__c(Name = 'Service 3', Account_Name__c = testAccount.Id, CareType__c = agedcare.CareType__c, Price__c = agedcare.Price__c)
                };
                    insert testProductLineItems;
        
        HomeCare_Package__c hp = new HomeCare_Package__c();
        hp.Name = 'test name';
        hp.Account_Name__c = testAccount.Id;
        hp.Select_your_Package__c = 'Homecare Package Level 4';
        hp.Personal_Care__c = true;
        hp.Comprehensive_allied_health_services__c = true;
        hp.Extensive_home_modifications__c = true;
        hp.Household_Care__c = true;
        hp.Meal_planning__c = true;
        hp.Medication__c = true;
        hp.More_complex_medication_management__c = true;
        hp.Social_support_and_Companionship__c =true;
        hp.Select_Comprehensive_allied_health_Plans__c='Psychological support and counseling';
        hp.Select_Extensive_home_modification_plans__c='Home assessment and modifications';
        hp.Select_Household_Cares__c ='Cleaning Tasks';
        hp.Select_Meal_plans__c	='Meal planning';
        hp.Select_Medication_plans__c='Medication reminders';
        hp.Select_More_complex_medication_plans__c	='Medication assessment';
        hp.Select_Social_support__c ='Companionship visits';
        hp.Select_personal_Care_Plans__c ='Bathing';
        insert hp;
        
        Goal__c g = new Goal__c();
        g.Name = 'test name';
        g.Related_Account__c = testAccount.id;
        g.Type__c ='Personal Care';
        g.PackageLevel__c = 'Homecare Package Level 1';
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
        Account acc = [select id, Name, AccountImage_URL__c from Account];
        string imgURL = 'https://i.ibb.co/Lp3RMJb/Lucy.jpg';
        List<Product_Line_Item__c> ser1 = [Select id, name, Account_Name__c,CareType__c, Price__c from Product_Line_Item__c];
        List<Goal__c> goal = [select id, name, Related_Account__c,PackageLevel__c from Goal__c];
        Test.startTest();
        ElderlyCareSelectedServices.getServices(ser1[0].id);
        ElderlyCareSelectedServices.getPackageLevel(goal[0].id);
        ElderlyCareSelectedServices.updatePhoto(acc.id,imgURL);
        Test.stopTest();
    }
}