trigger checkDuplicateRequests on Maintenance_Request__c (before insert) {
    set<String> setVclNo = new set<String>();
    if(Trigger.isInsert  && Trigger.isBefore){
        List<Maintenance_Request__c> newMr = new List<Maintenance_Request__c>();
        for(Maintenance_Request__c mr: Trigger.New){
            setVclNo.add(mr.Vehicle_Registration_Number__c);
        }
        if(setVclNo.size()>0){
            List<Maintenance_Request__c> mReqList = [SELECT Id,Vehicle_Registration_Number__c FROM Maintenance_Request__c WHERE Vehicle_Registration_Number__c in: setVclNo AND
                                                     Status__c !='Completed' AND Status__c != 'Cancelled'];
            Map<String,Maintenance_Request__c> mapOfVcl = new Map<String,Maintenance_Request__c>();
            for(Maintenance_Request__c mr: mReqList){
                mapOfVcl.put(mr.Vehicle_Registration_Number__c, mr);
            }
            for(Maintenance_Request__c mr:trigger.new){
                if(mapOfVcl.containsKey(mr.Vehicle_Registration_Number__c)){
                    mr.Vehicle_Registration_Number__c.addError('A service request for this Vehicle is already open.');
                }
            }
        }
        
    }
}