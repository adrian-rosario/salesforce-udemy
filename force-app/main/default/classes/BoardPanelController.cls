public with sharing class BoardPanelController {
  @AuraEnabled
  public static string addGameResult(String result, String mode) {
    Shuffle_Game__c newGameResult = new Shuffle_Game__c(
      Result__c = result,
      Mode__c = mode
    );
    try {
      insert newGameResult;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return 'success';
  }
}