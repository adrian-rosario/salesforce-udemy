public with sharing class CaseResolutionDays {

    public static void updateAvgCaseResolutionDays(List<Id> accountIds){

        // performance of map is better than nested for loops
        Map<Id, Integer> accountTotalCasesMap = new Map<Id, Integer>();
        Map<Id, Integer> accountTotalCaseDaysMap = new Map<Id, Integer>();

        // Integer totalDays = 0;
        // Integer totalCases = 0;
        // retrive all the cases for this account
        // get resolution days for each account (ClosedDate - CreatedDate)
        for(Case caseObj : [SELECT Id, CreatedDate, ClosedDate, AccountId
                             FROM Case
                             WHERE IsClosed=true
                            	AND AccountId IN : accountIds]){


            // if map does not have current account id then add it
            if(!accountTotalCasesMap.containsKey(caseObj.AccountId)){
                accountTotalCasesMap.put(caseObj.AccountId, 0);
                accountTotalCaseDaysMap.put(caseObj.AccountId, 0);
            }

            Integer totalCases = accountTotalCasesMap.get(caseObj.AccountId);

            totalCases++;

            accountTotalCasesMap.put(caseObj.AccountId, totalCases);

            // get duration in days and add it to totalDays
            Integer totalDays = accountTotalCaseDaysMap.get(caseObj.AccountId);

            totalDays += caseObj.CreatedDate.date().daysBetween(caseObj.ClosedDate.date());

            accountTotalCaseDaysMap.put(caseObj.AccountId, totalDays);
        }

        // list of accounts to update
        List<Account> accountToUpdate = new List<Account>();
        for(Id accountId: accountTotalCasesMap.keySet()){
            Decimal resolutionDays = accountTotalCaseDaysMap.get(accountId) / accountTotalCasesMap.get(accountId); // totalDays/totalCases;
            // update account object
            accountToUpdate.add(new Account(Id=accountId, Avg_Case_Resolution_Days__c = resolutionDays));
        }

        update accountToUpdate;
    }
}

/*  
https://www.udemy.com/course/salesforce-development/learn/lecture/22873301#overview

story
======
summary of issue

modify existing code, bulkify for lare volume of data

tracks case resolution days for each customer 
- added new field, Avg_Case_Resolution_Days__c on an account object 

existing method is updateAvgCaseResolutionDays() to correctly update this field on 
Account object  the current code does not work for multiple accounts and can only work for one account at a time

bulkify the current method to handle multiple account updates at once


desired flow
============
- method execution start
- create 2 maps, to store accountId, total days, total cases for each account 
    Map<Id, Integer>
    accountTotalCaseMap,
    accountTotalCaseDaysMap
- SOQL - get all closed cases for all accounts 
- build both maps 
- iterate overa all cases and add items in both maps
- build final account list to update
- iterate over the map, calculate the average resolution days, and add account to a list
- DML - update accounts
- method execution end

test case
=========
- create 200 accounts
- create 200 cases
- verify avg case resolution days is populated correctly on account object


implementation approach
=======================

1. write a method that builds 2 maps - 1 for accountId, 1 for totalDays, totalCases,
   put this method in a class, call it AccountControllerTwo

2. call the method from the original method, updateAvgCaseResolutionDays()

3. test the method from the test class, AccountControllerTwoTest

4. test the method from the original test class, AccountControllerTest

5. run the test class, make sure all tests pass

6. run the test class, make sure all tests pass

7. commit to git

8. repeat steps 1-7 for all changes


original code
=============

public class AccountController {

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

*/