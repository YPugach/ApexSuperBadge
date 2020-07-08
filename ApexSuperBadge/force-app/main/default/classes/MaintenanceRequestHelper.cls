public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders() {
       
       List<Case> Cases = new List<Case>();
       List<Case> oldCases =  [SELECT Id, Vehicle__r.Id, Equipment__r.Id, (SELECT Id FROM Work_Parts__r) 
                            FROM Case WHERE Status = 'Closed' AND Id IN :Trigger.new 
                            AND Type IN('Repair','Routine Maintenance')];

        for(Case c:oldCases){
            List<Work_Part__c> workParts = c.Work_Parts__r;
            Case newCase = new Case(
                Type = 'Routine Maintenance',
                Subject = 'New Routine Maintenance',
                Date_Reported__c = System.Today(),
                Date_Due__c = System.Today() + calculateDueDate(workParts),
                Vehicle__c = c.Vehicle__r.Id,
                Origin='Web',
                Status='New',
                Equipment__c = c.Equipment__r.Id
                );
            Cases.add(newCase);
            
        }
      
       if(Cases!=null && Cases.size()>0){
            insert Cases;
        }
    }  

    public static Integer calculateDueDate(List<Work_Part__c> workParts){
       Integer count = 0;
       List<AggregateResult> agrResult = [SELECT Min(Equipment__r.Maintenance_Cycle__c) Arg FROM Work_Part__c WHERE Id IN:workParts ];
       for(AggregateResult ar : agrResult){
            count = (Integer) ar.get('arg');
       }
       return count !=null ? count : 0 ;
    }  
}