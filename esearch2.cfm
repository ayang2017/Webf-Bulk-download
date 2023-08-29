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
<!--- Anna edit
<cfif len(cgi.http_referer) and LCase(cgi.http_REFERER) is NOT "#currentServer#/webfire/reports/esearch.cfm">
<cflocation url="/webfire/404.cfm">
<p>Sorry, the client request is invalid"</p>
</cfif>
--->
   <cfquery name="qryPOLLNAMEList" datasource="#request.datasource#"> 
                    <!---   select  distinct (POLLUTANT_NAME) as POLLNAME
                        from   test_ef_data_csv_sum ORDER BY POLLUTANT_NAME--->
                     
	    	  select  distinct CASN, (ERT_POLLUTANT_NAME) as POLLNAME
                        from   test_ef_pollutant_name ORDER BY ERT_POLLUTANT_NAME
                    </cfquery>
           
					<script type="text/javascript" src="assets/jquery-ui.js"></script>  

 
   <link rel="stylesheet" type="text/css" href="assets/selects/jquery.multiselect.css" />
<!---   <link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/ui-lightness/jquery-ui.css" />--->
<script type="text/javascript" src="assets/selects/jquery.multiselect.min.js"></script>
<script type="text/javascript" src="assets/selects/jquery.multiselect.filter.js"></script>
<link rel="stylesheet" type="text/css" href="assets/selects/jquery.multiselect.filter.css" />

    <script src="assets/esearch2.js"></script>
    <script type="text/javascript">
		$(function(){
			//$("select").multiselect();
			//$("select").multiselect().multiselectfilter();
			
			$("#scc").multiselect();
			$("#scc").multiselect().multiselectfilter();
			$("#frs").multiselect();
			$("#frs").multiselect().multiselectfilter();
			$("#pollutants").multiselect();
			$("#pollutants").multiselect().multiselectfilter();
			$("#pollutantmethod").multiselect();
			$("#pollutantmethod").multiselect().multiselectfilter();
			$("#controldevice").multiselect();
			$("#controldevice").multiselect().multiselectfilter();
          		});
</script>
    <script>
	<!-- initialize multiple selection -->
	   $(document).ready(function() {
        $('#example-getting-started').multiselect({
		enableCaseInsensitiveFiltering: true,
		 maxHeight: 200,
		 nonSelectedText: 'Select Pollutants!'
		});
    });
	
	var tmpVal="";
		function getSelected(){
						var tmpVal="";
						tmpVal=$("#CFRSubpart option:selected").map(function () {
						 return $(this).text();
						}).get();
						//console.log(tmpVal.join());
						//$("#CFRValue").html("<span><b>Selected SubPart Values:</b> " + tmpVal.join(', ')+"</span>")
		}
		 
		function resizeChild(){
			$('#CFRSubpart').attr('size', 10);
			$('#CFRSubpart').width(950);	
		}
		
/*		function reloadPage() {
			document.getElementById("searchform").reset();
			$('#CFRpart').val("");
			$('#CFRSubpart').val("");
		}*/
</script>
	<!--- close cfoutput encode tag is at then end of this page for  --->	
<cfoutput encodefor="html">				 
<!--googleon: all-->
      <h1 class="page-title">WebFIRE</h1>
      <div class="panel-pane pane-node-content">
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">
            <h2>WebFIRE Report Search and Retrieval Criteria</h2>
            <div>
            	<p>You can select one or more of the following search criteria to refine your search for selected report types from the previous page.  To enter your search criteria, click on arrow to open or close the criteria menu.  After you have selected the search criteria of interest, click on the Submit button to retrieve the relevant reports from WebFIRE.</p>

       
             </div>
                  <!--- deal with report type --->
              <cfoutput>  
                <cfset strReporttype="" /> <!--- search report criteria --->
                <cfparam name="reporttype" default="">
                <cfif IsDefined("form.reporttype")> 
                        <cfif form.reporttype is not ""> 
                            <cfset reporttype = #form.reporttype# > 
                        </cfif> 
                </cfif> 
               
                <cfset strReporttype=replace(reporttype, "ST", "Performance Test") />
                <cfset strReporttype=replace(strReporttype, ",", ", ","All") />

             <h3>Search Criteria for #strReporttype# Reports </h3>
           
			 </cfoutput>
             
   <cfform action="eSearchResults.cfm" method="post" name="searchform"  class="form-basic" id="searchform" preservedata="yes">
    <cflock scope="session" timeout="10" type="exclusive">
 		<cfset session.reporttype =#reporttype# />
	</cflock>
 
            <!--- <cfinput type="hidden" name="reporttype" value="#reporttype#" size="30"  maxlength="60">--->
              <fieldset>
                <div id="accordion">
                  <h3 class="accordion-header">Submitting Organization and/or Facility Name</h3>              
                  <div>
                        <div>
                           <label for="organization">Submitting Organization</label>
                          <input name="organization" id="organization" size="30" type="text" maxlength="100" />        
                        </div>
                        <div>
                          <label for="facility">Facility Name</label>
                           <cfinput type="text" name="facility" size="30"  maxlength="100">
                        </div>
                  	 
                  </div>
                  
                  <h3>CEDRI Submission Date</h3>
                  <div>
                    <div>
                      <label for="startdate">Start Date</label>
                      <cfinput id="startdate" type="text" name="startdate" class="startdate text" validate="date" value="" size="30" maxlength="10"/>
                      <span>(MM/DD/YYYY)</span> 
                    </div>
                    <div>
                      <label for="enddate">End Date</label> 
                     <cfinput id="enddate" type="text" name="enddate" class="enddate text" validate="date" value="" size="30" maxlength="10"/>
                      <span>(MM/DD/YYYY)</span>          
                    </div>
                  </div>
                  <h3 class="accordion-header">Facility Location</h3>
                    <div>
                      <div>
                      <label for="State">State</label>
                    
                        <cfquery name="statedata" datasource="#request.datasource#">                       
                             select  state as myId, state_name as myDesc
                             from ref_state order by myDesc    
                        </cfquery>

                  <cfselect  name = "state" id="state"
                            size = "5"  
                            multiple="yes"  
                            required = "Yes" 
                            message = "Select one or more state"  
                            query = "statedata"  
                  
                            display ="myDesc"  
                            value ="myId"  
                            queryPosition="Below"
                            class="state"> 
                            <option value = "AA" Selected>All</option>
    					</cfselect>
                      <p>(Control-Click for multiple selections)</p>
                    </div>
                    <div>
                      <label for="County">County</label>
                     	<cfparam name="form.county" default="25001"> 
                        <cfselect name="county" id="county"
                                        selected="#form.county#"
                                        bind="cfc:comp.countyAutoSelectComp.getCounty_search({state})" 
                                        value="MYID"  
                                        display="MYDESC"
                                        bindonload="true"
                                        multiple="yes" 
                                        style="width:200px"                       
                                        >                          		
                        </cfselect> 
                      <p>(Control-Click for multiple selections)</p>
                    </div>
                    
                    <div>
                      <label for="City">City</label>   
                      <cfinput type="text" name="city" value="" size="30"  maxlength="60">
                               
                    </div>
                    <div>
                   		<br />
                      <label for="zip">Zip Code</label>
                       <cfinput type="text" name="zip" value="" size="10" validate="zipcode"  maxlength="10">    
                    </div>                
                  </div>
                             
                  <h3 class="accordion-header">Regulatory Part and Subpart</h3>
                  <div>               
                        <div id="CFR">
                          <label for="CFRpart">
                            <a href="" onClick="newPopup('fire/view/terms.html##CFRpart')" title="Click for CFR part Description">CFR Part</a>
                          </label>
                           <cfselect id="CFRpart" name="CFRpart"  class="notification" multiple="yes" 
                                    style="width:250px;" onChange="resizeChild()">  
                            <option value="All">All</option>       	
                            <option value="Part 60">Part 60 - NSPS</option>
                            <option value="Part 62">Part 62 - Federal Plan</option>
                            <option value="Part 63">Part 63 - NESHAP</option> 
                          </cfselect>
                                  <p>(Control-Click for multiple selections)</p>  
                        </div>  
                        <div id="CFRSub"><label for="CFRSubpart">
                        <a href="##" onclick="newPopup('../fire/view/terms.html##CFRSubpart)" title="Click for CFR Subpart Description">CFR Subpart</a><br/>
                        </label>
                         
                         <cfselect name="CFRSubpart" id="CFRSubpart"
                                    bind="cfc:comp.countyAutoSelectComp.getCFRSubpart({CFRpart})" 
                                    value="MYDESC"  
                                    display="myTitle"                            
                                    multiple="yes" 
                                    style="width:500px"
                                    size="3"  
                                    bindonload="true"
                                    onChange="getSelected()"
                                    >                          		
                        </cfselect>  
                         	<p>(Control-Click for multiple selections)</p>
                        	<div id="CFRValue"></div>
                        </div>
                  </div> 
                 
                    
                  	<cfquery name="qryFRS" datasource="#request.datasource#"> 
                    		select distinct FRS
                        	  from cdx_submission_documents c, xml_parse_geo_info d  
                        	  where c.submission_id=d.submission_id 
                        	  and trim(d.FRS) is not null
                              and FRS not in('001','002','003','013000304615Z2478','0530021','123','146822','160445','173423','20847','2401300012','3312','37641061100','4709300008','4809100009','51-023-0003','523629','54003000012','9200290','935289','939793','959865','962478','962981','AFS','330900038','0130003','04615Z2478','Enter Id','NA','PENDING','AFS 330900038')
                              <cfif (#reporttype#) neq ""  and (#reporttype#) neq "All" >  
                              	and c.Report_doc_type in (<cfqueryparam value= "#reporttype#" cfsqltype="cf_sql_varchar" list="yes">)
                              </cfif>
                              order by FRS
                   	</cfquery> 
                  <h3 class="accordion-header">FRS ID</h3>
                  <div>  
                    <div>              
                        <div><label for="frs">
                    <a href="##" onClick="newPopup('../fire/view/terms.html##FRSID')" title="Cilck for FRS ID Description">Available FRS ID</a></label>                   
                    	    <cfselect id="frs" name="FRS" multiple="yes" style="width:550px">		
          					
                                    <cfloop query="qryFRS"> 
                                    <cfoutput>
                                    	<option value="#qryFRS.FRS#">#qryFRS.FRS#</option>
                                    </cfoutput>
                                    </cfloop>			
							
                			</cfselect>
                                       
                    	</div> 
			   		</div>
                </div>
               <!--- ERT only --->   
               
                <cfset tempERT = #findnocase("ST",reporttype)# />  
                <cfset tempAll = #findnocase("All",reporttype)# /> 
                <cfif (#tempERT# gt "0") or (#tempAll# gt "0") >
                            <cfquery name="qrySCC" datasource="#request.dataSource#"> 
      							select scc as MYID, scc ||'-'||scc_level_one ||';'|| scc_level_two||';' ||scc_level_three ||';' || scc_level_four "MYDESC" 
                                from L_SCC 
                                where SCC in (select distinct(SCC) from XML_Parse_geo_info where (SCC is not null) and length(SCC)>=8 and SCC<>'101002ng') order by MYID 
                            </cfquery>         
                                                  
                  <h3 class="accordion-header ERTOnly">SCC (for performance tests only) </h3>
                    <div class="ERTOnly" id="SCC">
                
  
                    <div id="Level2">
                      <label for="level2label">Available SCCs (only SCCs for which reports have been submitted)</label>
                            
                            <select name="SCC" id="scc" multiple="multiple" size="5" style="width:1050px">
                          		 <cfloop query="qrySCC"> 
                            	<cfoutput>
                            	<option value="#qrySCC.MYID#">#qrySCC.MYDESC#</option>
                            	</cfoutput>  
                                </cfloop>
                                </select>
                    </div>
                  </div>                    
          
        <h3 class="accordion-header ERTOnly">Pollutant (for performance tests only)</h3>
                  <div class="ERTOnly">
                    <div style="height:200px">
                      <label for="pollutant">Available Pollutants</label>
                
                 <!---<select id="example-getting-started" name="POLLNAME[]" multiple="multiple">
				   <cfselect id="POLLNAME" name="POLLNAME" width="200" multiple="yes" >	--->	
                 
                 <select title="pollutants" multiple="multiple" id="pollutants" name="POLLNAME" size="5" style="width:450px">
                            <cfloop query="qryPOLLNAMEList"> 
                  <!---       <cfoutput>
                            <option value="#replace(qryPOLLNAMEList.POLLNAME, ",",".","All")#">#qryPOLLNAMEList.POLLNAME#</option>
                            </cfoutput>  --->
                 <cfoutput>
                     <option value="#qryPOLLNAMEList.CASN#">#qryPOLLNAMEList.POLLNAME#</option>
                            </cfoutput> 
                            </cfloop>			
							
                		</select>
                        
                    </div>
                  </div>
                  <cfquery name="qryTestMethod" datasource="#request.datasource#"> 
   				          	select  distinct METHOD_NAME as Methodname
                        from  test_ef_data_csv_sum  where METHOD_NAME is not null and METHOD_NAME !='Mercury'
                        ORDER BY  METHOD_NAME                     
                    </cfquery> 
                  <h3 class="accordion-header ERTOnly">Pollutant Test Method (for performance tests only)</h3>
                  <div class="ERTOnly">
                    <div>
                      <label for="pollutantmethod">Available Test Method</label>
                          <select id="pollutantmethod" name="pollutantmethod" multiple="multiple" size="5" style="width:450px">	
                        		
                                <cfloop query="qryTestMethod"> 
                                <cfoutput>
                                <option value="#qryTestMethod.Methodname#">#qryTestMethod.Methodname#</option>
                                </cfoutput>
                                </cfloop>				                          
                         </select>   
                    
                    </div>
                  </div> 
                  <cfquery name="qryCONTROL_CODE1_DESCRIPTIONList" datasource="#request.datasource#"> 
                       select  distinct upper(trim((CONTROL_DEVICE_1))) as CONTROL_DEVICE, CONTROL_DEVICE_1_NEI_CODE
                        from 
                        test_ef_data_csv_sum  where (trim(CONTROL_DEVICE_1_NEI_CODE) is not null) and trim((CONTROL_DEVICE_1_NEI_CODE))<>'0'
                        ORDER BY
                        upper(trim((CONTROL_DEVICE_1)))
                    </cfquery> 
             
                  <h3 class="accordion-header ERTOnly">Control Device (for performance tests only)</h3>  
                  <div class="ERTOnly">
                    <div>
                      <label for="controldevice">Available Control Devices </label>
                      <select name="controldevice" id="controldevice" multiple="multiple" size="5" style="width:400px">	

          					<cfloop query="qryCONTROL_CODE1_DESCRIPTIONList"> 
                            <cfoutput>
                         <!---   <option value="#qryCONTROL_CODE1_DESCRIPTIONList.CONTROL_DEVICE_1_NEI_CODE#"> --->
                         <option value="#qryCONTROL_CODE1_DESCRIPTIONList.CONTROL_DEVICE#">
                            #qryCONTROL_CODE1_DESCRIPTIONList.CONTROL_DEVICE#</option>
                            </cfoutput>
                            </cfloop>				
												
               		 </select>   
       
                    </div>  
                    
                 <div id="AFS" style="display:none;"><label for="afslabel">
                <a href="##" onClick="newPopup('../fire/view/terms.html##AFSID')"  title="Click for AFS ID Description">AFS ID</a>
                </label>                   
                <cfinput type="text" name="afs" value="" size="30"  maxlength="60">                  
                </div> 
                    
                  </div>
                  </cfif>
                </div><!--- accordion--->
                <div class="buttonrow">   
                	<p class="text-center">
                    <input name="Submit" id="Submit"  type="submit" value="Submit Search" /> 
                    <input name="reset" id="reset"  type="reset" value="Reset" alt="Reset"  />		
                  </p>
                  <p class="expand-collapse-all">
                    <span class="accordion-expand-all"><a href="##">Expand all</a></span>
                    <span class="accordion-collapse-all"><a href="##">Collapse all</a></span>
                  </p>
                </div>
               
                </fieldset>
              </cfform>
   				<div id="CFRValue"></div>  
          <div id="test"></div> 
						</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
<!--- close cfoutput encode tag from line 21  --->
</cfoutput>						
<cfinclude template="assets/footer1.cfm">

