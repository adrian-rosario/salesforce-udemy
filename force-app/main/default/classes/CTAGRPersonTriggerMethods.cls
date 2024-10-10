public with sharing class CTAGRPersonTriggerMethods {
  public static void beforeInsert(List<Person__c> theNewRecord) {
    System.debug('before insert called');
    System.debug(theNewRecord);

    for (Person__c personRecord : theNewRecord) {
      // set status to green (even though
      // in object manager the default is green,
      // we can turn that off to test)
      personRecord.Health_Status__c = 'Green';

      // generate / call new token
      String theToken = CTPersonController.getToken(personRecord.Mobile__c);
      personRecord.Token__c = theToken;
      // System.debug('new record, token: ' + theToken );
    }
  }

  public static void beforeUpdate(
    List<Person__c> theNewRecord,
    Map<Id, Person__c> oldRecordsMap
  ) {
    System.debug('before update called');
    System.debug(theNewRecord);
    System.debug(oldRecordsMap);

    for (Person__c thePerson : theNewRecord) {
      // if the health status field has changed
      // update the status update field
      if (
        oldRecordsMap.get(thePerson.Id).Health_Status__c !=
        thePerson.Health_Status__c
      ) {
        thePerson.Status_Update_Date__c = Date.today();
      }
    }
  }

  public static void beforeDelete(
    List<Person__c> theOldRecord,
    Map<Id, Person__c> oldRecordsMap
  ) {
    System.debug('before delete called');
    System.debug(theOldRecord);
    System.debug(oldRecordsMap);
  }

  public static void afterInsert(List<Person__c> theNewRecord) {
    System.debug('after insert called');
    System.debug(theNewRecord);
  }

  public static void afterUpdate(
    List<Person__c> theNewRecord,
    Map<Id, Person__c> oldRecordsMap
  ) {
    System.debug('after update called');
    System.debug(theNewRecord);
    System.debug(oldRecordsMap);

    Set<Id> statusChange = new Set<Id>();
    Set<Id> redStatus = new Set<Id>();

    for (Person__c person : theNewRecord) {
      if (
        person.Health_Status__c != oldRecordsMap.get(person.id).Health_Status__c
      ) {
        statusChange.add(person.id);
      }

      if (
        person.Health_Status__c == 'Red' &&
        oldRecordsMap.get(person.id).Health_Status__c != 'Red'
      ) {
        redStatus.add(person.id);
      }
    }

    Set<Id> alreadyProcessed = new Set<Id>();
    alreadyProcessed.addAll(redStatus);

    Set<Id> orangeStatus = new Set<Id>();
    Set<Id> yellowStatus = new Set<Id>();

    List<Person__c> peopleToUpdate = new List<Person__c>();

    orangeStatus.addAll(
      CTPersonController.getCoHabitants(redStatus, alreadyProcessed)
    );

    Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(
      redStatus,
      alreadyProcessed
    );

    orangeStatus.addAll(primaryContacts);

    yellowStatus.addAll(
      CTPersonController.getNeighbors(redStatus, alreadyProcessed)
    );

    /* // moved up...
        Set<Id> = primaryContacts =  CTPersonController.getPrimaryContacts(personIds, alreadyProcessed) ;
        orangeStatus.addAll( primaryContacts );
        */
    yellowStatus.addAll(
      CTPersonController.getSecondaryContacts(primaryContacts, alreadyProcessed)
    );

    for (Id pId : orangeStatus) {
      peopleToUpdate.add(new Person__c(Id = pId, Health_Status__c = 'Orange'));
    }

    for (Id pId : yellowStatus) {
      peopleToUpdate.add(new Person__c(Id = pId, Health_Status__c = 'Yellow'));
    }

    if (peopleToUpdate.size() > 0) {
      update peopleToUpdate;
    }

    List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(
      statusChange
    );

    if (locationTraces != null && locationTraces.size() > 0) {
      Set<Id> locationIds = new Set<Id>();
      for (Location_Tracing__c trace : locationTraces) {
        locationIds.add(trace.Location__c);
      }

      // update red score, and status
      CTLocationController.updateRedScore(locationIds);
    }

    // List<Location__c> theLocations = [
    //     SELECT id, name
    //     FROM Location__c
    //     WHERE id IN :locationIds];
  }

  public static void afterDelete(
    List<Person__c> theNewRecord,
    Map<Id, Person__c> oldRecordsMap
  ) {
    System.debug('after delete called');
    System.debug(theNewRecord);
    System.debug(oldRecordsMap);
  }

  public static void afterUndelete(List<Person__c> theNewRecord) {
    System.debug('after undelete called');
    System.debug(theNewRecord);
  }
}