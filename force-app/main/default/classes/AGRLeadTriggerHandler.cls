public class AGRLeadTriggerHandler {
    
    public static void beforeInsert(List<Lead> newRecord){
        System.debug('before insert called');
        for(Lead leadRecord: newRecord){
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';
            }      
            
            if(String.isBlank(leadRecord.Industry)){
                leadRecord.addError('Industry field cannot be blank');
            }            
        }        
    }
    
    public static void afterInsert(List<Lead> newRecord){
        System.debug('after insert record is being called');
        List<Task> leadTasks = new List<Task>();
        for(Lead leadRecord: newRecord){
            // create a task...
            System.debug('create a task');
            Task leadTask = new Task(
                Subject='Followup on Lead Status', 
                WhoId=leadRecord.Id
            );
            System.debug('creating cask: '+ leadTask);
            leadTasks.add(leadTask);
        }
        insert leadTasks;
        System.debug('task created');        
    }
    
    public static Void beforeUpdate(List<Lead> newRecord, Map<Id, Lead> oldRecordsMap){
        System.debug('before update being called');
        for(Lead leadRecord: newRecord){
            
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';
            }                  
            
            if(
                (leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted') 
                && oldRecordsMap.get(leadRecord.Id).Status == 'Open - Not Contacted'
            ){
                leadRecord.Status.addError('You cannot directly close an Open record');            
            }
        }                    
    }
}