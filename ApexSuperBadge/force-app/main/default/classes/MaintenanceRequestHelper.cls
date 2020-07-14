public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders() {
       
        List<Case> Cases = new List<Case>();
        List<Case> oldCases =  [SELECT Id, Vehicle__r.Id, Equipment__r.Id, (SELECT Id, Equipment__r.Maintenance_Cycle__c
                              FROM Work_Parts__r) FROM Case WHERE Status = 'Closed' AND Id IN :Trigger.new 
                              AND Type IN('Repair','Routine Maintenance')];

        Map<Id, Decimal> mapOfProdIdWithMaintenanceCycle = getMapOfProdIdWithMaintenanceCycle();
        for(Case c:oldCases){
            List<Work_Part__c> workParts = c.Work_Parts__r;

            Case newCase = new Case(
                Type = 'Routine Maintenance',
                Subject = 'New Routine Maintenance',
                Date_Reported__c = System.Today(),
                Vehicle__c = c.Vehicle__r.Id,
                Origin='Web',
                Status='New',
                Equipment__c = c.Equipment__r.Id,
                Date_Due__c = getDueDate(c, mapOfProdIdWithMaintenanceCycle)
                );
            Cases.add(newCase);
            
        }
      
       if(Cases!=null && Cases.size()>0){
            insert Cases;
        }
    }  
    private static Map<Id, Decimal> getMapOfProdIdWithMaintenanceCycle(){
        Map<Id,Decimal> mapOfProdIdWithMaintenanceCycle = new Map<Id, Decimal>();
        for(Product2 prod : [SELECT Id, Maintenance_Cycle__c from Product2]){
            mapOfProdIdWithMaintenanceCycle.put(prod.Id, prod.Maintenance_Cycle__c);
        }
        
        return mapOfProdIdWithMaintenanceCycle;
    }
    private static Date getDueDate(Case maintenance, Map<Id, decimal> mapOfProdIdWithMaintenanceCycle){
        Date dt = null;
        if (mapOfProdIdWithMaintenanceCycle.get(maintenance.Equipment__c) != null) {
            dt = Date.today().addDays(Integer.valueOf(mapOfProdIdWithMaintenanceCycle.get(maintenance.Equipment__c)));
        }
        return dt;
    }
}