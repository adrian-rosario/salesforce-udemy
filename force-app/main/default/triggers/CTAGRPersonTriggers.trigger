trigger CTAGRPersonTriggers on Person__c (
  before insert, 
  before update, 
  before delete, 
  after insert, 
  after update, 
  after delete, 
  after undelete
  ) {

  switch on Trigger.operationType {

    when BEFORE_INSERT {
      CTAGRPersonTriggerMethods.beforeInsert(Trigger.new);
    }

    when BEFORE_UPDATE {
      CTAGRPersonTriggerMethods.beforeUpdate(Trigger.new, Trigger.oldMap);
    }

    when BEFORE_DELETE {
      CTAGRPersonTriggerMethods.beforeUpdate(Trigger.new, Trigger.oldMap);
    }

    when AFTER_INSERT {
      CTAGRPersonTriggerMethods.afterInsert(Trigger.new);
    }

    when AFTER_UPDATE {
      CTAGRPersonTriggerMethods.afterUpdate(Trigger.new, Trigger.oldMap);
    }

    when AFTER_DELETE {
      CTAGRPersonTriggerMethods.afterUpdate(Trigger.new, Trigger.oldMap);
    }

    when AFTER_UNDELETE {
      CTAGRPersonTriggerMethods.afterUndelete(Trigger.new);
    }
  }
}