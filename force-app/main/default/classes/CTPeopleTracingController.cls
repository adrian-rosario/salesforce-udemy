public with sharing class CTPeopleTracingController {
  public static List<People_Tracing__c> getTraces(String recordId) {
    // query People tracing records matching recordId value
    // Sort by Contact Date in descending order
    // return List of People Tracing records back to caller
    List<People_Tracing__c> tracesToReturn = [
      SELECT
        Id,
        Person_1__c,
        Person_2__c,
        Contact_Date__c,
        Contact_Type__c,
        Person_1__r.Health_Status__c,
        Person_2__r.Health_Status__c,
        Person_1__r.Token__c,
        Person_2__r.Token__c
      FROM People_Tracing__c
      WHERE
        (Person_1__c = :recordId
        OR Person_2__c = :recordId)
        AND Contact_Date__c = LAST_N_DAYS:30
      ORDER BY Contact_Date__c DESC NULLS LAST
      LIMIT 100
      OFFSET 0
    ];
    return tracesToReturn;
  }

  public static List<People_Tracing__c> checkDuplicates(
    List<People_Tracing__c> peopleTraces
  ) {
    // query existing records from People Tracing object
    // find duplicate records by matchng peopleTraces list and existing records
    // return List of duplicate People Tracing records back to caller
    System.debug('people tracking, check duplicates called');

    Set<Id> personIds = new Set<Id>();

    for (People_Tracing__c trace : peopleTraces) {
      personIds.add(trace.Person_1__c);
      personIds.add(trace.Person_2__c);
    }

    List<People_Tracing__c> duplicateRecords = new List<People_Tracing__c>();

    Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

    List<People_Tracing__c> existingRecords = [
      SELECT Id, Person_1__c, Person_2__c
      FROM People_Tracing__c
      WHERE Person_1__c IN :personIds OR Person_2__c IN :personIds
    ];

    if (existingRecords != null && existingRecords.size() > 0) {
      for (People_Tracing__c trace : existingRecords) {
        // build map of existing records
        // person one
        if (!mapOfExistingRecords.containsKey(trace.Person_1__c)) {
          mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
        }
        mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

        // person two
        if (!mapOfExistingRecords.containsKey(trace.Person_2__c)) {
          mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>());
        }
        mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
      }

      for (People_Tracing__c trace : peopleTraces) {
        // if map has key, check if key has person two
        // if it does, it's a duplicate
        if (
          (mapOfExistingRecords.containsKey(trace.Person_1__c) &&
          mapOfExistingRecords.get(trace.Person_1__c)
            .contains(trace.Person_2__c)) ||
          (mapOfExistingRecords.containsKey(trace.Person_2__c) &&
          mapOfExistingRecords.get(trace.Person_2__c)
            .contains(trace.Person_1__c))
        ) {
          duplicateRecords.add(trace);
        }
      }
    }

    for (People_Tracing__c item : duplicateRecords) {
      System.debug('People tracingDuplicate Record Found ' + item);
    }

    if (duplicateRecords.size() == 0) {
      System.debug('no duplicates found');
    }

    return duplicateRecords;
  }
}

/* 
testing
=======
List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c];
CTPeopleTracingController.checkDuplicates(peopleTraces);


People_Tracing__c traceOne = new People_Tracing__c(Person_1__c='a05ak000006AyUzAAK', Person_2__c ='a05ak000006B1xXAAS');
People_Tracing__c traceTwo = new People_Tracing__c(Person_1__c='a05ak000006B1xXAAS', Person_2__c='a05ak000006B9m5AAC');
People_Tracing__c traceThree = new People_Tracing__c(Person_1__c='a05ak000006B9m5AAC', Person_2__c='a05ak000006B1xXAAS');

List<People_Tracing__c> traces = new List<People_Tracing__c>();
traces.add(traceOne);
traces.add(traceTwo);
traces.add(traceThree);

CTPeopleTracingController.checkDuplicates(traces);




*/