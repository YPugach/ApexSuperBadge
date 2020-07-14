@isTest
private class MaintenanceRequestTest {
    
    @isTest
    static void testMaintenanceRequest(){
        List<Case> insertedMRs = new List<Case>();
        List<Case> updatedMRs = new List<Case>();
        
        Test.startTest();
        
        Product2 prod2 = TestDataGenerator.createEquipment();
        Id equipId = [SELECT Id FROM Product2 LIMIT 1].get(0).Id;
        Vehicle__c vehic = TestDataGenerator.createVehicle();
        Id vehicId = [SELECT Id FROM Vehicle__c LIMIT 1].get(0).Id;
        Case mr = TestDataGenerator.createMaintenanceRequest(vehicId, equipId);
        Id mrId = [SELECT Id FROM Case LIMIT 1].get(0).Id;
        Work_Part__c wp = TestDataGenerator.createWorkPart(equipId, mrId);
        insertedMRs = TestDataGenerator.createListMaintenanceRequest(vehicId, equipId);  
        System.assertEquals(300, insertedMRs.size());
        for(Case c : insertedMRs){
            c.Status = 'Closed';
            updatedMRs.add(c);
        }
        mr.Status='Closed';
        update mr;
           
        update updatedMRs;   
        System.assertEquals(300, updatedMRs.size());
        Test.stopTest();
    }
}