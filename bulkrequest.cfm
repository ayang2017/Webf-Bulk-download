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
     <cfset myrandom="" />
	 <cfset myrandom=#RandRange(2, 50000, "SHA1PRNG")# />
		
 <cfset Email= #form.confirmEmail# />
 <cfset session.Email= #form.confirmEmail# />
 <!--- <cfoutput>User Email #Email#></cfoutput> --->
 <!--- double check insert when user refresh the page--->
 <cfquery name="qryCheckID" datasource="#request.dataSource#" >
   select count(*) as IDCount from TBL_BULK_DOWNLOAD where NEWUUID='#session.NEWUUID#' and request_status='CREATED'
   </cfquery>
   
   <cfset myFilesize="0">
   <cfset myFilesize=#session.Filesizesum# >
   <cfset myFilelist=" "> 
   <cfset myFilelist='#session.docidlist#' >
   <cfset mystring1='#trim(session.MySearchSQL)#' >
   <cfset mystring2=' and d.submission_id in (#session.docidlist#)' >
   <!--- deal with whole set or manual selected --->
    <cfset myorigct=#session.origcount#>
	<cfset mynewct=#session.totalcount#>
   
   <cfif myorigct eq mynewct >
       <cfset mynewsql=mystring1 >
  	<cfelse>
	 <cfset mynewsql=mystring1 & mystring2>
    </cfif>
  
  <!---<cfoutput>List: #session.NEWUUID#  at  #session.docidlist# </cfoutput>
  <cfoutput>For SQL #mynewsql#</cfoutput> <cfabort>
  <cfdump var="#session#"><afabort>--->
  <cfif qryCheckID.IDCount eq "0" > 
 <!--- Anna insert table --->
 
<cfquery name="qryAddData" datasource="#request.dataSource#" >
   Insert into TBL_BULK_DOWNLOAD(TB_ID, SEARCH_QUERY, USER_EMAIL, request_status,LASTUPDATED_DATE, file_count, NEWUUID,file_sum_size_mb, doc_id_list)
   values(#myrandom#, '#mynewsql#', '#session.Email#', 'CREATED',SYSDATE, #session.totalcount#, 
   '#session.NEWUUID#',#myFilesize#, '#myFilelist#')
 </cfquery> 

 <cfmail to="#form.confirmEmail#"	from="no-reply-webfire@epa.gov"	subject="Webfire email test "	type="text">
 <cfmailpart type="text/html">
 <p>Thanks for submitting the download request ticket. Please click the link below to confirm your request.<br/>
	https://appdev4.erg.com/webfireAnna23/reports/bulkrequestconf.cfm?rid=#myrandom# </p>

 <p>Your unique file ID is : #session.NEWUUID#</p>
 </cfmailpart>
	
</cfmail>
</cfif>

<cfoutput encodefor="html">		
      <h1 class="page-title">WebFIRE</h1>
      <div class="panel-pane pane-node-content">
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">
			  
<cfif IsDefined("form.Submit") and ((#form.Submit#) eq "Submit Request")> 		  
      <h2>WebFIRE Bulk Download Request Confirmation</h2>
       <div>
        	<p>Thank you for requesting the Bulk Download. You will receive a confirmation email from no-reply-webfire@epa.gov. 
			<br/>Please follow the link in the email to confirm your request.</p>
				<hr> 	
<cfelse>  
<!--- Post confirmation from the email link with unique ID - rid= --->
<!---<cfelseif --->
<cfif IsDefined("url.rid")> 
		<cfset numberLow=1 />
		<cfset numberHigh=10000 />
		<cfset session.screenid=#RandRange(numberLow, numberHigh, "SHA1PRNG")# />

		<h2>Request Confirmation Form:</h2>
			<form action="bulkrequestconf.cfm" method="post" name="confirm">
			<div>
			 <label><input type="radio" name="ticket" id="ticket">Yes, I have submitted the request and still want it.<br></label>
			 <label><input type="radio" name="ticket" id="ticket">No, please cancel this request <br></label>
			<br/>
				<p>Enter this random number <strong>#session.screenid#</strong> into the box to prevent misusing the EPA system.</p>
						<input type="text" name="screenid" id="screenid">
						<p>Need to add a reCAPCHA to prove it's a human request here ...</p>
					</div>	
					 <div class="buttonrow" style="margin-top: 2rem;">   
						<p class="text-left">
							<input name="Submit" id="Submit"  type="submit" value="Confirm Request" /> 
							<input name="reset" id="reset"  type="reset" value="Cancel" alt="Cancel"  />
						</p>                 
					</div>	
					</form>
		<cfelse>
				<p>Go to Search Page (link) to start the proces</p>
		</cfif>

</cfif>	
	</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
</cfoutput>						
<cfinclude template="assets/footer1.cfm">
