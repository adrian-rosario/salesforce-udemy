public with sharing class AGRAccountContactService {
    public static void updateActiveContacts(Set<Id> accountIds) {
        // get aggregate result for all accounts
        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) totalContacts
            FROM Contact
            WHERE Active__c = TRUE AND AccountId IN :accountIds
            GROUP BY AccountId
        ];
        // build final list of accounts to update
        // List<Account> accountsToUpdate = new List<Account>();

        // conver to map, which account ids are missing, those accts have no active contacts
        Map<Id, Account> accountsToUpdate = new Map <Id, Account>();

        for (AggregateResult result : results) {
            // get account id and number of active contacts
            String accId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
            // make sure you use Id feild in your account to update it
            Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
            // accountsToUpdate.add(acc); // add for List 
            accountsToUpdate.put(accId, acc); // put for Map
        }

        // find missing account ids, set them to zero

        for (Id accId : accountIds) {
            if (!accountsToUpdate.containsKey(accId)) {

                Account acc = new Account(Id = accId, Active_Contacts__c = 0);
                accountsToUpdate.put(accId, acc);
            }
        }
        // update the final list of account
        // update accountsToUpdate;
        update accountsToUpdate.values(); // since it's  map
    }
}