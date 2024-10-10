public class OpportunityController {

    public static void updateProfile(List<Id> oppIds){
        for(Id oppId : oppIds){
            // get opp record
            Opportunity opp = [SELECT Id, Amount, Profile__c, Name FROM Opportunity WHERE Id =: oppId];
            if(opp.Amount == 15000){
                opp.Profile__c = 'Low';
            } else if (opp.Amount > 50000){
                opp.Profile__c = 'High';
            } else{
                opp.Profile__c = 'Medium';
            }
            // update opportunity
            update opp;
        }
    }
}