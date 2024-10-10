trigger AGRPersonTriggerTest on Person__c (after insert) {
//     switch on Trigger.operationType {
	System.debug('Person trigger...');     
    switch on Trigger.operationType {
	
        when AFTER_INSERT {
            System.debug('Person, AFTER_INSERT trigger');
        }
        
    }
}