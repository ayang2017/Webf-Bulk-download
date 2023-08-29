
<cfsetting requestTimeOut="12000">
<cfparam name="StartRow" default="1"> 
<cfparam name="EndRow" default="500"> 
<!--- check URL passing values --->
<!---<cfparam name="URL.StartRow" type="integer">S
<cfparam name="URL.EndRow" type="integer">--->
<!---
<cfif structKeyExists(url, 'startrow') and IsNumeric(URL.StartRow) >
		<cfset StartRow=#URL.StartRow# >
<cfelse>
		<cflocation url="rptSearch.cfm" />      
</cfif>  --->      
<cfif IsDefined("URL.StartRow") and IsNumeric(URL.StartRow) >
	<cfset StartRow=#URL.StartRow# >
<cfelse>
	    <cfset StartRow=1 >
</cfif>

<cfif IsDefined("URL.EndRow") and IsNumeric(URL.EndRow) >
	<!--- do nothing --->
<cfelse>
	    <cfset EndRow=500 >
</cfif>

<cfparam name="MaxRows" default="500"> 
<cfinclude template="comp/qryGetSubmission-e.cfm">

<cfinclude template="assets/header1.cfm">



<script type="text/javascript" language="javascript" src="assets/datatables.min.js"></script>
<script type="text/javascript" src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script> 
<script type="text/javascript" language="javascript" src="assets/functionsDatatable.js"></script>
<script>

	// Popup window code - change to jquery UI is needed
	var popupWindow = null;
	function newPopup(url) {
		popupWindow = window.open(
			url,'popUpWindow','height=400,width=600,left=250,top=250,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
		popupWindow.focus();
		return popupWindow;
	}

function checkdata() {
	//alert("am I here?");
	var $form=$(this);
	var table = $('#myDocTable').DataTable();
	var docrowcollection =  table.$("#docbulk1:checked", {"page": "all"});
	var csvrowcollection =  table.$("#doccsv1:checked", {"page": "all"});
	var doccheckid=docrowcollection.map(function(){
			return $(this).val();}).get();
			//alert(doccheckid.length);
			
			//console.log(doccheckid);
		$('#docbulk').val(doccheckid);
	
			
	var csvcheckid=csvrowcollection.map(function(){
			return $(this).val();}).get();
			//alert(csvcheckid.length);
			$('#doccsv').val(csvcheckid);
	
			//alert($('#doccsv').val());
			
	if ((doccheckid.length =="0") && (csvcheckid.length =="0")) {
				alert("Please check a Bulk Down box or a CSV File box");
  			return false;
	}
	if (doccheckid.length >10)      {	     
       if (confirm("You have manually selected more reports than the WebFIRE limit, which is 10 reports (see the instructions under Downloading Reports). Click 'OK'  to request a bulk download of the files you selected.")) {
                return true;
                } else {
                   return false;
                   }            
	}

}
function newTarget() {
		//alert("are we here");
 var w = window.open('about:blank','Popup_Window','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,width=500,height=400,resizeable,scrollbars');
    document.getElementById('searchform').target = 'Popup_Window';
}
</script>

     <cfoutput> 
        <!--- newPopup function in layFire.cfm --->
        <cfset mycurrentSubmissionID=0>
        <cfset mypreSubmissionID=0>
        
        
        <cfset mycount = #qryGetERTSubmission.recordcount#>

        <!---<cfset mycount = #qryGetERTSubmission.total_count#>--->
        <cfset totalcount=#mycount# >
        <cfset totalcountFormat = NumberFormat(#mycount#, ",")>
        
        <cfset reportCountStr ="">
        <cfset totalcount=0>
        <cfloop query="qryGetERTSubmissionByReportTypes">
					<cfset reportCount1 = #Report_doc_type#>
                    <cfset reportCount2 = #mycount#>
                    <cfset reportCount2Format = NumberFormat(#mycount#, ",")>
                    
                    <cfif reportCount2 gt 1>
                 	   <cfset reportCount1 = reportCount1 & "s">
                    </cfif>
                    <cfset totalcount = totalcount + reportCount2>
                    <cfset reportCountStr = #reportCountStr# & #reportCount2Format# & " " & #reportCount1# & ", ">
        </cfloop>
        
        <cfif totalcount gt 1>
        	<cfset reportCountStr = Left(reportCountStr, Len(reportCountStr)-2)>
        </cfif>

  <h1 class="page-title">WebFIRE Report Search Results and Viewing Instructions</h1>
  <div>The Report Search Results table below shows the <b>#totalcountFormat#</b> records in WebFIRE that match your search criteria. <b>These records and any related attachments may or may not have been reviewed by the state, local, or tribal air pollution agency or delegated authority.</b>
            </div>
            <br />
                  <div>The Report Search Results table below shows the records and any related attachments (indicated by the <img border="0" width="20" height="20" src="assets/images/paperclip.png" alt="paper clip icon" > icon in the search results table). Click <a href="##"  onclick="javascript:history.go(-1)"><b>REVISE CURRENT SEARCH</b></a> to return to your search criteria. 
                  Click  to start a new search.</div>
  <div class="panel-pane pane-node-content">
    <div class="pane-content">
      <div class="node node-page clearfix view-mode-full">
        <div id="accordion">
          <h3>Viewing Instructions</h3>
          <div>
      
	<cfif mycount gt 500>
            <p>To reduce the processing time needed for your search request, WebFIRE retrieves only the first 500 reports (sorted alphabetically by organization name) for display in the results table. Click on "Next Page" located at the bottom right of the results table to display more of the first 500 records in the results table. Click on "Next 500 Records" located at the bottom right of the page to display the next batch of records in the results table. You can reduce the number of reports returned for your search by specifying additional search criteria. </p>
    </cfif>
 <br />
            <p>You can alphabetically sort the information displayed in the search results table using the up/down arrows located to the right of each of column header. The "Search Page" window located at the upper right-hand side of the search results table allows you to find records in the results table using keywords. You can also use the drop-down menus located at the bottom of the result table beneath the column headers to refine the records displayed in the results table.</p>
            <br />
            <p>The following acronyms identify the types of reports presented in the search results table:</p>
            <ul>
            
              <li>AER = Air emissions reports (e.g., periodic summary reports, excess emissions reports).</li>
              <li>ST = Performance test reports (including performance evaluations/relative accuracy test audits (RATA)).</li>
              <li>NOCS = Notification of compliance status reports.</li>
            </ul>
            
          <p>In some cases, a report type will also have a report sub type designation. Click <a href="##" onClick="newPopup('../fire/view/glossary.html##reportsubtype')" title="Click here for description"><strong>here</strong></a> for a description of the report sub types currently in WebFIRE.</p>
           <br />
            <p>The displayed reports are available in Adobe Portable Document Format (pdf) or in a compressed format (zip file). All reports submitted to WebFIRE have an associated Extensible Markup Language (XML) file that contains metadata from the report that is used to populate the WebFIRE database. Depending on how the report and XML files were packaged for submittal to EPA's Compliance and Emissions Data Reporting Interface (<a href="http://www3.epa.gov/ttn/chief/cedri/index.html"  target="_blank">CEDRI</a>), the XML file is embedded in the zip file or is available separately as a related attachment. You can download reports from the search results table by clicking on the document name.</p>
             <br />
            <p>If a report has related attachments, clicking on the <img border="0" width="20" height="20" src="assets/images/paperclip.png" alt="paper clip icon" /> icon will open a separate window that displays the report and all related attachments for that report that are available for downloading. </p>
             <br />
            <p>All performance test reports submitted to WebFIRE have a report type designation of "ST" whether the test report was submitted using the EPA's Electronic Reporting Tool (<a href="https://www3.epa.gov/ttnchie1/ert/" target="_blank">ERT</a>) application, or was submitted as a pdf file. Performance tests submitted to WebFIRE using the ERT have a report sub type designation of "ERT." The zip file for these test reports contains a Microsoft Access database file (.accdb or .mdb file extension). This database file is the Project Data Set (PDS) which includes all of the information required by the ERT application. Click <a href="" onClick="newPopup('../fire/view/download_description.html##viewERT')" title="Click here for instructions"><strong>here</strong></a> for instructions on viewing the PDS using the ERT application.</p>
             <br />
             </div>
             <h3>Downloading Reports</h3>
          		<div>                          
                    <p>You can download individual reports from the search results table by clicking on the document name. If a report has related attachments, clicking on the  icon will open a separate window that displays the report and all related attachments for that report that are available for downloading. Alternatively, you can download multiple reports from the search results table by creating a bulk download package. </p>
                       <br />
                       
<cfset reporttype=#ValueList(qryGetERTSubmissionByReportTypes.Report_doc_type, ",")#>
<cfset tempERT = #findnocase("ST",reporttype)# />  
                
<cfif (#tempERT# gt "0") >      
     <p> You can also create a Comma Separated Value (CSV) spreadsheet containing the XML data for selected performance tests that are available in the ERT format (the CSV file option is not available for performance tests available in pdf format). Where test run-level data are available in the selected ERT files, the CSV file contains the average values calculated from the test run data.  Click <a href="##" onclick="javascript:ColdFusion.Window.show('msgWindow')"><b>here</b></a> for the procedures followed in calculating the average value and in assigning the detection limit flag to the calculated average. </p>
<br />
<p>Select the reports for inclusion in the bulk download package by clicking the box under the column 
"Include in Bulk Download" and select the ERT performance tests for inclusion in the CSV spreadsheet by 
clicking the box under the column "Include in CSV File". After you have selected the reports of interest, 
click on "Bulk Download Selected Reports and/or CSV File" at the bottom of the search results table. 
Depending on the number and type of reports you select, the size of the bulk download package and/or CSV spreadsheet 
can be large. To reduce time needed to prepare and download the bulk package, limit the manual selections of performance 
test reports (e.g., ERT submissions) to 10 for a single download. If you are interested in downloading the XML data 
for all performance tests in WebFIRE that are available in the ERT format, click on the link <b> 
<a href="download/WebFIRE-BULK-XML-DATA.zip" target="_blank">"Download All ERT XML Data"</a></b> here.
 This complete CSV data file is updated nightly.</p>

<!--- <p>Select the reports for inclusion in the bulk download package by clicking the box under the column 
"Include in Bulk Download" and select the ERT performance tests for inclusion in the CSV spreadsheet by 
clicking the box under the column "Include in CSV File". After you have selected the reports of interest, 
click on "Bulk Download Selected Reports and/or CSV File" at the bottom of the search results table. 
Depending on the number and type of reports you select, the size of the bulk download package and/or CSV 
spreadsheet can be large. To reduce time needed to prepare and download the bulk package, limit the selections 
 ERTs to 10 for a single download.  If you are interested in downloading the XML data for all performance 
 tests in WebFIRE that are available in the ERT format, click on the link <b> <a href="download/WebFIRE-BULK-XML-DATA.zip" 
 target="_blank">"Download All ERT XML Data"</a></b> here. This complete CSV data file is updated nightly.</p>--->

</cfif>
<br />  
                    <p>WebFIRE generates separate bulk download packages for each type of report and/or data you select using the following naming conventions that specify the type of report contained in the bulk file (i.e., AER, ERT, NOCS) and the file creation date: </p>
                    <ul>
                        <li>WebFIRE-Bulk-AER-mm-dd-yyyy.zip for AERs. </li>
                        <li>WebFIRE-Bulk-NOCS-mm-dd-yyyy.zip for NOCSs.</li>
                        <li>WebFIRE-Bulk-ST-Data-mm-dd-yyyy.zip for performance test reports.</li>
                        <li>WebFIRE Bulk-ERT-XML-CSV-mm-dd-yyyy.zip for ERT XML data.</li>
                    </ul>
                    <p>The bulk files contain the selected files grouped by facility. The file names in each facility folder specify the submission date, submission ID, and file name of the report (e.g., 2015-07-23-145268-NOCS_NOCS_Notificationrequiredunder40CFR63.11225(a)(4).pdf).</p>
                 
                </div>
            
            </div><!---collapse level at h3 tag --->
          </div><!---/accordion onSubmit="checkdata()" --->
     <cfif totalcount gt 10>
      <cfoutput><div>
        To obtain a zip file containing all the reports that match your search criteria, click <b><a href="bulkdownload.cfm">
        BULK REPORT DOWNLOAD</b></a>.     
       </cfoutput></cfif>
   <form name="searchform" id="searchform" class="resultsform" action="ereportdownload.cfm" method="post" target="_blank" onSubmit="return checkdata()" >
    
     <input type="hidden" name="docbulk" id="docbulk">
      <input type="hidden" name="doccsv" id="doccsv">
	<h3 class="green">Report Search Results</h3>    				
           <cfif mycount gt 0>  
                  
          <cfset currentURL = CGI.SERVER_NAME & CGI.SCRIPT_NAME>
              <input type="hidden" name="mycurrenturl" value="#currentURL#" id="mycurrenturl"/>
                  
			<cfset directDownloadURL = Replace(currentURL, "reports/eSearchResults.cfm", "")>
            <cfset directDownloadURL = "http://" & directDownloadURL & "FIRE/view/dspERTDocumentDetails.cfm?ID="> 
                                        
          <table id="myDocTable"  class="cell-border compact stripe" >
                    <thead>
                    <tr>
                         <th id="th1">Organization</th>
                         <th id="th2">Facility</th>    
                         <th id="th3">City</th>    
                         <th id="th4">State</th>
                         <th id="th5">County</th>
                         <th id="th6">Submission <br />Date</th>
                         <th id="th7">Report<br />Type</th>
                         <th id="th8">Report<br />Sub Type</th>
                         <th id="th9">Pollutants</th>
                         <th id="th10">Control<br />Devices</th>
                         <th id="th11">Document</th>
                         <th id="th12">Related <br />Attachment(s)</th>
                         <th id="th13">Include Report in <br>Bulk Download</th>
                         <th id="th14">Include Data in <br>CSV File
                         <br /><br />
                         <cfif (#tempERT# gt "0") >  
                         	<input type="checkbox" name="select_all" value="1" id="example-select-all">Select All
                         </cfif>
                         </th>
                     </tr>
                     </thead>
                     
                     <tfoot>
                    <tr>
                         <th>Organization</th>
                         <th>Facility</th>    
                         <th>City</th>    
                         <th>State</th>
                         <th>County</th>
                         <th>Submission <br />Date</th>
                         <th>Report<br />Type</th>
                         <th>Report<br />Sub Type</th>
                         <th>Pollutants</th>
                         <th>Control<br />Devices</th>
                         <th>Document Name</th>
                         <th>Related <br />Attachment(s)</th>
                         <th>Include in <br>Bulk Download</th>
                         <th>Include in <br>CSV File</th>
                     </tr>
                     </tfoot>
                     
                     <tbody>
                     <cfset mycounttotal = 0>
     <cfoutput>Counts: #qryGetERTSubmission.recordcount#</cfoutput>

               <cfloop query="qryGetERTSubmission" startrow="#startRow#" endrow="#EndRow#">
                      
                    	  <cfset mysubmission_id = #qryGetERTSubmission.submission_id#>
                      	<cfset myDocID = #id#>
               		 	
<!--- hui stopped here for the query below 4/18/2019--->
		 <cfquery name="qryGetFilesBySubmissionID" datasource="#request.datasource#" timeout="24000">
 			select count(*) as myCountFile from
                		cdx_submission_documents where submission_id=#mysubmission_id#
                 </cfquery>

          
             <cfloop query="qryGetFilesBySubmissionID">
                      	<cfset myCountForFiles = #myCountFile#>
                      </cfloop>
     
                <cfset myCountForFiles = 1>
                     <cfif #myCountForFiles# gt  0>	
                         <tr>   
                             <td>#ORG_NAME#</td>
                             <td>#Facility#</td>
                             <td>#City#</td>    
                             <td>#State#</td>
                             <td>#County#</td>
                             <td>#Submission_time#</td>                                
                             <td>#Report_Doc_Type#</td>
                             <td>#Report_doc_sub_type#</td>  
                             <td>#Pollname5#</td>
                        	 <td>#replace(Controlv5, chr(44), "; ", "All")#</td>
                             <cfset myurl = #directDownloadURL# & #myDocID#> 
                             <td><a href="#myurl#" title="#DOCUMENT_NAME#"><img src="assets/images/document.png"></a>
                             </td> 	
                           <cfif #myCountForFiles# gt 1>	                      
                                 <td class="docname" id="#mysubmission_id#" align="center" valign="middle">
                                    <img border="0" width="20" height="20" src="assets/images/paperclip.png">
                                 </td> 
                            <cfelseif #myCountForFiles# eq  1 > 
                            	<td>No Attachments</td> 
                            </cfif>    
                             <!--- show checkbox if it's ERT type, deal with it later hz --->
                             <td><input type="checkbox" name="docbulk1" id="docbulk1" value="#submission_id#"   ></td>
                             <td>
                             	<cfif (#Report_Doc_Type# eq "ST") and (#trim(Report_doc_sub_type)# eq "ERT") >
                             			<input type="checkbox" name="doccsv1" id="doccsv1" value="#submission_id#">
							 					
                             	<cfelse>					
                                				N/A
                                                <input type="hidden" name="doccsv1" id="doccsv1" disabled="disabled">
                                  </cfif> 
                             </td> 
                         </tr>                       
                     </cfif>

       </cfloop>
		     </tbody>
                </table>	
				

	<br />
                    
                </cfif>
			
          			<div>
                   <div style="float: right">
 <!---       <a href="download/combined-average-V4-V5-data.xls" target="_blank"><input type="button" name="downloadall" value="Download All ERT XML Data"></a> --->
            	<cfif (#tempERT# gt "0") >
                
                     <cfset buttonValue="Bulk Download Selected Reports and/or CSV File" > 
                      
             	<cfelse>
              		<cfset buttonValue="Bulk Download Selected Reports" > 
              	</cfif>    
                
             		 <input type="submit" name="download" value="#buttonValue#"> 
                    </div>
                  </div> 
              	<div style="clear:both"></div>
                <div>	
              		<div style="float: right"><strong> 
					<cfset NextStartRow=Evaluate(StartRow + MaxRows) >
                  
                    <cfset NextEndRow=Evaluate(NextStartRow + MaxRows-1) >
                    
                        <cfif (StartRow) GTE (MaxRows) > 
                            <cfset PreStartRow=Evaluate(StartRow - MaxRows) />
                            <cfset PreEndRow=Evaluate(PreStartRow + MaxRows-1) />
                                    <a href="#CGI.SCRIPT_NAME#?startrow=#PreStartRow#&endrow=#PreEndRow#"> 
                            Previous #MaxRows# Records</a> 
                         </cfif> </strong>
            
                        <cfif (StartRow + MaxRows) LTE qryGetERTSubmission.RecordCount > 
                                    <a href="#CGI.SCRIPT_NAME#?startrow=#NextStartRow#&endrow=#NextEndRow#"> 
                            Next #MaxRows# Records</a> 
            
                         </cfif> </strong>
       				</div>
                </div>
                  <div style="clear:both">
                      <p>
                      You can refine the reports displayed in the search results table using one or more of the drop-down menus located at the bottom of the table. For example, to display reports for particular facility, click on the down arrow in the drop-down menu below the "Facility" column and click on the facility name of interest. To reset a particular data filter, click "ALL" at the top of the drop-down list.
                      </p>
       
      			</div>      

     <cfwindow name="userWin" title="Files Available for Downloading" bodystyle="background-color:##fff" initShow="false" modal="true" width="600" height="300" center="true"></cfwindow>
		  <div style="clear:both"></div>    
     </form>
     
				</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
</cfoutput>	
<cfwindow name="msgWindow" title="Calculated Flags" center="true" bodystyle="font:14px/1.5 Arial, Helvetica, sans-serif;background-color: white;">
<br />
    <h2>Calculated Average and Detection Limit Flag Assignment for Test-Run Level Data</h2>
    <p>Because of the low concentration levels typically associated with analytes measured using EPA's Method 23 (Determination of Polychlorinated Dibenzo-p-Dioxins and Polychlorinated Dibenzofurans from Stationary Sources), the calculated average values in the Comma-Separated Values (CSV) file include test runs where the value is zero. For analytes measured using all other test methods, zero values are not included in the calculated average.</p>
    <br />
    <p>The detection limit flag (ADL, DLL, or BDL) is assigned to the calculated average value in the CSV file using the following procedures.</p>
    <br />
    <table>
        <tr>
            <th>Test run flags</th><th>Assigned flag</th>
        </tr>    
        <tr>
            <td>All ADL</td><td>ADL</td>
        </tr>   
        
        <tr>
            <td>Mix of ADL and BDL</td><td>ADL</td>
        </tr>      
        <tr>
            <td>All DLL</td><td>DLL</td>
        </tr>   
        <tr>
            <td>Mix of DLL and BDL</td><td>DLL</td>
        </tr>
        <tr>
            <td>Mix of ADL, DLL and BDL</td><td>DLL</td>
        </tr>
    
        <tr>
            <td>All BDL</td><td>BDL</td>
        </tr>
    </table>

</cfwindow>   
<cfinclude template="assets/footer1.cfm">
