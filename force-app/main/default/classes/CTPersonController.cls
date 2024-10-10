/**
 * Controller for the Person Object
 *
 * @param personId id of the person
 *
 * @return Person__c object with the specified Id or Null if there is no such object
 */

public with sharing class CTPersonController {
  public static String getToken(String theNumbers) {
    Blob targetBlob = Blob.valueOf(theNumbers);
    Blob hash = Crypto.generateDigest('MD5', targetBlob);
    String result = EncodingUtil.base64Encode(hash);
    return result;
    /*
        generate md5 hash from phone number
         */
  }

  public static List<Person__c> getRecentHealthChanges() {
    return [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      ORDER BY Status_Update_Date__c DESC NULLS LAST
      LIMIT 100
    ];
    /*
        query person records [all fields] limit the result to 100
        sort by Status Update Date in descending order
        Return List of Person records back to caller  
        */
  }

  public static List<Person__c> searchPeople(String searchTerm) {
    searchTerm = searchTerm + '%';
    return [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      WHERE
        Name LIKE :searchTerm
        OR Mobile__c LIKE :searchTerm
        OR Token__c LIKE :searchTerm
      ORDER BY Status_Update_Date__c DESC NULLS LAST
    ];
    /* 
        query Person records [all fields] where either Name Mobile or Token matches the search term
        sort by Status Update Date in descending order
        Return List of Person records back to caller 
        */
  }

  public static Person__c getPersonById(String personId) {
    List<Person__c> people = [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      WHERE Id = :personId
    ];

    if (people != null && people.size() > 0) {
      return people[0];
    }
    return null;
    /* 
        Query a Person record [all fields] where Id matches the personId parameter value
        return the Person record back to the caller 
        */
  }

  public static Map<String, Integer> getHealthStatusCount() {
    // query Person records to find Number of People in each Health Status
    // build a Map<String, Integer> to map the count of people with each status
    // return the Map back to the caller
    Map<String, Integer> healthCountMap = new Map<String, Integer>();

    for (AggregateResult result : [
      SELECT Health_Status__c, COUNT(Id) total
      FROM Person__c
      GROUP BY Health_Status__c
    ]) {
      // we have to type cast these for the map to accept them
      String healthStatus = String.valueOf(result.get('Health_Status__c'));
      Integer count = Integer.valueOf(result.get('total'));
      healthCountMap.put(healthStatus, count);
    }
    System.debug('personController, healthCountMap: ' + healthCountMap);
    return healthCountMap;
  }
  /*
    console test:
    Map<String, Integer> myResults = CTPersonController.getHealthStatusCount();
    System.debug(myResults);
    */

  public static Set<Id> getCoHabitants(
    Set<Id> personIds,
    Set<Id> alreadyProcessed
  ) {
    Set<Id> coHabitants = new Set<Id>();
    List<String> healthStatuses = new List<String>{ 'Green', 'Yellow' };

    List<People_Tracing__c> peopleTraces = [
      SELECT Id, Person_1__c, Person_2__c
      FROM People_Tracing__c
      WHERE
        (Person_1__c IN :personIds
        OR Person_2__c IN :personIds)
        AND Contact_Type__c = 'Cohabitant'
        AND (Person_1__r.Health_Status__c IN :healthStatuses
        OR Person_2__r.Health_Status__c IN :healthStatuses)
    ];

    for (People_Tracing__c tracingInstace : peopleTraces) {
      if (!personIds.contains((tracingInstace.Person_1__c))) {
        coHabitants.add(tracingInstace.Person_1__c);
        alreadyProcessed.add(tracingInstace.Person_1__c);
      }
      if (!personIds.contains(tracingInstace.Person_2__c)) {
        coHabitants.add(tracingInstace.Person_2__c);
        alreadyProcessed.add(tracingInstace.Person_2__c);
      }
    }

    return coHabitants;
  }

  public static Set<Id> getNeighbors(
    Set<Id> personIds,
    Set<Id> alreadyProcessed
  ) {
    Set<Id> neighbors = new Set<Id>();

    List<People_Tracing__c> peopleTraces = [
      SELECT Id, Person_1__c, Person_2__c
      FROM People_Tracing__c
      WHERE
        (Person_1__c IN :personIds
        OR Person_2__c IN :personIds)
        AND Contact_Type__c = 'Neighbor'
        AND (Person_1__r.Health_Status__c = 'Green'
        OR Person_2__r.Health_Status__c = 'Green')
    ];

    for (People_Tracing__c tracingInstace : peopleTraces) {
      if (
        !/*personIds*/ alreadyProcessed.contains((tracingInstace.Person_1__c))
      ) {
        neighbors.add(tracingInstace.Person_1__c);
        alreadyProcessed.add(tracingInstace.Person_1__c);
      }
      if (
        !/*personIds*/ alreadyProcessed.contains(tracingInstace.Person_2__c)
      ) {
        neighbors.add(tracingInstace.Person_2__c);
        alreadyProcessed.add(tracingInstace.Person_2__c);
      }
    }

    return neighbors;
  }

  public static Set<Id> getPrimaryContacts(
    Set<Id> personIds,
    Set<Id> alreadyProcessed
  ) {
    Set<Id> primaryContacts = new Set<Id>();

    List<String> healthStatuses = new List<String>{ 'Green', 'Yellow' };

    List<People_Tracing__c> peopleTraces = [
      SELECT Id, Person_1__c, Person_2__c
      FROM People_Tracing__c
      WHERE
        (Person_1__c IN :personIds
        OR Person_2__c IN :personIds)
        AND Contact_Type__c = 'Other'
        AND Contact_Date__c = LAST_N_DAYS:10
        AND (Person_1__r.Health_Status__c IN :healthStatuses
        OR Person_2__r.Health_Status__c IN :healthStatuses)
    ];

    for (People_Tracing__c tracingInstace : peopleTraces) {
      if (
        !/*personIds*/ alreadyProcessed.contains((tracingInstace.Person_1__c))
      ) {
        primaryContacts.add(tracingInstace.Person_1__c);
        alreadyProcessed.add(tracingInstace.Person_1__c);
      }
      if (
        !/*personIds*/ alreadyProcessed.contains(tracingInstace.Person_2__c)
      ) {
        primaryContacts.add(tracingInstace.Person_2__c);
        alreadyProcessed.add(tracingInstace.Person_2__c);
      }
    }

    return primaryContacts;
  }

  public static Set<Id> getSecondaryContacts(
    Set<Id> personIds,
    Set<Id> alreadyProcessed
  ) {
    Set<Id> secondaryContacts = new Set<Id>();
    Set<Id> primaryContacts = new Set<Id>();

    List<People_Tracing__c> peopleTraces = [
      SELECT Id, Person_1__c, Person_2__c
      FROM People_Tracing__c
      WHERE
        (Person_1__c IN :personIds
        OR Person_2__c IN :personIds)
        AND Contact_Type__c = 'OTHER'
        AND Contact_Date__c = LAST_N_DAYS:10
        AND (Person_1__r.Health_Status__c = 'Green'
        OR Person_2__r.Health_Status__c = 'Green')
    ];

    for (People_Tracing__c tracingInstace : peopleTraces) {
      if (
        !/*personIds*/ alreadyProcessed.contains((tracingInstace.Person_1__c))
      ) {
        secondaryContacts.add(tracingInstace.Person_1__c);
        primaryContacts.add(tracingInstace.Person_1__c);
      }
      if (
        !/*personIds*/ alreadyProcessed.contains(tracingInstace.Person_2__c)
      ) {
        secondaryContacts.add(tracingInstace.Person_2__c);
        primaryContacts.add(tracingInstace.Person_2__c);
      }
    }

    return secondaryContacts;
  }

  public static Map<String, Integer> getTotals() {
    AggregateResult[] results = [
      SELECT Health_Status__c, COUNT(Id) totalHealthStatus
      FROM Person__c
      GROUP BY Health_Status__c
      ORDER BY COUNT(Id)
    ];

    System.debug('person controller, get totals called');    
    Map<String, Integer> healthCountTotals = new Map<String, Integer>();

    if (results != null && results.size() > 0) {
      //   Map<String, Integer> healthCountTotals = new Map<String, Integer>();
      for (AggregateResult result : results) {
        Integer theTotalHealthStatus = Integer.valueOf(
          result.get('totalHealthStatus')
        );
        String healthStatus = String.valueOf(result.get('Health_Status__c'));
        System.debug(healthStatus + ' ' + theTotalHealthStatus);
        healthCountTotals.put(healthStatus, theTotalHealthStatus);
      }
      //   return healthCountTotals;
    }
    System.debug(healthCountTotals);
    return healthCountTotals;
  }
}