public with sharing class AGRCTUserTabController {
  @AuraEnabled
  public static UserInformation getPersonDetails(String personRecordId) {
    UserInformation theUserInformation = new UserInformation();
    Person__c thePerson = CTPersonController.getPersonById(personRecordId);
    System.debug('AGRCTUserTabController.getPersonDetails');
    System.debug('searching for: ' + personRecordId);
    System.debug('...\n' + thePerson);
    //
    if (thePerson != null) {
      theUserInformation.name = thePerson.Name;
      theUserInformation.token = thePerson.Token__c;
      theUserInformation.statusUpdate = thePerson.Status_Update_Date__c;
      theUserInformation.phone = thePerson.Mobile__c;
      theUserInformation.status = thePerson.Health_Status__c;
    }
    //
    List<People_Tracing__c> personTraces = CTPeopleTracingController.getTraces(
      personRecordId
    );
    //
    if (personTraces != null && personTraces.size() > 0) {
      List<CloseContacts> theCloseContacts = new List<CloseContacts>();
      Set<Id> uniqueIds = new Set<Id>();
      uniqueIds.add(personRecordId);
      //
      for (People_Tracing__c trace : personTraces) {
        CloseContacts listOfCloseContacts = new CloseContacts();

        if (!uniqueIds.contains(trace.Person_1__c)) {
          listOfCloseContacts.id = trace.Person_1__c;
          listOfCloseContacts.status = trace.Person_1__r.Health_Status__c;
          listOfCloseContacts.token = trace.Person_1__r.Token__c;
          listOfCloseContacts.contactDate = trace.Contact_Date__c;
        }
        if (!uniqueIds.contains(trace.Person_2__c)) {
          listOfCloseContacts.id = trace.Person_2__c;
          listOfCloseContacts.status = trace.Person_2__r.Health_Status__c;
          listOfCloseContacts.token = trace.Person_2__r.Token__c;
          listOfCloseContacts.contactDate = trace.Contact_Date__c;
        }
        theCloseContacts.add(listOfCloseContacts);
      }
      theUserInformation.contacts = theCloseContacts;
      theUserInformation.contactsCount = theCloseContacts.size();
    }
    return theUserInformation;
  }

  public class UserInformation {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String token;
    @AuraEnabled
    public Date statusUpdate;
    @AuraEnabled
    public String phone;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public Integer contactsCount = 0;
    @AuraEnabled
    public List<CloseContacts> contacts;
    // @AuraEnabled
    // public Integer contactsCount;
  }

  public class CloseContacts {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String token;
    @AuraEnabled
    public Date contactDate;
    @AuraEnabled
    public String status;
  }
}