public with sharing class AGRCTLocationTabController {
  @AuraEnabled
  public static LocationInformation getLocationDetails(String recordId) {
    LocationInformation theLocationInformation = new LocationInformation();
    Location__c theLocation = CTLocationController.getLocationById(recordId);
    System.debug('AGRCTLocationTabController.getLocationDetails');
    System.debug('searching for: ' + recordId);
    System.debug('...\n' + theLocation);
    //
    if (theLocation != null) {
      theLocationInformation.name = theLocation.Name;
      theLocationInformation.redScore = Integer.valueOf(
        theLocation.Red_Score__c
      );
      theLocationInformation.statusUpdateOn = theLocation.Status_Update_Date__c;
      theLocationInformation.pinCode = theLocation.Pincode__c;
      theLocationInformation.status = theLocation.Status__c;
    }
    //
    List<Location_Tracing__c> locationTraces = CTLocationTracingController.getVisitors(
      recordId
    );
    //
    if (locationTraces != null && locationTraces.size() > 0) {
      List<CloseContacts> theCloseContacts = new List<CloseContacts>();

      for (Location_Tracing__c trace : locationTraces) {
        CloseContacts listOfCloseContacts = new CloseContacts();

        listOfCloseContacts.id = trace.Person__c;
        listOfCloseContacts.status = trace.Person__r.Health_Status__c;
        listOfCloseContacts.token = trace.Person__r.Token__c;
        listOfCloseContacts.visitDate = trace.Visit_Date__c;

        theCloseContacts.add(listOfCloseContacts);
      }
      theLocationInformation.contacts = theCloseContacts;
      theLocationInformation.contactsCount = theCloseContacts.size();
    }
    return theLocationInformation;
  }

  public class LocationInformation {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Integer redScore;
    @AuraEnabled
    public Date statusUpdateOn;
    @AuraEnabled
    public String pincode;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public Integer contactsCount = 0;
    @AuraEnabled
    public List<CloseContacts> contacts;
  }

  public class CloseContacts {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String token;
    @AuraEnabled
    public Date visitDate;
    @AuraEnabled
    public String status;
  }
}