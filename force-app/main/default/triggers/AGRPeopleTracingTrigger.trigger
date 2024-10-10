trigger AGRPeopleTracingTrigger on People_Tracing__c(
  before insert,
  after insert
) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      AGRPeopleTracingTriggerHandler.beforeInsert(Trigger.new);
    }
    when AFTER_INSERT {
      AGRPeopleTracingTriggerHandler.afterInsert(Trigger.new);
    }
  }
}