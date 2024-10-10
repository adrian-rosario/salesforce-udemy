trigger AGRLocationTracingTrigger on Location_Tracing__c(before insert) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      AGRLocationTracingTriggerHandler.beforeInsert(Trigger.new);
    }
    when AFTER_INSERT {
      AGRLocationTracingTriggerHandler.afterInsert(Trigger.new);
    }
  }

}