global class ElderlyCareCustomerReviews {
    @Auraenabled(cacheable=true)
    global static list<FeedbackReview> getFeedBack(){
        list<Feedback__c> lstFeedback = [ SELECT Id, Name,Carer__r.Name,Client__r.Name,Time_Sheet__c,Time_Sheet__r.Service_Name__c ,Contact__c, Rating__c, Comments__c, Carer__c, Star_Rating__c, Client__c,Client__r.AccountImage_URL__c,CreatedDate,Client__r.Account_Image__c FROM Feedback__c where Rating__c!=null order by  createdDate desc];
        Integer totalRecords = lstFeedback.size();
        list<FeedbackReview> feedbackreview = new list<FeedbackReview>();
        FeedbackReview fbrv =new FeedbackReview();
        for(Feedback__c fb : lstFeedback){
            system.debug('fb :'+fb);
            FeedbackReview fbReview = new FeedbackReview();
            Date createdDateOnly = Date.newInstance(fb.CreatedDate.year(), fb.CreatedDate.month(), fb.CreatedDate.day());
            Decimal ratingValue = integer.valueof(fb.Rating__c);
            system.debug('ratingValue :'+ratingValue);
            
            fbReview.carerName = fb.Carer__r.Name;
            fbReview.clientName = fb.Client__r.Name ;
            fbReview.Rating = fb.Star_Rating__c;
            fbReview.comments = fb.Comments__c;
            fbReview.comments = fb.Comments__c;
            fbReview.clientimage = fb.Client__r.AccountImage_URL__c;
            fbReview.createddate = createdDateOnly;
            fbReview.serviceName = fb.Time_Sheet__r.Service_Name__c;
            fbReview.recId = fb.Id;
            feedbackreview.add(fbReview);
        }
        
        return feedbackreview;
    }
    global class FeedbackReview{
        @Auraenabled
        global string recId;
        @Auraenabled
        global string carerName;
        @Auraenabled
        global string clientName;
        @Auraenabled
        global string Rating;
        @Auraenabled
        global string comments;
        @Auraenabled
        global string clientimage;
        @Auraenabled
        global date createddate;
        @Auraenabled
        global string serviceName;
        @Auraenabled
        global Decimal oneStarPercentage{get;set;}
        @Auraenabled
        global Decimal twoStarPercentage{get;set;}
        @Auraenabled
        global Decimal threeStarPercentage{get;set;}
        @Auraenabled
        global Decimal fourStarPercentage{get;set;}
        @Auraenabled
        global Decimal fiveStarPercentage{get;set;}
    }
}