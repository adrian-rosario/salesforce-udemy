public with sharing class AGRLocationTriggerHandlers {
  public static void beforeInsert(List<Location__c> theNewRecord) {
    System.debug('location trigger handler, beforeInsert called');
    System.debug('new record: \n' + theNewRecord);

    // make sure location status is Green before inserting the record
    // if (theNewRecord != null && theNewRecord.size() > 0) {
    //   theNewRecord[0].Status__c = 'Green';
    // }
    for (Location__c location : theNewRecord) {
      location.Status__c = 'Green';
    }
  }

  public static void afterInsert(List<Location__c> theNewRecord) {
    System.debug('location trigger handler, afterInsert called');
    System.debug('new record: \n' + theNewRecord);
  }

  public static void beforeUpdate(
    List<Location__c> theNewRecord,
    Map<Id, Location__c> oldRecordsMap
  ) {
    System.debug('location trigger handler, beforeUpdate called');
    System.debug('new record: \n' + theNewRecord);
    System.debug('old record: \n' + oldRecordsMap);

    // if location status changes, update the Status Update Date

    for (Location__c location : theNewRecord) {
      if (location.Status__c != oldRecordsMap.get(location.Id).Status__c) {
        location.Status_Update_Date__c = Date.today();
      }
    }
  }

  public static void afterUpdate(
    List<Location__c> theNewRecord,
    Map<Id, Location__c> oldRecordsMap
  ) {
    System.debug('location trigger handler, afterUpdate called');
    System.debug('new record: \n' + theNewRecord);
    System.debug('old record: \n' + oldRecordsMap);

    Set<Id> newRecordStatusChange = new Set<Id>();
    for (Location__c location : theNewRecord) {
      if (
        location.Status__c == 'Red' &&
        oldRecordsMap.get(location.Id).Status__c != 'Red'
      ) {
        System.debug('location status is red, but existing status is not red');
        newRecordStatusChange.add(location.Id);
      }

      List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByLocationIds(
        newRecordStatusChange
      );

      Set<Id> personIds = new Set<Id>();

      // loop over the location tracing records
      for (Location_Tracing__c trace : locationTraces) {
        personIds.add(trace.Person__c);
      }

      List<Person__c> personRecordsToUpdate = new List<Person__c>();
      for (Id thePId : personIds) {
        personRecordsToUpdate.add(
          new Person__c(Id = thePId, Health_Status__c = 'Yellow')
        );
      }

      if (personRecordsToUpdate.size() > 0) {
        update personRecordsToUpdate;
      }
      //   }
    }
  }
}