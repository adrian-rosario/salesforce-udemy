public with sharing class GameResultController {
  @AuraEnabled
  public static List<Shuffle_Game__c> getResults() {
    String userId = UserInfo.getUserId();
    List<Shuffle_Game__c> results = [
      SELECT Id, CreatedById, Name, Result__c, Mode__c, CreatedDate
      FROM Shuffle_Game__c
      WHERE CreatedById = :userId
      ORDER BY CreatedDate DESC
    ];
    return results;
  }
}