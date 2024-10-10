trigger LeadTriggerTest on Lead (after insert, before insert, after update, before update) {
    
    System.debug('lead triggers...');
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {

            AGRLeadTriggerHandler.beforeInsert(Trigger.new);

        }

        when AFTER_INSERT {
            
            AGRLeadTriggerHandler.afterInsert(Trigger.new);
            
        }
        
        
        when BEFORE_UPDATE {

			AGRLeadTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
            
        }

        

    }
    

    System.debug('LeadTrigger I is executing');
}