trigger AGRContactTrigger on Contact (
  after insert, 
  after update,
  after delete,
  after undelete) {

    switch on Trigger.operationType {

      when AFTER_INSERT {
        System.debug('after insert block should be called...');
        AGRContactTriggerMethods.afterInsert(Trigger.new);
      }

      when AFTER_UPDATE {
        System.debug('after update block should be called...');
        AGRContactTriggerMethods.afterUpdate(Trigger.new, Trigger.oldMap);
      }

      when AFTER_DELETE {
        AGRContactTriggerMethods.afterDelete(Trigger.old);
      }

      when AFTER_UNDELETE {
        AGRContactTriggerMethods.afterUndelete(Trigger.new);
      }      
    }
}