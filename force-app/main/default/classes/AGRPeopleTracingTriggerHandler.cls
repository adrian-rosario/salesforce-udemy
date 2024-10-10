public with sharing class AGRPeopleTracingTriggerHandler {
  public static void beforeInsert(List<People_Tracing__c> newRecord) {
    System.debug(
      'people tracing trigger handler, before insert called\n' + newRecord
    );
    List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(
      newRecord
    );

    for (People_Tracing__c trace : duplicates) {
      // error displayed in the Salesforce ui when
      // a new entry into the people tracing
      // table
      trace.addError(
        'Duplicate record found\n' +
          trace.Person_1__c +
          '\n' +
          trace.Person_2__c
      );
    }
  }

  public static void afterInsert(List<People_Tracing__c> newRecord) {
    System.debug(
      'people tracing trigger handler, after insert called\n' + newRecord
    );
  }
}