<cfsetting requestTimeOut = "9000">
<cfinclude template="assets/header1.cfm">
<!--- security enhancements hz 5/8/21 
1.check the request origin and LCase(cgi.http_REFERER)
2.check form posting token
3.check cross domain forgary
4.remove hidden field is the key
--->
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
         
    <cflock scope="session" type="exclusive" timeout="10" >
                    <cfset startdate= #session.startdate# />
                    <cfset enddate = #session.enddate#  />
                    <cfset state = #session.state# />
                    <cfset county = #session.county# />
                    <cfset city = #session.city# />
                    <cfset zip = #session.zip# />
                    <cfset facility = #session.facility# />
                    <cfset frs = #session.frs# />
                    <cfset scc = #session.scc# />
                    <cfset CFRpart = #session.CFRpart# />
                    <cfset CFRSubpart = #session.CFRSubpart# />
                    <cfset organization  = #session.organization# />
                    <cfset POLLNAME = #session.POLLNAME# />
                    <cfset controldevice = #session.controldevice# />
                    <cfset pollutantmethod = #session.Mytestmethod# />
                    <cfset ReportCount = #session.totalcount# />
         <!---      <cfset pollutantmethod = #session.pollutantmethod# /> 
          <cfoutput>Anna Check: #session.MySearchSQL# </cfoutput><cfabort>  
             <cfdump var="#session#"><cfabort>  --->                                               
         </cflock>   
       
         <cfif state eq "AA"><cfset state=""></cfif>
<!---  <cfoutput encodefor="html"> --->
<cfoutput>	
      <h1 class="page-title">WebFIRE</h1>
      <div class="panel-pane pane-node-content">
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">
            <h2>WebFIRE Bulk Report Download</h2>
            <div>
            	<p>To request the bulk report download file containing the search results, enter your email and click on the Submit Request button below. WebFIRE creates bulk report download files during the overnight hours, when demands on the EPA WebFIRE server are lower. After assembling the download package, WebFIRE will send you an email containing a link to the bulk download page.</p>
  
            <cfform action="bulkrequest.cfm" method="post" name="searchform"  class="form-basic" id="searchform" preservedata="yes">
			
				 <table width="100%">
					       <thead>
                        <tr style="background-color:##d6d7d9; font-weight: bold;">
                            <td colspan="2">Search Criteria You Selected</td>
                        </tr>
                    </thead>
          <tr><td width="40%">Report Selected</td><td>#ReportCount#</td></tr>
					<tr><td width="40%">Report Type</td><td>ERT</td></tr>
					<tr><td width="40%">Submitting Organization</td><td>#organization#</td></tr>
					<tr><td width="40%">Facility Name:</td><td>#facility#</td></tr>
					<tr><td width="40%">CEDRI Submission Start Date:</td><td>#startdate#</td></tr>
					<tr><td width="40%">CEDRI Submission End Date:</td><td>#enddate#</td></tr>
					<tr><td width="40%">Facility State:</td><td>#state#</td></tr>
					<tr><td width="40%">Facility County:</td><td>#county#</td></tr>
					<tr><td width="40%">Facility ZIP Code:</td><td>#zip#</td></tr>
					<tr><td width="40%">Regulatory Part:</td><td>#CFRpart#</td></tr>
					<tr><td width="40%">Regulatory Subpart:</td><td>#CFRSubpart#</td></tr>
					<tr><td width="40%">FRS ID:</td><td>#frs#</td></tr>
					<tr><td width="40%">SCC:</td><td>#scc#</td></tr>
					<tr><td width="40%">Pollutant CASN:</td><td>#POLLNAME#</td></tr>
					<tr><td width="40%">Pollutant Test Method:</td><td>#pollutantmethod#</td></tr>
					<tr><td width="40%">Control Device:</td><td>#controldevice#</td></tr>
				</table>	
             <div>
                      <label for="email">Enter your email address:</label>   
                      <input name="email" id="email" type="text" maxlength="100" size="60">
                </div>

                <div>
                      <label for="confirmEmail">Confirm email address:</label>   
                      <input name="confirmEmail" id="confirmEmail" type="text" maxlength="100" size="60">                               
                </div>
             </div>
    
                <div class="buttonrow" style="margin-top: 2rem;">   
                	<p class="text-left">
                        <input name="Submit" id="Submit"  type="submit" value="Submit Request" /> 
                        <input name="reset" id="reset"  type="reset" value="Cancel" alt="Cancel"  />
                    </p>                 
                </div>
            </cfform>

						</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
</cfoutput>						
<cfinclude template="assets/footer1.cfm">

