public with sharing class CTLocationTracingController {
  /**
   * get visitors
   * @param locationId Id of the location
   * @return List<Location_Tracing__c> of people visited the location
   */
  public static List<Location_Tracing__c> getVisitors(String locationId) {
    // query Location Tracing records matching locationId value
    // sort by Visit Date in descending order
    // Return List of Location Tracing records back to caller

    return [
      SELECT
        Id,
        Person__c,
        Location__c,
        Visit_Date__c,
        Person__r.Token__c,
        Person__r.Health_Status__c
      FROM Location_Tracing__c
      WHERE Location__c = :locationId
      ORDER BY Visit_Date__c DESC NULLS LAST
    ];
  }

  /**
   * get locations by person ids
   * @param locationIds
   * @return List<Location_Tracing__c>
   */
  public static List<Location_Tracing__c> getLocationsByPersonIds(
    Set<Id> personIds
  ) {
    // query Location Tracing records where Person matches the 'psersonIds'
    // only retrieve records where Visit Date is in last 10 days
    // return List of Location Tracing records back to teh caller

    return [
      SELECT Id, Person__c, Location__c
      FROM Location_Tracing__c
      WHERE Person__c IN :personIds AND Visit_Date__c > :System.today() - 10 // also: LAST_IN_DAYS: 10
    ];
  }

  /**
   * get all visitor ids for location ids
   * @param locationIds
   * @return List<Location_Tracing__c>
   */
  public static List<Location_Tracing__c> getLocationsByLocationIds(
    Set<Id> locationIds
  ) {
    // query Location Tracing records where Location matches the locationIds and Person health is Green
    // only retrieve records where Visit Date is in last 10 days
    // Return List of Location Tracing records back to caller

    return [
      SELECT Id, Person__c, Location__c
      FROM Location_Tracing__c
      WHERE
        Location__c IN :locationIds
        AND Person__r.Health_Status__c = 'Green'
        AND Visit_Date__c > :System.today() - 10
    ];
  }

  public static List<Location_Tracing__c> checkDuplicates(
    List<Location_Tracing__c> locationTraces
  ) {
    // https://www.udemy.com/course/salesforce-development/learn/lecture/22873517#overview
    // we need to check the duplicate tracing records for existing records before we insert new ones
    //
    //
    // step 1. iterate over the new location tracing records to get
    // all the unique location ids and person ids
    // step 2. query existing location tracing records using ids collected in step 1
    // step 3. create a Map<locationId, Set<personId>>. this will make our task easier to find duplicates
    // step 4. loop over new location tracing records adn check for duplicates in Map (created in step 3)
    // step 5. return the list of duplicates

    // store unique location ids and person ids
    Set<Id> locationIds = new Set<Id>();
    Set<Id> personIds = new Set<Id>();

    for (Location_Tracing__c trace : locationTraces) {
      locationIds.add(trace.Location__c);
      personIds.add(trace.Person__c);
    }

    // query existing location tracing records
    // this will make finding the duplicates easier
    List<Location_Tracing__c> existingRecords = [
      SELECT Id, Person__c, Location__c
      FROM Location_Tracing__c
      WHERE Location__c IN :locationIds AND Person__c IN :personIds
    ];

    // map of locationid, set of person ids
    Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

    List<Location_Tracing__c> dupes = new List<Location_Tracing__c>();

    //
    if (existingRecords != null && existingRecords.size() > 0) {
      for (Location_Tracing__c trace : existingRecords) {
        // if we already have location id, containsKey returns a boolean
        if (!mapOfExistingRecords.containsKey(trace.Location__c)) {
          // add key to map since it doesnt exist
          mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
        }
        // add the person ids to map set
        mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
      }

      // loop over tracing records, find duplicates
      for (Location_Tracing__c trace : locationTraces) {
        // check for locationid
        if (
          mapOfExistingRecords.containsKey(trace.Location__c) &&
          // if map item found in map, then check for person in set
          mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)
        ) {
          dupes.add(trace);
        }
      }
    }

    for (Location_Tracing__c duplicateItem : dupes) {
      System.debug('duplicate : ' + duplicateItem);
    }

    return dupes;
    // query existing records from Location Tracing object
    // find duplicate records by matching locationTraces list and existing records
    // return List of duplicate Location Tracing records back to caller
  }
}

/* 
// testing in the console

List<Location_Tracing__c> locationTraces = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c];
CTLocationTracingController.checkDuplicates(locationTraces);

*/