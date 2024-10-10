trigger AGRLocationTrigger on Location__c(
  before insert,
  after insert,
  before update,
  after update
) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      AGRLocationTriggerHandlers.beforeInsert(Trigger.new);
    }
    when AFTER_INSERT {
      AGRLocationTriggerHandlers.afterInsert(Trigger.new);
    }
    when BEFORE_UPDATE {
      AGRLocationTriggerHandlers.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    when AFTER_UPDATE {
      AGRLocationTriggerHandlers.afterUpdate(Trigger.new, Trigger.oldMap);
    }
  }
}