<cfsetting requestTimeOut = "9000">
<cfinclude template="assets/header1.cfm">
<!--- security enhancements hz 5/8/21 
1.check the request origin and LCase(cgi.http_REFERER)
2.check form posting token
3.check cross domain forgary
4.remove hidden field is the key

<cfset currentServer="https://#cgi.server_name#" >
<cfset currentPath=#Replace(cgi.script_name,ListLast(cgi.script_name, "/"),"")#>
<cfset httpRequest=GetHttpRequestData()>
<cfset referer_path_and_file = ListFirst(CGI.HTTP_REFERER, "?")>

<cfif StructKeyExists(httpRequest.headers, "Origin")>
		<cfif httpRequest.headers["Origin"] IS NOT "#currentServer#">
		 <cfheader statusCode = "404" statusText = "Page Not Found">
			<cflocation url="404.cfm">
			<p>Sorry, the client request is invalid.</p>
			<cfabort>
		</cfif>	
</cfif>		
 --->

<script type="text/javascript" language="javascript" src="assets/datatables.min.js"></script>
<script type="text/javascript" src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script> 
<script type="text/javascript" language="javascript" src="assets/functionsDatatable.js"></script>
<script>
 function getInputValue()
 {
	 //alert("am I here?");
	var inputfileid = document.getElementById("fileid").value;
	var inputscreenid = document.getElementById("screenid").value;
	
	var randomnum =document.getElementById("myrandomid").value;
 
	if (inputscreenid=="")      {
			alert("Please enter the provided random number on the screen to the box.");
			document.getElementById("screenid").focus();
  			return false;
	}
	
	 if (inputscreenid != randomnum)      {
		alert("Please enter the provided random number on the screen to the box.");
			document.getElementById("screenid").focus();
  			return false;
	}

	 if (inputfileid=="")      {
			alert("File ID can not be null. Please enter the File ID.");
			document.getElementById("fileid").focus();
  			return false;
	}
  }

   
 function newTarget() {
		//alert("are we here");
 var w = window.open('about:blank','Popup_Window','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,width=500,height=400,resizeable,scrollbars');
    document.getElementById('searchform').target = 'Popup_Window';
}
</script>
	<cfoutput encodefor="html">
      <h1 class="page-title">WebFIRE</h1>
      <div class="panel-pane pane-node-content">
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">	
   
<cfif (cgi.request_method IS "post") AND (structKeyExists(form, "screenid"))>
<!---
    <cfif #Form.screenid# eq #Session.screenid#> 
 		<cfoutput><h3 style="color:OrangeRed;"> Answer: #Form.ticket#  </h3> </cfoutput>
	<cfelse>
	<cfoutput>Screen ID: #Form.screenid# Session: #Session.screenid# </cfoutput>
		</cfif>	<cfabort> 
--->
		<cfset myfileid = #form.fileid# >	

  <cfif IsDefined("Form.Newconfirm") and IsDefined("Form.ticket")> 
	<cfquery name="qryCheckData" datasource="#request.dataSource#" >
       select count(*) as totalcount from TBL_BULK_DOWNLOAD WHERE NEWUUID='#form.fileid#'   
     </cfquery>
	<cfif #qryCheckData.totalcount# eq "0">
	   <cfoutput> No record found, please go back and enter the correct file ID. </cfoutput>
   <cfelse>		
	<cfquery name="qryCheckStatus" datasource="#request.dataSource#" >
       select nvl(request_status, 'NA') as status from TBL_BULK_DOWNLOAD WHERE NEWUUID='#form.fileid#'   
     </cfquery>	

  <h2>Request Confirmation</h2>
 <p> Screen ID: #Form.screenid# - SessionID: #Session.screenid#<br/>
     Request: #Form.ticket#
	  <!--- Anna table update--->
  <cfif #Form.ticket# IS 'Yes' and  #qryCheckStatus.status# eq "CREATED">
	<P>Thank you for the request confirmation. Once the download file is ready, you will receive an email with a download link.</P>
		<cfquery name="qryUpdateData" datasource="#request.dataSource#" >
		update TBL_BULK_DOWNLOAD
			set request_status='REQUESTED', LASTUPDATED_DATE=SYSDATE, REQUESTED_DATE=SYSDATE WHERE NEWUUID='#form.fileid#' 
		</cfquery>  
  <cfelseif #Form.ticket# IS 'Yes' and  qryCheckStatus.status neq "CREATED">
    <P>Thank you for the request confirmation. This file ID is in the process or passed the download window. 
	 Please start a new request if you need download them again.
  <cfelse>
   <P>Thank you for the request confirmation. Your request is cancelled.</P>
	<cfquery name="qryUpdateData2" datasource="#request.dataSource#" >
	update TBL_BULK_DOWNLOAD
	set request_status='REQUESTE CANCELED', LASTUPDATED_DATE=SYSDATE, REQUESTED_DATE=SYSDATE WHERE NEWUUID='#form.fileid#' 
	</cfquery>
  </cfif>
 
</cfif>	
  </cfif></cfif>
<!--- Post confirmation from the email link with unique ID - rid= --->
 

<cfif IsDefined("url.rid") AND (cgi.request_method IS "get")> 
		<cfset numberLow=1 />
		<cfset numberHigh=10000 />
		<cfset randomid=#RandRange(numberLow, numberHigh, "SHA1PRNG")# />
		<cfset session.screenid=#randomid# />
			<h2>Request Confirmation Form:</h2>
<cfform name="requestconfirm" action="bulkrequestconf.cfm" method="post" target="_blank"onSubmit="return getInputValue()">
			<input type="hidden" name="myrandomid" id="myrandomid" value="#randomid#">
				<div>	<label>
						<input type="radio" name="ticket" id="ticket1" value="Yes" checked="checked">Yes, I have submitted the request and still want it.<br></label>
						<label>
						<input type="radio" name="ticket" id="ticket2" value="No">No, please cancel this request. <br></label>
					<br/>
						<label for="screenid"><p>Enter this random number below: #randomid#</label>
						 <br/><input type="text" name="screenid" id="screenid"></p>
			            <label for="fileid"><p>Enter the unique file ID </label>	
						 <br/> <input type="text" name="fileid" id="fileid"></p>
						<br>
				<!---		<p>...No need to add a reCAPCHA to prove it's a human request here ...</p> --->
					</div>	
					 <div class="buttonrow" style="margin-top: 2rem;">   
						<p class="text-left">
							<input name="Newconfirm" id="Submit"  type="submit" value="Confirm Request" /> 
							<input name="reset" id="reset"  type="reset" value="Cancel" alt="Cancel"  />
						</p>                 
					</div>	
					</cfform>

</cfif>	
	</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
</cfoutput>					
<cfinclude template="assets/footer1.cfm">