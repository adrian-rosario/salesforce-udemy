public with sharing class AGRCTRecentChangesController {
  @AuraEnabled
  public static List<Person__c> getRecentPersonHealthChanges() {
    System.debug('AGRCTRecentChangesController getRecentPersonHealthChanges');
    return CTPersonController.getRecentHealthChanges();
  }

  @AuraEnabled
  public static List<Location__c> getRecentLocationHealthChanges() {
    System.debug('AGRCTRecentChangesController getRecentLocationHealthChanges');
    return CTLocationController.getRecentStatusChanes();
  }

  @AuraEnabled
  public static List<Person__c> searchPeople(String searchTerm) {
    System.debug('AGRCTRecentChangesController searchPeople');
    return CTPersonController.searchPeople(searchTerm);
  }

  @AuraEnabled
  public static List<Location__c> searchLocations(String searchTerm) {
    System.debug('AGRCTRecentChangesController searchLocations');
    return CTLocationController.searchLocations(searchTerm);
  }
}