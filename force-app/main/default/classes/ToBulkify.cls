public class ToBulkify {
    public static void updateAvgCaseResolutionDays(Id accountId){
        Integer totalDays = 0, totalCases = 0;
        // retrive all the cases for this account
        // get resolution days for each account (ClosedDate - CreatedDate)
        for(Case caseObj : [SELECT Id, CreatedDate, ClosedDate
                             FROM Case
                             WHERE IsClosed=true
                            	AND AccountId =: accountId]){
            // increase number of cases
            totalCases++;
            // get duration in days and add it to totalDays
            totalDays += caseObj.CreatedDate.date().daysBetween(caseObj.ClosedDate.date());
        }
        Decimal resolutionDays = totalDays/totalCases;
        // update account object
        Account acc = new Account(Id=accountId, Avg_Case_Resolution_Days__c = resolutionDays);
        update acc;
    }
}