public with sharing class AGRCTPersonViewController {
  @AuraEnabled
  public static void updateStatusToRedController(String thePersonToEdit) {
    Person__c personRecord = new Person__c(Id = thePersonToEdit);
    personRecord.Health_Status__c = 'Red';
    update personRecord;
  }
}