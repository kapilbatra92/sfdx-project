@isTest
private class MaintenanceRequestHelperTest {
    @testSetup
    static void allTheDataForThisTestClass() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Contact contact = new Contact();
        contact.FirstName = 'test';
        contact.LastName = 'last';
        contact.Email = 'test@test.com';
        contact.AccountId = acc.Id;
        insert contact;
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'car';
        vehicle.Color__c = 'White';
        vehicle.Make__c = 'abc';
        vehicle.Model__c = 'car';
        vehicle.Year__c = '1990';
        vehicle.Vehicle_Owner__c = contact.Id;
        insert vehicle; 
        
        Maintenance_Request__c mReq= new Maintenance_Request__c ();
        mReq.Status__c ='Not Confirmed';
        mReq.Maintenance_Date__c = Date.today();
        mReq.Vehicle_Registration_Number__c = vehicle.Id;
        mReq.Odometer_Reading__c = 100000;
        insert mReq;
        
        Part_Inventory__c  parts= new Part_Inventory__c ();
        parts.Name='abc';
        parts.Part_Name__c='test';
        parts.Quantity_Purchased__c=1000;
        insert parts;
        
        Maintenance_Part__c  mParts = new Maintenance_Part__c();
        mParts.Part_Number__c = parts.Id;
        mParts.Qty_Utilized__c=10;
        mParts.Maintenance_Request_Number__c = mReq.Id;
        insert mParts;
    }
    
    static testMethod void testMaintenanceRequest() {
        List<Vehicle__c> vclList = new List<Vehicle__c>();
        List<Vehicle__c> secondList = new List<Vehicle__c>();
        
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'test' LIMIT 1]; 
        Contact contact  = [SELECT Id, FirstName, LastName,Email,AccountId FROM Contact WHERE Email = 'test@test.com' LIMIT 1]; 
        Vehicle__c vehicle = [SELECT Id, Name FROM Vehicle__c WHERE Name = 'car' LIMIT 1]; 
        Maintenance_Request__c mReq = [SELECT Id, Vehicle_Registration_Number__c FROM Maintenance_Request__c WHERE Vehicle_Registration_Number__c =: vehicle.Id LIMIT 1]; 
        Test.startTest();
        for(Integer i=1;i<=200;i++){
            Vehicle__c newVehicle = new Vehicle__c();
            newVehicle.Name = 'car'+String.valueOf(i);
            newVehicle.Color__c = 'White';
            newVehicle.Make__c = 'abc';
            newVehicle.Model__c = 'car';
            newVehicle.Year__c = '1990';
            newVehicle.Vehicle_Owner__c = contact.Id;
            vclList.add(newVehicle);   
        }
        
        insert vclList;
        
        // Assert your results!
        System.assertEquals(200,vclList.size());
        for(Vehicle__c vcl:vclList){
            vcl.Last_Known_Odometer_Reading__c  = 10000;
            secondList.add(vcl);
        }
        update secondList;
        List<Maintenance_Request__c> newMReq=[SELECT Id, Vehicle_Registration_Number__c FROM Maintenance_Request__c WHERE Vehicle_Registration_Number__c =:secondList];
        for(Maintenance_Request__c mr : newMReq){
            mr.Status__c = 'Completed';
        }
        update newMReq;
        secondList = new List<Vehicle__c>();
        for(Vehicle__c vcl:vclList){
            vcl.Last_Known_Odometer_Reading__c  = 30000;
            secondList.add(vcl);
        }
        update secondList;
        List<Vehicle__c> createdVehicles = [Select Id from Vehicle__c where Last_Known_Odometer_Reading__c = 30000];
        System.debug('###Size : '+createdVehicles.size());
        System.assertEquals(200,createdVehicles.size());
         
        //Remember to stop the test.
        Test.stopTest();
    } 
    static testMethod void testNonMaintenanceRequest() {
        Vehicle__c vcl=[SELECT Id, Last_Known_Odometer_Reading__c FROM Vehicle__c WHERE Name='car'];
        vcl.Last_Known_Odometer_Reading__c = 400;
        update vcl;
        
        vcl.Last_Known_Odometer_Reading__c = 1000;
        update vcl;
        
        vcl.Last_Known_Odometer_Reading__c = 10000;
        update vcl;
    }
}