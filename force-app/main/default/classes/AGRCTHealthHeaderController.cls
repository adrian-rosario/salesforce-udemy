public with sharing class AGRCTHealthHeaderController {
  @AuraEnabled
  public static Map<String, Integer> getPersonHealthStatusCount() {
    System.debug('getPersonHealthStatusCount called');
    return CTPersonController.getTotals();
  }
  @AuraEnabled
  public static Map<String, Integer> getLocationHealthStatusCount() {
    System.debug('getLocationHealthStatusCount called');
    return CTLocationController.getTotals();
  }
}