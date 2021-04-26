/* Class name: asyncWorkPlanningService
* 	Description : This class performs @future callout to Workforce Planning API
*	
*/
public class asyncWorkPlanningService{
	
	 public asyncWorkPlanningService(){}
	 
	  
		
	 @future (callout= true)
	 public static void workPlanningServiceRequest(List<case> closedCases){
		 
		List<case> toUpdateCaseKey = new List<case>();
		List<case> failedCaseList  = new List<case>();
		
        for (Case case: cases) {
		
			//Prepare request body 
			String reqWorkPlanBody ='{"workPlanning":[{"case no":'+ '"'+case.caseNumber+'","Agent name":'+ '"'+case.contact+'","case status":'+ '"'+case.status+'"}]}';
			//can retrieve this token from custom settings
			String token='wew349fjjdsvsk29'
			//Encoding the token to match the service provider ex: Base64
			String b64String = EncodingUtil.Base64encode(Blob.valueof(token));
			String autorizationHeader = 'Basic' +b64String;
			String caseKey;
			//Prepare Request
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setHeader('Authorization',autorizationHeader; 
			req.setHeader('Content-Type','application/json'); 
			req.setEndpoint('https://nfapihub.herokuapp.com/');
			req.setBody(reqWorkPlanBody);
			Http http = new Http();
			
			try{
				//Perform callout
				HttpResponse response = http.send(req);
				System.debug('response+++++'+response);
			}catch(CalloutException ce){
				
				if(ce.getMessage().IndexOf('Read timedout')!=-1){
					System.debug('callout Timeout Exception +++ '+ ce.getMessage()+':' +ce.getStackTraceString());
				}else {
					System.debug('Pasring/callout Exception +++ '+ ce.getMessage()+':' +ce.getStackTraceString());
				}
			
			}catch(CalloutException e){
				
				System.debug('General Exception occured +++ '+  ce.getMessage()+':' +ce.getStackTraceString());
			}finally{
				//Insert into WS Utility object for tracking Webservice transactions
			}
			
			
			if(response.getStatusCode()==200){
				//get the case Key from the response.
				Map<String, String> caseKeyValues = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
				caseKey = caseKeyValues.get('secretKey')
				//Assign the new feild for capturing secret key in the case object
				case.servicecall_Status__c ='Success';
				case.secretKeyCheck__c =caseKey;
				//Add to the Case List
				toUpdateCaseKey.add(case);
				
			}else if(response.getStatusCode()==500){
				Map<String, String> caseFailure= (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
				String failedReason = caseFailure.get('error')
				case.servicecall_Status__c ='failed';
				System.debug('General Exception occured +++ '+failedReason );
				failedCaseList.add(case);
			}
		}
		//DML update case object
       try{
		if(toUpdateCaseKey.size() >0){
		update toUpdateCaseKey;
		} 
	   }
	   catch(DMLException e){
		System.debug('Updating CaseKey Exception '+ e.getMessage());
	   }
	   try{
	   if(failedCaseList.size() >0){
		update failedCaseList;
		} 		
	   }
	   catch (Exception e{
		System.debug('Updating FailedCases Exception '+ e.getMessage());
	   }
		 
	}  
 }