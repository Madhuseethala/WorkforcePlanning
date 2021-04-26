trigger caseTrigger on Case (after update) 
{
     if(Trigger.isAfter && Trigger.isUpdate)
   {
	List<case> caseList = new List<case>();
	asyncWorkPlanningService asynWork = new asyncWorkPlanningService();
	
   for (Case cs : Trigger.new)
    {
        if(Trigger.isUpdate) {  
          
            if(cs.status =='Closed' && cs.secretKeyCheck__c == null) {
                caseList.add(cs);
            }   
			if (caseList.size() > 0){
				
				asynWork.workPlanningServiceRequest(caseList);
			}	
        }   
    }
  }
 }