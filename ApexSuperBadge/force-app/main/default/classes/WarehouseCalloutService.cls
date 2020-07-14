public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      REST endpoint and update equipment on hand.
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());

            List<Product2> products = new List<Product2>();
            for(Object obj : results)
            { 
                Map<String, Object> newObj = (Map<String, Object>) obj;
                Product2 product = new Product2();
                product.Name  = (String)newObj.get('name'); 
                product.Maintenance_Cycle__c = (Integer)newObj.get('maintenanceperiod'); 
                product.Cost__c = (Integer)newObj.get('cost');
                product.Current_Inventory__c = (Integer)newObj.get('qIntegerntity');
                product.Lifespan_Months__c = (Integer)newObj.get('lifespan');
                product.Replacement_Part__c = (Boolean)newObj.get('replacement');
                product.Warehouse_SKU__c = (String) newObj.get('sku');
                product.ProductCode = (String)newObj.get('_id');       
                products.add(product);
            }
            System.debug(products);
            upsert products;
        }
    }     
}