<cfsetting requestTimeOut = "9000">
<!--- 
1. check if the checkboxes are defined 
2. Pass docid in a list
3. extract it from BLOB
4. generate random number for a file name
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
<cfset fileid=#RandRange(numberLow, numberHigh, "SHA1PRNG")# />
<!--ERT ZIP-->
<cfset documentId='166082'>

<!--AER PDF-->
<cfset documentId="152783,166082">

<!--- need 0 to hold the value --->
<cfparam name = "documentId" default ="0"> 
<cfparam name = "csvdocumentId" default ="0"> 
           

            <cfif IsDefined("form.doccsv") and (form.doccsv is not "")> 
            	 <cfset documentId = form.doccsv /> 
                <cfset csvdocumentId = form.doccsv /> 
            </cfif> 
              <cfif IsDefined("form.docbulk") and (form.docbulk is not "") > 
                <cfset documentId = form.docbulk /> 
            </cfif> 
            <cfset tocheck=ListToArray(#form.docbulk#)>
            <cfset ids=#ArrayLen(tocheck)#>
         <cfif ids gt "10"> 
           <cfset myTotal =#session.Totalcount#>
           <if myTotal gt ids>  
          <cfset session.docidlist=documentID>
          <cfset session.totalcount=ids>      
          <cflocation url="bulkdownload.cfm" />            
         </cfif>
           <cfoutput></cfoutput>
<!---       <cfdump var="#documentId#" label="bulkdownload" >
             <cfdump var="#csvdocumentId#" label="CSV" >--->
   <cfif Not (IsDefined("form.docbulk")) and Not (IsDefined("form.doccsv"))> 
      	<cfoutput><p>Please go back to the previous page to select a document to download.</p></cfoutput>
       <!---<cflocation url="eSearch.cfm">--->
     <cfabort />
</cfif> 

<cfquery name="qdownload" datasource="#request.dataSource#">
    select data, DOCUMENT_NAME, DOCUMENT_TYPE, REPORT_DOC_TYPE,nvl(d.facility,'not provided') as facility, d.submission_id as submission_id, to_char(b.submission_time,'yyyy-mm-dd') submission_time
   from cdx_submission b, cdx_submission_documents c, XML_PARSE_GEO_INFO d 
   where b.id=c.submission_id and c.submission_id=d.submission_id
    and c.submission_id in (#documentId#) order by REPORT_DOC_TYPE, facility
</cfquery>

	<!---
<cfquery name="qdownloadcsv5" datasource="#request.dataSource#">

    
(select submission_id as Submission_ID, facility as Facility_Name, city as Facility_City, state as Facility_State, county_name as Facility_County, zip_code as Facility_Zip_Code, 
    latitude as Facility_Latitude,longitude as Facility_Longitude,to_char(FRS) as FRS_ID, AFS_NUMBER,  
      location_id as Location_ID, location_name as Location_Name, Duct_Diameter, Is_Location_Controlled, permit_source_name as Permit_Source_Name,permitted_source_id as Permit_Source_ID, 
          air_permit_number as Air_Permit_Number, SCC, NAICS, Process_Description, to_char(ef_value) TEST_RUN_VALUE, 'N/A' AVERAGE_VALUE,(0) Calculated_Average, Test_Run_Number as Test_Run_Number, 
        Pollutant_Name,CAS_Number, NEI_Pollutant_Code, 
          Pollutant_Unit, Measure, Material, Action,
        flag as Detection_Limit_Flag, Flag_Detail, Test_Report_Rating,
        run_date as Test_Run_Date, Test_Purpose, ' ' Purpose_Comment,
        ' ' as Test_Method_Notes, 
        method_name as Test_Method,Testing_Company,Testing_Project_Number, 'V5' as ERT_Version, ERT_Reference as Test_Report_Reference,    
        CONTROL_DEVICE_1_NEI_CODE as control_1,
         CONTROL_DEVICE_2_NEI_CODE as control_2,
        CONTROL_DEVICE_3_NEI_CODE as control_3,
         CONTROL_DEVICE_4_NEI_CODE as control_4,
         CONTROL_DEVICE_5_NEI_CODE as control_5,
             PROCESS_PARAMETER, PROCESS_PARAMETER_RATE, PROCESS_PARAMETER_VALUE,
         ' ' Applicable_Regulation, REG_DESCRIPTION as Regulation_Description, REG_LIMIT_DESC as Regulatory_Limit, ' ' Regulatory_Limit_Unit, Stack_Temperature_F, Stack_Flow_Rate_acfm, Method_Mass_A, Method_Mass_B, Mass_Units, FILTER_TEMPERATURE_1_F, Filter_Temperature_2_F
        ,Emissions_Value_LB_MMBtu_CO2, Emissions_Value_LB_MMBtu_O2
        from TEST_EF_DATA_CSV
        WHERE submission_id in (#csvdocumentId#)
        ) 
      union
 (select submission_id as Submission_ID, facility as Facility_Name, city as Facility_City, state as Facility_State, county_name as Facility_County, zip_code as Facility_Zip_Code, 
	    latitude as Facility_Latitude,longitude as Facility_Longitude,to_char(FRS) as FRS_ID, ' ' as AFS_NUMBER, 
      Location_ID, location_name as Location_Name, ' ' Duct_Diameter, (0) Is_Location_Controlled,
      permit_source_name as Permit_Source_Name,permitted_source_id as Permit_Source_ID, 
       air_permit_number as Air_Permit_Number, SCC, ' ' NAICS, 
      ' ' Process_Description,
       'N/A' TEST_RUN_VALUE, to_char(EF_VALUE, '9.99EEEE') AVERAGE_VALUE,(1) Calculated_Average,' ' as Test_Run_Number,
         Pollutant_Name,' ' CAS_Number, ' ' NEI_Pollutant_Code,
         Pollutant_Unit, Measure, Material, Action,
        flag as Detection_Limit_Flag, ' ' Flag_Detail,' ' as Test_Report_Rating,
        ' ' as Test_Run_Date,  ' ' Test_Purpose, ' ' Purpose_Comment,
        ' ' as Test_Method_Notes, 
        method_name as Test_Method,Testing_Company, Testing_Project_Number, 'V5' as ERT_Version, ERT_Reference as Test_Report_Reference,  
        CONTROL_DEVICE_1_NEI_CODE as control_1,
        CONTROL_DEVICE_2_NEI_CODE as control_2,
        CONTROL_DEVICE_3_NEI_CODE as control_3,
        CONTROL_DEVICE_4_NEI_CODE as control_4,
        CONTROL_DEVICE_5_NEI_CODE as control_5,
         ' '   PROCESS_PARAMETER, ' ' PROCESS_PARAMETER_RATE, ' ' PROCESS_PARAMETER_VALUE,
         ' ' Applicable_Regulation, ' ' Regulation_Description, ' ' Regulatory_Limit, ' ' Regulatory_Limit_Unit, ' ' Stack_Temperature_F, ' ' Stack_Flow_Rate_acfm, ' ' Method_Mass_A, ' ' Method_Mass_B, ' ' Mass_Units, ' ' Filter_Temperature_1_F, ' ' Filter_Temperature_2_F
        ,' ' Emissions_Value_LB_MMBtu_CO2, ' ' Emissions_Value_LB_MMBtu_O2
        from TEST_EF_DATA_CSV_SUM
        WHERE submission_id in (#csvdocumentId#))
       
</cfquery>
--->
	<cfquery name="qdownloadcsv5" datasource="#request.dataSource#">
	select submission_id as Submission_ID, facility as Facility_Name, city as Facility_City, state as Facility_State, county_name as Facility_County, zip_code as Facility_Zip_Code, 
    latitude as Facility_Latitude,longitude as Facility_Longitude, epa_facility_id as FRS_ID, AFS_NUMBER,  
      ' ' as Location_ID, location_name as Location_Name, Duct_Diameter, Is_Location_Controlled, permit_source_name as Permit_Source_Name,permitted_source_id as Permit_Source_ID, 
          air_permit_number as Air_Permit_Number, SCC, NAICS, ' ' as Process_Description, to_char(ef_value) TEST_RUN_VALUE, 'N/A' AVERAGE_VALUE,(0) Calculated_Average, Test_Run_Number as Test_Run_Number, 
        Pollutant_Name,CAS_Number, NEI_Pollutant_Code, 
          Pollutant_Unit, Measure, Material, Action,
        flag as Detection_Limit_Flag, Flag_Detail, Test_Report_Rating,
        run_date as Test_Run_Date, Test_Purpose, ' ' Purpose_Comment,
        ' ' as Test_Method_Notes, 
        method_name as Test_Method,Testing_Company,Project_Number as Testing_Project_Number, 'V5' as ERT_Version, ERT_Reference as Test_Report_Reference,    
        CONTROL_DEVICE_1 as control_1,
         CONTROL_DEVICE_2 as control_2,
        CONTROL_DEVICE_3 as control_3,
         CONTROL_DEVICE_4 as control_4,
         CONTROL_DEVICE_5 as control_5,
             PROCESS_PARAMETER, PROCESS_PARAMETER_RATE, PROCESS_RUN_VALUE as PROCESS_PARAMETER_VALUE,
         ' ' Applicable_Regulation, REG_DESCRIPTION as Regulation_Description, REG_LIMIT as Regulatory_Limit, ' ' Regulatory_Limit_Unit, Stack_Temperature as Stack_Temperature_F, actual_volumetric_flow_rate as Stack_Flow_Rate_acfm, MASS_A as Method_Mass_A, Mass_B as Method_Mass_B, units as Mass_Units, FILTER_TEMPERATURE1 as FILTER_TEMPERATURE_1_F, Filter_Temperature2 as Filter_Temperature_2_F
        ,LB_MM_Btu_CO2 as Emissions_Value_LB_MMBtu_CO2,LB_MM_Btu_O2 as Emissions_Value_LB_MMBtu_O2
  		From ERT_FLAT_ENTITY
		WHERE submission_id in (#csvdocumentId#)
	</cfquery>
<!---<cfdump var="#qdownloadcsv5#">
<cfabort>--->
<cfquery name="qdownloadcsv4" datasource="#request.dataSource#">
  (Select cast(d.submission_id as number(19)) submission_id,f.facility as Facility_Name, f.city as Facility_City, f.state as Facility_State, d.county as Facility_County, d.zip as Facility_Zip_Code, 
   '0' as Facility_Latitude,'0' as Facility_Longitude, f.FRS as FRS_ID, ' ' as AFS_NUMBER, 
   (0) as location_id,' ' as location_name, ' ' Duct_Diameter, (0) Is_Location_Controlled, 
   f.permitsourcename as Permit_Source_Name, 
   f.permitsourceid as Permit_Source_ID, 'N/A' as Air_Permit_Number,f.scc as SCC,' ' NAICS, ' ' Process_Description,
   'N/A' TEST_RUN_VALUE,f.factor as AVERAGE_VALUE, (1) Calculated_Average,'N/A' as Test_Run_Number, 
   f.pollname as pollutant_name,' ' CAS_Number, ' ' NEI_Pollutant_Code,
    f.UNIT as pollutant_unit, f.Measure, f.MATERIAL, f.Action,'N/A' as Detection_Limit_Flag,' ' Flag_Detail, 'N/A' as Test_Report_Rating, 
    f.run_x0020_date as Test_Run_Date,  ' ' Test_Purpose, ' ' Purpose_Comment,
    f.methodnotes as Test_Method_Notes,f.methodname as Test_Method,f.testcompany as Testing_Company, 
    'N/A' as Testing_Project_Number, 'V4' as ERT_Version, f.reference as Test_Report_Reference,
    CONTROL_CODE1_DESCRIPTION as Control_1,
    CONTROL_CODE2_DESCRIPTION as control_2,
    CONTROL_CODE3_DESCRIPTION as control_3,
    CONTROL_CODE4_DESCRIPTION as control_4,
    CONTROL_CODE5_DESCRIPTION as control_5,
    ' ' PROCESS_PARAMETER, ' ' PROCESS_PARAMETER_RATE, ' ' PROCESS_PARAMETER_VALUE,
    ' ' Applicable_Regulation, ' ' Regulation_Description, ' ' Regulatory_Limit, ' ' Regulatory_Limit_Unit, ' ' Stack_Temperature_F, ' ' Stack_Flow_Rate_acfm, ' ' Method_Mass_A, ' ' Method_Mass_B, ' ' Mass_Units, ' ' Filter_Temperature_1_F, ' ' Filter_Temperature_2_F,' ' Emissions_Value_LB_MMBtu_CO2, ' ' Emissions_Value_LB_MMBtu_O2
    from  xml_parse_geo_info d, xml_parse f where d.submission_doc_id=f.submission_doc_id
    and d.submission_id in (#csvdocumentId#))
</cfquery>

<!---
<cfquery name="qdownloadcsv" dbtype="query">
	select * from qdownloadcsv5
    union
    select * from qdownloadcsv4
    order by ERT_Version, submission_id, location_id,  pollutant_name, Test_Method, Calculated_Average 
</cfquery>

--->
<cfquery name="qdownloadcsv" dbtype="query">
	select * from qdownloadcsv5
    order by ERT_Version, submission_id, location_id,  pollutant_name, Test_Method, Calculated_Average 
</cfquery>
   <h1 class="page-title">WebFIRE</h1>
      <div class="panel-pane pane-node-content">
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">
            <h2>WebFIRE Bulk Zip File Download</h2>
            <div>
<p> Click File Download Link below to download the selected files in one zip. Since the size of some combined zip file may be very large, it may take a while for you to complete the download process.</p> 
             </div>

    
<cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath())>
<cfset delDirectory="#currentDirectory#download" >
<!---
<cfoutput>Download location: #currentDirectory#</cfoutput> --->


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
<ul>

<cfoutput query="qdownload" group="REPORT_DOC_TYPE" >
	<li>#REPORT_DOC_TYPE#</li>	
  
        <ul>
        <cfset rptDirectory= "#currentDirectory#\download\#fileId#\#REPORT_DOC_TYPE#">
           
     	<cfoutput group="facility" >	
        	<li>#facility#</li>
            	<cfoutput>
            		<ul>
                		<cfset myname=#qdownload.DOCUMENT_NAME#>
                        <cfset myNameNew=Replace(myname, " ", "", "All")>
                        <cfset myNameNew=Replace(myNameNew, ",", "", "All")>
                        <cfset myNameNew="#qdownload.submission_time#-#submission_id#-#myNameNew#" >
                        
                        <cfset myCsvName=replace(myNameNew,".zip",".csv","all") >
                        <cfset myCsvName=replace(myNameNew,".xml",".csv","all") >
                        <cfset myCsvName=replace(myNameNew,".pdf",".csv","all") >
                        
								<!--- download to submission_id level --->
                            <cfset tmpDirectory= "#currentDirectory#\download\#fileId#\#REPORT_DOC_TYPE#\#Facility#"> 
                              <cftry> 
                                 <cfif DirectoryExists(tmpDirectory)>  
									<!--- do nothing --->
								<cfelse>
                                	
									<cfset DirectoryCreate(tmpDirectory)> 
                               </cfif>
                               	        <!---<cfoutput><b>Debug: Downloading File Directory #tmpDirectory# successfully created.</b></cfoutput>--->
                                 <cfcatch>
									 <cfmail to="hui.zhou@erg.com" from="webfire@epa.gov"  subject="An Error Has Occurred" type="html">
									  Error Message: #cfcatch.message#<br>
									  Error Detail: #cfcatch.detail#<br>
									  Error Location: #GetBaseTemplatePath()#<br>
									 </cfmail>
									 <cfoutput>
                                     <b>Error Message:</b>#cfcatch.message#<br/> 
                                     <b>Error Detail:</b>#cfcatch.Detail#</cfoutput> 
									  <p>We're sorry, an error has occurred and our developers have been notified.</p>
                                 </cfcatch> 
                             </cftry> 
                            <cfset myGeneratedFilesFolder="#tmpDirectory#\#myNameNew#">
                            
                                
                           <cfscript> 
                                    FileWrite("#myGeneratedFilesFolder#", "#qdownload.data#"); 
                            </cfscript>
                             <cfset CsvFileDownloadPath = "#tmpDirectory#\#submission_time#-#submission_id#.csv" />
                             <cfset xlsFileDownloadPath= "#tmpDirectory#\#submission_time#-#submission_id#.xls" />
                            
                          <!---  <li>Document File: #myNamenew#</li>--->
                     
               		 </ul>    
                   	 </cfoutput>    
                   
    </cfoutput>
		</ul>
        <!--- at report level with recurse --->
        			<cfset tBegin = GetTickCount()>
        		<cfset rptFileDir = #rptDirectory# /> 
                <cfset targetFileDir = #rptDirectory# /> 
                <cfset todayDate = Now()> 
                <cfset filedate="#DateFormat(todayDate, "mm-dd-yyyy")#">
                <cfset zipfile="WebFIRE-BULK-DATA-#qdownload.REPORT_DOC_TYPE#-#filedate#" />
                <cfset rptfinalZipFile="#targetFileDir#/#zipfile#.zip" />
     <cftry>           
           <!--- create CSV-v5 at the Report Type level  <cfif #qdownloadcsv5.recordcount# gt 0 >--->
           <cfif (#qdownloadcsv.recordcount# gt 0) and (#REPORT_DOC_TYPE# eq 'ST') >
             <cfset CsvFileDownloadPath = "#targetFileDir#\#zipfile#.csv" />
      		
        
                  <cffile action="write" file="#CsvFileDownloadPath#" output="#QueryToCSV(qdownloadcsv, 
            'Submission_ID,Facility_Name,Facility_City,Facility_State,Facility_County, Facility_Zip_Code,Facility_Latitude,Facility_Longitude,FRS_ID,AFS_NUMBER,Location_ID,Location_Name,Is_Location_Controlled,Duct_Diameter,Permit_Source_Name,Permit_Source_ID,Air_Permit_Number,SCC,NAICS,Process_Description,TEST_RUN_VALUE,AVERAGE_VALUE,Calculated_Average,Test_Run_Number,Pollutant_Name,CAS_Number, NEI_Pollutant_Code,POLLUTANT_UNIT,Measure,Material,Action,Detection_Limit_Flag,Test_Report_Rating,Test_Run_Date,Test_Method_Notes,Test_Method,Testing_Company,Testing_Project_Number,ERT_Version,Test_Report_Reference,Control_1,Control_2,Control_3,Control_4,Control_5, PROCESS_PARAMETER,PROCESS_PARAMETER_RATE,PROCESS_PARAMETER_VALUE,Regulation_Description, Regulatory_Limit, Stack_Temperature_F, Stack_Flow_Rate_acfm, Method_Mass_A, Method_Mass_B, Mass_Units, FILTER_TEMPERATURE_1_F, Filter_Temperature_2_F
                ,Emissions_Value_LB_MMBtu_CO2, Emissions_Value_LB_MMBtu_O2')#">   
               
                 <li><p><a href="download/#fileId#/#REPORT_DOC_TYPE#/#zipfile#.csv">CSV File: #zipfile#.csv</a></p></li>
           </cfif>     
        <!--- end v5--->
  
             <cfif IsDefined("form.docbulk") and (form.docbulk is not "") > 
                      <cfzip action="zip" file="#rptfinalZipFile#" storepath="yes"
                                overwrite="true">
                                 <cfzipparam source="#rptfiledir#">
                                </cfzip>          
                                
            <li><p><a href="download/#fileId#/#REPORT_DOC_TYPE#/#zipfile#.zip">Zip File: #REPORT_DOC_TYPE# Bulk File Download Link</a></p></li>
            </cfif>
   <cfcatch> 
           <b>Error Message:</b><cfoutput>#cfcatch.message#</cfoutput><br/> 
           <b>Error Detail:</b><cfoutput>#cfcatch.Detail#</cfoutput> 
    </cfcatch> 
 </cftry> 
 						<cfset tEnd = GetTickCount()>
						<cfset scriptTime = (tEnd - tBegin)>  
               <!---     <p>  Hui is checking the Script Run Time: #scriptTime# seconds, #qdownloadcsv.recordcount# records are processed.</p> --->
</cfoutput>
</ul>


					</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
 </div> <!-- results1 -->       
<cfinclude template="assets/footer1.cfm">

<!--- common use CSV conversion 
moved to comp/commonfunctions included on the top--->
