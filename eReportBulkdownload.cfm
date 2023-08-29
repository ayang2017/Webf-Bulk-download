<cfsetting requestTimeOut = "9000">
<!--- 
1. check if the checkboxes are defined 
2. Pass docid in a list
3. extract it from BLOB
4. generate random number for a file folder
5. Save it to a folder
6. create a zip package
7. List link
8. need to clean the package with a deleting function
--->
<!---
<cfdump var="#form#">
--->

<cfinclude template="assets/header1.cfm">
<style type="text/css">

}
#loader{
	 display: block; 
	 left: 0px;
	 right: 0px;
	 position:relative;
	 /*background: url('images/fire/loader.gif') center no-repeat #fff;*/
	 background:#fff;
	 width: 100%;
	 height: 100%;
	 z-index: 9999;
}
#results1{
 /*display: none; */
}
</style>
<script>
$(window).load(function() { 
  
  $("#loader").fadeOut("fast");  //Fade out the #loader div
});
</script>
<div id="loader">
        <p align="center">System Processing, please wait...
        <br />
      <!---  <img src="images/fire/loader.gif" width="250" height="250">---></p>
</div>   
<div id="results1">  
<cfinclude template="comp/commonfunctions.cfm">
<cfset numberLow=1 />
<cfset numberHigh=10000 />

<!--ERT ZIP-->
<!--- need 0 to hold the value  
<cfset NewUUID='3CDE4365A6D0D21' >
<cfset documentId='288371,275883,275865'>--->
<cfparam name = "documentId" default ="0"> 
 
 <!--- Check Table --->
  <cfquery name="qMakezip" datasource="#request.dataSource#">
    select user_email, newuuid,  doc_id_list 
      from tbl_bulk_download 
      where request_status='REQUESTED' and file_sum_size_mb >0 and doc_id_list is not null
  </cfquery>
 <!---  <cfdump var="#qMakezip#"><cfabort>    --->
  <cfif qMakezip.recordcount eq "0" >
      <cfoutput><p>No new file need to be processed.</p></cfoutput>
     <cfabort />
  </cfif>

  <cfloop query="qMakezip">
    <cfset NewUUID='#qMakezip.newuuid#' />
    <cfset DocumentId='#qMakezip.doc_id_list#' />
    <cfset Useremail='#qMakezip.user_email#' />
    <cfset fileid=#RandRange(numberLow, numberHigh, "SHA1PRNG")# />
       
    <cfoutput> <h1 class="page-title">WebFIRE</h1>
      <div class="panel-pane pane-node-content">
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">
            <h2>WebFIRE Bulkdownload Zip File Download</h2>  
            <div><p>Zip file (#NewUUID#) is ready and email to #qMakezip.user_email# has been sent.</p> </cfoutput>
      </div>
      <cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath())>
      <cfset delDirectory="#currentDirectory#bulkdownload" >
          <!---   <cfoutput>Download location: #delDirectory#</cfoutput>     --->
          <!--- clean up temp directory 
        <cfset subfolders = "" />
        <cfdirectory name="subfolders" action="list" directory="#delDirectory#" type="dir" recurse="yes" >
          <cfloop query="subfolders">
        	<!---<cfoutput>	<p>#subfolders.name#</p></cfoutput>--->
                <cftry>
                    <cfdirectory action="delete" directory="#delDirectory#\#subfolders.name#" recurse="yes" >
                <cfcatch> 
                        <!--- <b>Error Message:</b><cfoutput>#cfcatch.message#</cfoutput><br/> 
                        <b>Error Detail:</b><cfoutput>#cfcatch.Detail#</cfoutput> --->
                 </cfcatch> 
                </cftry>
        </cfloop>--->
       <cfset rptDirectory= "#delDirectory#\#fileId#"> 
     <!--- ALL FILES FIRST --->  

      <cfquery name="qdownload" datasource="#request.dataSource#">
         select DATA, ID as DOC_ID, DOCUMENT_NAME, submission_id  from cdx_submission_documents 
           where submission_id in (#DocumentId#) 
       </cfquery>
      
         <cfloop query="qdownload">
              <cfset myname=#qdownload.DOCUMENT_NAME#>   
                   <cfset myNameNew=Replace(myname, " ", "", "All")>
                   <cfset myNameNew=Replace(myNameNew, ",", "", "All")>               
                   <cfset myNameNew="#qdownload.submission_id#-#myNameNew#" >     
                        
								<!---<cfoutput><b>Debug:#myNameNew# </cfoutput>
                 download to submission_id level --->
           <cfset tmpDirectory= "#rptDirectory#"> 
             <cftry> 
                <cfif DirectoryExists(tmpDirectory)>  
									<!--- do nothing --->
								<cfelse>                                	
									<cfset DirectoryCreate(tmpDirectory)> 
                </cfif>
     <!---       <cfoutput><b>Debug: Downloading File Directory #tmpDirectory# successfully created.</b></cfoutput> --->
              <cfcatch>
									 <cfmail to="anna.yang@erg.com" from="webfire@epa.gov"  subject="An Error Has Occurred" type="html">
									  Error Message: #cfcatch.message#<br>
									  Error Detail: #cfcatch.detail#<br>
									  Error Location: #GetBaseTemplatePath()#<br>
									 </cfmail>
              </cfcatch> 
             </cftry> 
            <cfset myGeneratedFilesFolder="#tmpDirectory#\#myNameNew#">   
                     <cfscript> 
                           FileWrite("#myGeneratedFilesFolder#", "#qdownload.data#"); 
                      </cfscript>  
        </cfloop>

        <!--- at report level with recurse --->
     			<cfset tBegin = GetTickCount()>
        		<cfset rptFileDir = #rptDirectory# /> 
            <cfset targetFileDir = #rptDirectory# /> 
            
 <!---     <cfoutput>zip location: #targetFileDir#></cfoutput>   --->
                <cfset todayDate = Now()> 
                <cfset filedate="#DateFormat(todayDate, "mm-dd-yyyy")#">
                <cfset zipfile="BULKDOWNLOAD-#NewUUID#-#filedate#" />
                <cfset rptfinalZipFile="#targetFileDir#/#zipfile#.zip" />
      <cfoutput>  
      <cftry>           
           <cfzip action="zip" file="#rptfinalZipFile#" storepath="yes" overwrite="true">
                       <cfzipparam source="#rptfiledir#">
                       </cfzip>   
    <!---                         
    <li><p><a href="bulkdownload/#fileId#/#zipfile#.zip">
           Zip File: Bulk File Download Link</a></p></li>
        --->
   <cfcatch> 
           <b>Error Message:</b><cfoutput>#cfcatch.message#</cfoutput><br/> 
           <b>Error Detail:</b><cfoutput>#cfcatch.Detail#</cfoutput> 
    </cfcatch> 
 </cftry> 
 						<cfset tEnd = GetTickCount()>
						<cfset scriptTime = (tEnd - tBegin)>  
  <cfset    fileInfo = getFileInfo(rptfinalZipFile)>
  <cfset fileSize = NumberFormat(fileInfo.size / 1000 / 1000,'0.00')>
  <p> File size is :#filesize#MB</p>
</cfoutput>
<!--- email part --->
<cfif #filesize# gt 200>
   <cfmail to="#Useremail#"   from="no-reply-webfire@epa.gov" subject="Webfire email for bulk download "	type="text">
	<cfmailpart type="text/html">
  <p>Your unique file ID is : #NewUUID#</p>
  <p>Your request for bulk download is pauzed due to the zip file size is too large.<br/>
  Please submit a new request with less files.	</p>
  </cfmailpart>
</cfmail>
   <cfquery name="qdownloadUpdate" datasource="#request.dataSource#">
   update tbl_bulk_download 
   set final_email_out=sysdate, request_status='ZIPFILE OVER 200MB'
      where request_status='REQUESTED' and NEWUUID=NewUUID
</cfquery>
<cfelse>
     <cfmail to="#Useremail#"   from="no-reply-webfire@epa.gov" subject="Webfire email test for bulk download "	type="text">
	<cfmailpart type="text/html">
  <p><b>Notes</b>: The zip file will be deleted after 48 hours! </p>
  <p>Your unique file ID is : #NewUUID#. Click File Download Link below to download your selected files in one zip. 
    Since the size of some combined zip file may be very large, it may take a while for you to complete the download process.</P>
  <p>https://appdev4.erg.com/webfireAnna23/reports/bulkdownload/#fileId#/#zipfile#.zip	</p>
	</cfmailpart>
</cfmail>
<cfquery name="qdownloadUpdate" datasource="#request.dataSource#">
   update tbl_bulk_download 
   set final_email_out=sysdate, request_status='ZIPFILE READY'
      where request_status='REQUESTED' and NEWUUID=NewUUID
</cfquery>
</cfif>
</cfloop>

					</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
 </div> <!-- results1 -->       
<cfinclude template="assets/footer1.cfm">

<!--- common use CSV conversion 
moved to comp/commonfunctions included on the top--->
