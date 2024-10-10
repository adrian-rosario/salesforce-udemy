public with sharing class CTLocationController {
  public static List<Location__c> getRecentStatusChanes() {
    return [
      SELECT
        Id,
        Name,
        Address__c,
        Pincode__c,
        Red_Score__c,
        Status_Update_Date__c,
        Status__c
      FROM Location__c
      ORDER BY Status_Update_Date__c DESC NULLS LAST
      LIMIT 100
    ];
    /* 
        query Location records all fields Limit the result to 100
        sort by Status Update Date in descending order
        return List of location records back to the caller 
        */
  }

  public static List<Location__c> searchLocations(String searchTerm) {
    searchTerm = searchTerm + '%';
    return [
      SELECT
        Id,
        Name,
        Address__c,
        Pincode__c,
        Red_Score__c,
        Status_Update_Date__c,
        Status__c
      FROM Location__c
      WHERE
        Name LIKE :searchTerm
        OR Pincode__c LIKE :searchTerm
        OR Address__c LIKE :searchTerm
      ORDER BY Status_Update_Date__c DESC NULLS LAST
      LIMIT 100
    ];
    /* 
        query Location records all fields where either Name PinCode or Address matches the search term
        sort by Status Update Date in descending order
        Return List of location records back to the caller 
        */
  }

  public static Location__c getLocationById(String locationId) {
    // use List instead of directly as you can hit exceptions
    List<Location__c> locations = [
      SELECT
        Id,
        Name,
        Address__c,
        Pincode__c,
        Red_Score__c,
        Status_Update_Date__c,
        Status__c
      FROM Location__c
      WHERE Id = :locationId
    ];
    if (locations != null && locations.size() > 0) {
      return locations[0];
    } else {
      return null;
    }
    /*  
        query a Location record all fields where Id matches the locationId parameter value
        Return the Location record back to the caller
        */
  }

  // query Location records to find number of Locations in each Health Status
  // Build a Map<String, Integer> to map count of location with each status
  // return the Map back to the caller
  public static Map<String, Integer> getHealthStatusCount() {
    Map<String, Integer> healthCountMap = new Map<String, Integer>();

    for (AggregateResult result : [
      SELECT Status__c, Count(Id) total
      FROM Location__c
      GROUP BY Status__c
    ]) {
      String healthStatus = String.valueOf(result.get('theStatus'));
      Integer count = Integer.valueOf(result.get('total'));
      healthCountMap.put(healthStatus, count);
    }
    System.debug('location controller, count map: ' + healthCountMap);
    return healthCountMap;
  }

  public static void updateRedScore(Set<Id> locationIds) {
    List<Location__c> locationToUpdate = new List<Location__c>();
    AggregateResult[] redPeoplePerLocation = [
      SELECT Location__c, COUNT(Id) total
      FROM Location_Tracing__c
      WHERE
        Person__r.Health_Status__c = 'Red'
        AND Visit_Date__c = LAST_N_DAYS:10
        AND Location__c IN :locationIds
      GROUP BY Location__c
    ];

    for (AggregateResult ar : redPeoplePerLocation) {
      String locationId = String.valueOf(ar.get('Location__c'));
      Integer redScore = Integer.valueOf(ar.get('total'));
      String status = getStatus(redScore);
      // mark red
      // mark orange
      // mark yellow
      // mark green
      locationToUpdate.add(
        new Location__c(
          Id = locationId,
          Red_Score__c = redScore,
          Status__c = status
        )
      );
    }
    if (locationToUpdate != null && locationToUpdate.size() > 0) {
      update locationToUpdate;
    }
  }

  public static String getStatus(Integer redScore) {
    if (redScore == 0) {
      return 'Green';
    } else if (redScore <= 5) {
      return 'Yellow';
    } else if (redScore <= 10) {
      return 'Orange';
    } else {
      return 'Red';
    }
  }

  public static Map<String, Integer> getTotals() {
    AggregateResult[] results = [
      SELECT Status__c, COUNT(Id) totalLocationStatus
      FROM Location__c
      GROUP BY Status__c
      ORDER BY COUNT(Id)
    ];

    // System.debug('location controller, get totals called');
    Map<String, Integer> totals = new Map<String, Integer>();

    if (results != null && results.size() > 0) {
      for (AggregateResult result : results) {
        String status = String.valueOf(result.get('Status__C'));
        Integer count = Integer.valueOf(result.get('totalLocationStatus'));
        totals.put(status, count);
      }
    }

    return totals;
  }
}