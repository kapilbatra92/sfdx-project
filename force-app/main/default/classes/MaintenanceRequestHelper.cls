public class MaintenanceRequestHelper {
    public static void createMaintenanceRequest(Map<Id, Vehicle__c> applicableRecords){
        List< Maintenance_Request__c> insertMrList = new List<Maintenance_Request__c>();
        List<Maintenance_Request__c> mrList = [SELECT Id,Vehicle_Registration_Number__c FROM Maintenance_Request__c WHERE Vehicle_Registration_Number__c in : applicableRecords.keySet() AND (Status__c !='Completed' OR Status__c != 'Cancelled')];
        for(Maintenance_Request__c mr : mrList){
            if(applicableRecords.containsKey(mr.Vehicle_Registration_Number__c)){
                applicableRecords.remove(mr.Vehicle_Registration_Number__c);
            }
        }
        for(Vehicle__c v: applicableRecords.values()){
            Maintenance_Request__c newMR = new Maintenance_Request__c();
            newMR.Vehicle_Registration_Number__c = v.Id;
            newMR.Maintenance_Date__c = Date.TODAY();
            newMR.Status__c = 'Not Confirmed';
            newMR.Odometer_Reading__c = v.Last_Known_Odometer_Reading__c;
            insertMrList.add(newMR);
        }
        if(insertMrList.size() > 0){
            insert insertMrList;
        }
    }
}