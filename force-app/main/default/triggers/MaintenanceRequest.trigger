trigger MaintenanceRequest on Vehicle__c (after update) {
    Map<Id,Vehicle__c> vehicleList = new Map<Id,Vehicle__c>();
    if(Trigger.isUpdate  && Trigger.isAfter){
        for(Vehicle__c vcl: Trigger.new){
                if((vcl.Last_Known_Odometer_Reading__c-vcl.Last_Service_Odometer_Reading__c) > 9499 || vcl.Last_Service_Date__c.daysBetween(Date.today()) > 334){
                    vehicleList.put(vcl.Id,vcl);
                }
            }
          if(vehicleList.size() > 0){
              MaintenanceRequestHelper.createMaintenanceRequest(vehicleList);    
        }        
    } 
}
