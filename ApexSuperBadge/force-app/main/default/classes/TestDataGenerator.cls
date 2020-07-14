public with sharing class TestDataGenerator {
    public static Product2 createEquipment(){
        Product2 equip = new Product2(
            Name = 'Test Equipment', 
            Maintenance_Cycle__c = 10,
            Cost__c = 100,
            Current_Inventory__c = 10,
            Lifespan_Months__c = 10,
            Replacement_Part__c = true,
            Warehouse_SKU__c = 'abc');
        insert equip;
        return equip;
    }
    public static Vehicle__c createVehicle() {
        Vehicle__c v = new Vehicle__c (Name = 'Test Vehicle');
        insert v;
        return v;
    }

    public static Case createMaintenanceRequest(Id vehicleId, Id equipmentId) {
        Case c = new Case(
            Type = 'Repair',
            Status = 'New',
            Origin = 'Web',
            Subject = 'AMC Spirit',
            Equipment__c = equipmentId,
            Vehicle__c = vehicleId);
        insert c;
        return c;
    }

    public static List<Case> createListMaintenanceRequest(Id vehicleId, Id equipmentId){
        List<Case> MRs = new List<Case>();
        for(Integer i = 1; i <= 300; i++){
            Case mr = new Case(
                Type = 'Repair'+i,
                Status = 'New',
                Subject = 'AMC Spirit',
                Origin = 'Web');           
            mr.Equipment__c = equipmentId; 
            mr.Vehicle__c = vehicleId;
            MRs.add(mr);
        }
        insert MRs;
        return MRs;
    }

    public static Work_Part__c createWorkPart(Id equipmentId, Id requestId){
        Work_Part__c wp = new Work_Part__c(
            Equipment__c = equipmentId,
            Maintenance_Request__c = requestId);
        insert wp;
        return wp;
    }
}
