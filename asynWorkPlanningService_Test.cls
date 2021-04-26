@isTest
private class workPlanningWS_Test {

	
	@isTest static void workPlanBatch(){ 
		Account testAccount = new Account(name='WP Testing');
		 insert testAccount;

	   Account testAccount2 = new Account(name='Work Planning');
		
		Contact ct1 = new Contact();
		ct1.FirstName='Steve';
		ct1.LastName='Wills';
		ct1.AccountId= testAccount.Id;
		insert ct1;
		
		Contact ct2 = new Contact();
		ct2.FirstName='Jackson';
		ct2.LastName='Roberts';
		ct2.AccountId= testAccount2.Id;
		insert ct2;
		
		//Prepare Case Object testdata
		List<Case> caseList = new List<Case>();
		case caseObj = new case();
		caseObj.status ='Closed';
		caseObj.prority ='Medium';
		caseObj.Contact =ct1.Id;
		caseList.add(caseObj);
			
		case caseObj2 = new case();
		caseObj2.status ='In progress';
		caseObj2.prority ='Medium';
		caseObj2.Contact =ct2.Id;
		caseList.add(caseObj2);
		insert caseList;
		
		Test.StartTest();
		asyncWorkPlanningService asynWorkPl = new asyncWorkPlanningService();
		asynWorkPl.workPlanningServiceRequest(caseList);
		Test.StopTest();
	}
}