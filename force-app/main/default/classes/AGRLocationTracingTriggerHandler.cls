public with sharing class AGRLocationTracingTriggerHandler {
  public static void beforeInsert(List<Location_Tracing__c> newRecord) {
    System.debug('AGRLocationTracingTriggerHandler beforeInsert');

    List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(
      newRecord
    );
    for (Location_Tracing__c trace : duplicates) {
      trace.addError(
        'Duplicate record found: ' + trace.Location__c + ' ' + trace.Person__c
      );
    }

    if (duplicates.size() == 0) {
      System.debug('no dulicates found');
    }
  }

  public static void afterInsert(List<Location_Tracing__c> newRecord) {
    System.debug('AGRLocationTracingTriggerHandler afterInsert');
  }
}