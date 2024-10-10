public class OpportunityControllerTwo {

        
    public static void updateProfile(List<Id> oppIds){

        // bulkified version

        List<Opportunity> opps = [SELECT Id, Amount, Profile__c FROM Opportunity WHERE Id IN: oppIds];
        for(Opportunity opp : opps){ // (Id oppId : oppIds) 
            // get opp record
            // Opportunity opp = [SELECT Id, Amount, Profile__c FROM Opportunity WHERE Id =: oppId];

            if (opp.Amount == null) {
                opp.Profile__c = '';
            } else if (opp.Amount == 15000){
                opp.Profile__c = 'Low';
            } else if (opp.Amount > 50000){
                opp.Profile__c = 'High';
            } else {
                opp.Profile__c = 'Medium';
            }
            // update opportunity
            // update opp;
        }
        update opps;
    }

}