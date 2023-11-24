/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 07-07-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class ElderlyCareInvoiceGenerationController {
    global  string clientname {get; set;} 
    global  string billingstate {get; set;}
    global  string billingcity {get; set;} 
    global  string billingstreet {get; set;}
    global  string billingcountry {get; set;} 
    global  string postalcode {get; set;}
    global  string startdate {get; set;} 
    global  string enddate {get; set;}
    global  string timeduration {get; set;} 
    global  string price {get; set;}
    global  string starttime {get; set;} 
    global  string endtime {get; set;}
    global  string totalprice {get; set;}
    global  string timesheetid {get; set;} 
    global  date invoicestartdate {get; set;} 
    global  date invoiceenddate {get; set;}
    global  string clientid {get; set;}
    global string serviceItem{get;set;}
    global list<Time_Sheet__c> lsttimesheet{get;set;}
    global Decimal TotalfinalAmountWithGST{get;set;}
    global list<Decimal> invPlusGSTAmount{get;set;}
    global list<Decimal> totalamount{get;set;}
    global Map<Time_Sheet__c,Decimal> timShtMAp{get;set;}
    global string invoiceNumbe{get;set;}
    Decimal gstPercentage = 10.00;
    Double baseValue = 100.00;
    Double GSTValue = (gstPercentage / 100);
    decimal i=0;
    Decimal finalAmountWithGST = 0;
    global string invoiceNumber{get;set;}
    global date invoiceGeneratedDate{get;set;}
    global date invoiceDueDate{get;set;}
    
    global ElderlyCareInvoiceGenerationController() {
        
       if(ApexPages.currentPage().getParameters().get('invoiceGeneratedDate')!=null){
            invoiceGeneratedDate = Date.valueOf(ApexPages.currentPage().getParameters().get('invoiceGeneratedDate'));
            system.debug('invoiceGeneratedDate :'+invoiceGeneratedDate);
        }
        
        if(ApexPages.currentPage().getParameters().get('invoiceDueDate')!=null){
            invoiceDueDate = Date.valueOf(ApexPages.currentPage().getParameters().get('invoiceDueDate'));
            system.debug('invoiceDueDate :'+invoiceDueDate);
        }
        
        if(ApexPages.currentPage().getParameters().get('invoiceNumber')!=null){
            invoiceNumber = string.valueOf(ApexPages.currentPage().getParameters().get('invoiceNumber'));
            system.debug('invoiceNumber :'+invoiceNumber);
        }
        
        if(ApexPages.currentPage().getParameters().get('invoicestartdate')!=null){
            invoicestartdate = Date.valueOf(ApexPages.currentPage().getParameters().get('invoicestartdate'));
        }
        if(ApexPages.currentPage().getParameters().get('invoiceenddate')!=null){
            invoiceenddate = date.valueof(ApexPages.currentPage().getParameters().get('invoiceenddate'));
        }
        if(ApexPages.currentPage().getParameters().get('clientid')!=null){
            clientid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('clientid'));
        }
        if(ApexPages.currentPage().getParameters().get('clientname')!=null){
            clientname = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('clientname'));
        }
        if(ApexPages.currentPage().getParameters().get('billingstate')!=null){
            billingstate = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('billingstate'));
        }
        if(ApexPages.currentPage().getParameters().get('billingcity')!=null){
            billingcity = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('billingcity'));
        }
        if(ApexPages.currentPage().getParameters().get('billingstreet')!=null){
            billingstreet = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('billingstreet'));
        }
        if(ApexPages.currentPage().getParameters().get('billingcountry')!=null){
            billingcountry = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('billingcountry'));
        }
        if(ApexPages.currentPage().getParameters().get('postalcode')!=null){
            postalcode = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('postalcode'));
        }
        if(ApexPages.currentPage().getParameters().get('startdate')!=null){
            startdate = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('startdate'));
        }
        if(ApexPages.currentPage().getParameters().get('enddate')!=null){
            enddate = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enddate'));
        }
        if(ApexPages.currentPage().getParameters().get('timeduration')!=null){
            timeduration = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('timeduration'));
        }
        if(ApexPages.currentPage().getParameters().get('price')!=null){
            price = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('price'));
        }
        if(ApexPages.currentPage().getParameters().get('starttime')!=null){
            starttime = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('starttime'));
        }
        if(ApexPages.currentPage().getParameters().get('endtime')!=null){
            endtime = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('endtime'));
        }
        if(ApexPages.currentPage().getParameters().get('serviceItem')!=null){
            serviceItem = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('serviceItem'));
            system.debug('serviceItem :'+serviceItem);
        }
        if(ApexPages.currentPage().getParameters().get('totalprice')!=null){
            totalprice = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('totalprice'));
        } 

        lsttimesheet = [select id,name,Account_Name__c,Service_Name__c,Account_Name__r.Name,Account_Name__r.Billingstate,Account_Name__r.BillingCity, Account_Name__r.BillingStreet, Account_Name__r.BillingCountry, Account_Name__r.BillingPostalCode,Service_provider__c,Start_Date__c,End_Date__c,Time_Duration__c,Price__c,Homecare_Product__c,Start_Time__c,End_time__c,AgedCare_Product__r.Name from Time_Sheet__c  WHERE Account_Name__c =:clientid  AND Start_Date__c >=:invoicestartdate AND End_Date__c <=:invoiceenddate];
        try{
            if(lsttimesheet.size()>0){
                system.debug('lsttimesheet -->:'+lsttimesheet);
                totalamount = new list<Decimal>();
                invPlusGSTAmount = new list<decimal>();
                timShtMAp = new Map<Time_Sheet__c,Decimal>();
                for(Time_Sheet__c t:lsttimesheet){
                    totalamount.add(t.Price__c+(t.Price__c * GSTValue));
                    system.debug('totalamount :'+totalamount);
                    timShtMAp.put(t,t.Price__c+(t.Price__c * GSTValue));
                    //invPlusGSTAmount.add(totalamount + t.Price__c);
                    //system.debug('invPlusGSTAmount :'+invPlusGSTAmount);
                    finalAmountWithGST += t.Price__c+(t.Price__c * GSTValue);
                    TotalfinalAmountWithGST = finalAmountWithGST;
                }
            }
            
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot generate the invoice.'));
        }
    }  
}