public with sharing class AGRContactTriggerMethods {

    public static void afterInsert(List<Contact> theNewRecord){   
        System.debug('after insert called'); 

        Set<Id> uniqueAccountIds = new Set<Id>();        

        for(Contact theContact : theNewRecord){

            if(String.isNotBlank(theContact.AccountId)){

                uniqueAccountIds.add(theContact.AccountId);

                // String accountId = theContact.AccountId;
            }            
        }

                List<AggregateResult> theQuery = [
                    SELECT AccountId, COUNT(Id) totalContactIds
                    // bc we're using COUNT, we can't cast this to a List of Contact, it would be an AggregateResult
                    FROM Contact 
                    WHERE Active__c = true 
                        AND AccountId = : uniqueAccountIds
                    GROUP BY AccountId
                ];

                List<Account> accountsToUpdate = new List<Account>();


                for(AggregateResult results: theQuery){
                    String theAccountId = String.valueOf( results.get('AccountId') );
                    Integer totalContacts = Integer.valueOf(results.get('totalContactIds'));

                    Account anAccount = new Account(Id=theAccountId, Active_Contacts__c=totalContacts);
                    accountsToUpdate.add(anAccount);
                }

                update accountsToUpdate;

        /*
        To test this code, create a new Contact in the Contacts object manager, 
        make sure an existing account is selected under Account Name
        once saved, when you go to that existing Account record, you will see the Active Accounts 
        or, from that Contact, you can click on the Account Name, then go to Detail 

        lol, be sure to deploy BOTH the new Trigger AND the newly created/updated class =)
        */
    }

    public static void afterUpdate(List<Contact> theNewRecord, Map<Id, Contact> oldRecordsMap){        
        System.debug('after update called');

        Set<Id> uniqueAccountIds = new Set<Id>();        

        for(Contact theContact : theNewRecord){

            // capture the account id only if the active checkbox value is flipped
            if(String.isNotBlank(theContact.AccountId) && 
                oldRecordsMap.get(theContact.Id).Active__c != theContact.Active__c
            ){

                uniqueAccountIds.add(theContact.AccountId);

            } else if(oldRecordsMap.get(theContact.Id).AccountId != theContact.AccountId){

                uniqueAccountIds.add(theContact.AccountId);                
                uniqueAccountIds.add(oldRecordsMap.get(theContact.Id).AccountId);
            }            
        }

                List<AggregateResult> theQuery = [
                    SELECT AccountId, COUNT(Id) totalContactIds
                    // bc we're using COUNT, we can't cast this to a List of Contact, it would be an AggregateResult
                    FROM Contact 
                    WHERE Active__c = true 
                        AND AccountId = : uniqueAccountIds
                    GROUP BY AccountId
                ];

                List<Account> accountsToUpdate = new List<Account>();


                for(AggregateResult results: theQuery){
                    String theAccountId = String.valueOf( results.get('AccountId') );
                    Integer totalContacts = Integer.valueOf(results.get('totalContactIds'));

                    Account anAccount = new Account(Id=theAccountId, Active_Contacts__c=totalContacts);
                    accountsToUpdate.add(anAccount);
                }

                update accountsToUpdate;        
    }    

    public static void afterDelete(List<Contact> oldContacts){        
        System.debug('after delete called');

        Set<Id> uniqueAccountIds = new Set<Id>();        

        for(Contact theContact : oldContacts){

            if(String.isNotBlank(theContact.AccountId)){

                uniqueAccountIds.add(theContact.AccountId);

                // String accountId = theContact.AccountId;
            }            
        }

        AGRAccountContactService.updateActiveContacts(uniqueAccountIds);
               
    }

    public static void afterUndelete(List<Contact> newContacts){        
        System.debug('after undelete called');

        Set<Id> uniqueAccountIds = new Set<Id>();        

        for(Contact theContact : newContacts){

            if(String.isNotBlank(theContact.AccountId)){

                uniqueAccountIds.add(theContact.AccountId);

                // String accountId = theContact.AccountId;
            }            
        }

        AGRAccountContactService.updateActiveContacts(uniqueAccountIds);
    }
}