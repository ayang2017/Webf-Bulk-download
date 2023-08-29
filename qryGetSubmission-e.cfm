	<!--- special treat for pollutant name with comma in the value 
	1.Replace "," to "." in the selection box from previous page and pass here as list
	2.Add "'" to format the string
	3.Replace "." back to "," for database comparison
	4.In statement needs the "preserve the single quote function
	--->
  
        <cfparam name="form.reporttype" default="All">
           
        <cfparam name="form.startdate" default="" > <!--- I've added default data for testing --->
        <cfparam name="form.enddate" default="" >
        <cfparam name="form.state" default="AA" > <!--- AA value is used in the query below --->
        <cfparam name="form.city" default="All" >
        <cfparam name="form.county" default="" >
        <cfparam name="form.zip" default="" >
        <cfparam name="form.facility" default="" >
        <cfparam name="form.frs" default="" >
        <cfparam name="form.afs" default="All" >
        <cfparam name="form.scc" default="" >
        <cfparam name="form.CFRpart" default="" >
        <cfparam name="form.CFRSubpart" default="" >
        <cfparam name="form.submit" default="" >
        <!--- new fields--->
        <cfparam name="form.POLLNAME" default="" >
        <cfparam name="form.controldevice" default="" >
        <cfparam name="form.organization" default="" >
		<cfparam name="myPOLLNAMEstr" default="">
        <cfparam name="form.pollutantmethod" default="" >
        <cfparam name="mypollutantmethod" default="">
        <cfparam name="myControl" default="">
        <cfparam name="newPOLLNAME" default="">

 	 <cfif IsDefined("form.POLLNAME") and form.POLLNAME neq "">	
		 <!--- hui updated replace special character in pollutant '=|' DB SQL side needs the same 8/8/20--->
		 <cfset myPOLLNAME = #replace(UCASE(form.POLLNAME),"'","|","All")# > 
		 <cfset myPOLLNAME = #ListQualify(myPOLLNAME,"'")# > 
         <cfset myPOLLNAMEstr=#replace(myPOLLNAME,".",",","all")#> 
         <cfset newPOLLNAME=trim(EncodeForHTML(form.POLLNAME))>         
     </cfif>
     
     <cfif IsDefined("form.pollutantmethod") and form.pollutantmethod neq "">
     			<cfset mypollutantmethod = #ListQualify(UCASE(form.pollutantmethod),"'")# > 
     </cfif>           
      <cfif IsDefined("form.controldevice") and form.controldevice neq "">
       	<cfset myControl = #ListQualify(form.controldevice,"'")# >         
      </cfif>     
        
         	<cfset startdate = EncodeForHTML(form.startdate)>
            <cfset startdate = DecodeForHTML(form.startdate)>
            <cfset startdate = trim(startdate)>
            
            <cfset enddate = EncodeForHTML(form.enddate)>
            <cfset enddate = DecodeForHTML(form.enddate)>
            <cfset enddate = trim(enddate)>
            
            
            <cfset state = trim(EncodeForHTML(form.state))>
            <cfset county = trim(EncodeForHTML(form.county))>
			<cfset city = trim(EncodeForHTML(form.city))>
            <cfset zip = trim(EncodeForHTML(form.zip))>
            <cfset facility = trim(EncodeForHTML(form.facility))>
            <cfset frs = trim(EncodeForHTML(form.frs))>
            <cfset afs = trim(EncodeForHTML(form.afs))>
            <cfset scc = trim(EncodeForHTML(form.scc))>
            <cfset CFRpart = trim(EncodeForHTML(form.CFRpart))>
            <cfset CFRSubpart = trim(EncodeForHTML(form.CFRSubpart))>
			<cfset reporttype=trim(EncodeForHTML(form.reporttype))>
       		<cfset POLLNAME=trim(EncodeForHTML(myPOLLNAMEstr))> 
     
            <cfset controldevice=trim(EncodeForHTML(myControl))>
      		<cfset organization=trim(EncodeForHTML(form.organization))>
           	<cfset pollutantmethod=trim(EncodeForHTML(mypollutantmethod))>
            <cfset Mytestmethod = trim(EncodeForHTML(form.pollutantmethod))>

		<cfif (form.submit) neq "" >    <!--- post action from previous page reset the previous stored values --->     
                <cflock scope="session" type="exclusive" timeout="10" >
                    <cfset session.startdate = startdate />
                    <cfset session.enddate = enddate />
                    <cfset session.state= state />
                    <cfset session.county = county />
                    <cfset session.city = city />
                    <cfset session.zip = zip />
                    <cfset session.facility= facility />
                    <cfset session.frs= frs>  
                    <cfset session.afs= afs>
                    <cfset session.scc= scc> 
                    <cfset session.CFRpart= CFRpart>
                    <cfset session.CFRSubpart= CFRSubpart /> 
  <!--- no longer needed 5/10/21 - set the session in the esearch2.cfm 
                    <cfset session.reporttype=reporttype />  --->
                    <cfset session.facility= facility />
                    <cfset session.organization= organization />
                    <cfset session.POLLNAME= newPOLLNAME   />
         <!---           <cfset session.POLLNAME= POLLNAME /> 
                    <cfset session.controldevice= controldevice /> --->
                    <cfset session.controldevice= trim(EncodeForHTML(form.controldevice)) />
                    <cfset session.Mytestmethod= Mytestmethod />
         <!---           <cfset session.pollutantmethod= pollutantmethod />  --->
                   
                </cflock>      
        </cfif>
     
			<cfif (form.submit) eq "" >
	            	<cfif not IsDefined("session.startdate") >
                        <!--- send back to Search page --->
                        <cflocation url="eSearch.cfm">
                    </cfif>    
            </cfif>

        <!--- self-post use the session values plus the starting rows value next 500 --->
        
<!---<cfdump var="#session#">--->

<!--- 
hui - added the cache to improve the performance, 11/12/2015 
Anna- modified on 4/25/2019   TEST_EF_DATA_CSV_SUM e   
hui - updated on 5/22/2019 for NOCS and AER report type
--->
<!--- hui debug
<cftry>
--->
<cfquery name="qryGetERTSubmission" datasource="#request.dataSource#" cachedwithin="#createTimeSpan(0,0,15,0)#" timeout="6000" >
	Select distinct
            d.submission_id, c.ID, c.DOCUMENT_NAME, c.DOCUMENT_SIZE, c.DOCUMENT_TYPE, b.submission_time, a.org_name as org_name, nvl(d.facility,'not provided') as facility, Report_Doc_Type, nvl(d.city, 'not provided') as city, nvl(Upper(d.state),'not provided') as state, nvl(trim(d.county),'not provided') as county,   nvl(c.Report_doc_sub_type, 'Not Applicable') as Report_doc_sub_type, e.POLLUTANT_NAME as POLLNAME5, 
regexp_replace(e.CONTROL_DEVICE_1 ||',' || e.CONTROL_DEVICE_2 || ','|| e.CONTROL_DEVICE_3 ||',' || e.CONTROL_DEVICE_4 ||',' || trim(e.CONTROL_DEVICE_5),',+(,|$)','\1') as controlv5            
            ,COUNT(*) OVER() AS total_count
                from
                cdx_submitter a, cdx_submission b, cdx_submission_documents c, xml_parse_geo_info d left outer join Ert_flat_entity e  on d.submission_id=e.submission_id
                where a.id=b.submitter_id and b.id=c.submission_id
                and c.submission_id=d.submission_id      
                and c.attachment = 0                 
                and upper(c.document_type) in ('PDF', 'ZIP','HTML')
                <cfif (session.startdate) neq "">
                 and b.submission_time >= <cfqueryparam value= "#session.startdate#" cfsqltype="cf_sql_date">      
                </cfif>                
                <cfif #session.enddate# neq "">
                   <cfset myend=#session.enddate#>
                   <cfset myend=trim(myend) & " 23:59:59">
                    and b.submission_time <=  <cfqueryparam value= "#myend#" cfsqltype="cf_sql_TIMESTAMP">    
                </cfif>  
                <cfif #session.state# neq "">
                    <cfset mystate=#session.state#>  
                    <cfset mystate=ReplaceNoCase(mystate,"AA","","all")>  
                    <cfif  #mystate# neq "" >     
                    	and Upper(d.state) in (<cfqueryparam value= "#mystate#" cfsqltype="cf_sql_varchar" list="yes">) 
                    </cfif>
                </cfif>                  
               <cfif #session.county# neq "">
                    <cfset mycounty=#session.county#>          
                    and Upper(d.county) in  (<cfqueryparam value= "#mycounty#" cfsqltype="cf_sql_varchar" list="yes">) 
                </cfif>                 
                <cfif #session.city# neq "">
                    <cfset mycity='#session.city#'>          
                    and Upper(d.city) =  Upper(<cfqueryparam value= "#mycity#" cfsqltype="cf_sql_varchar">)   
                </cfif>  
                 <cfif #session.zip# neq "">
                    <cfset myzip='#session.zip#'>          
                    and Upper(d.zip) =  Upper(<cfqueryparam value= "#myzip#" cfsqltype="cf_sql_varchar">)   
                </cfif> 
                 <cfif #session.organization# neq "">
                    <cfset myorganization=#session.organization#>          
                    and Upper(a.org_name) like concat(concat('%',  Upper(<cfqueryparam value= "#myorganization#" cfsqltype="cf_sql_varchar">)), '%') 
        		 </cfif>
                 <cfif #session.facility# neq "">
                    <cfset myfacility=#session.facility#>          
                    and Upper(d.facility) like concat(concat('%',  Upper(<cfqueryparam value= "#myfacility#" cfsqltype="cf_sql_varchar">)), '%') 
        		 </cfif>
                <cfif #session.frs# neq "">
                    <!---<cfset myfrs=replace(#session.frs#,"-","","All")> --->
                    <cfset myfrs=#session.frs# >         
                    and Upper(d.frs) in (#ListQualify(myfrs,"'")#) 
                </cfif>
                <cfif (#session.CFRpart# neq "") and (#session.CFRpart# neq "All") >
                	<cfset myPartcode=#session.CFRpart#> 
                    and d.partcode  in  (<cfqueryparam value= "#myPartcode#" cfsqltype="cf_sql_varchar" list="yes">) 
                </cfif> 
                <cfif (#session.CFRSubpart# neq "") and (#session.CFRSubpart# neq "All")>
                	<cfset myCFRSubpart=#session.CFRSubpart#>    
                    and d.subpartcode   in  (<cfqueryparam value= "#myCFRSubpart#" cfsqltype="cf_sql_varchar" list="yes">) 
                 </cfif>
    <!---            <cfif #session.reporttype# neq "">
				   <cfif findnocase("All",#session.reporttype#) eq 0>
                   <cfset myreport_doc_type=#session.reporttype# >
                    and c.Report_doc_type in (<cfqueryparam value= "#myreport_doc_type#" cfsqltype="cf_sql_varchar" list="yes">)   
                    </cfif>       
                </cfif> --->
        <cfif #session.scc# neq "">
                    <cfset myscc=replace(#session.scc#,"-","","All")>            
                    and Upper(d.scc) in (#ListQualify(scc,"'")#)
                </cfif>
                <cfif IsDefined("form.POLLNAME") and form.POLLNAME neq "">	
                  	<!---set string value needs to be out of SQL statement for whatever reasons, put it at the top hz 3/28/2016, 8/9/20 updated '|'--->
                     and upper(Replace(e.POLLUTANT_NAME,'''','|')) in (#preserveSingleQuotes(myPOLLNAMEstr)#) 
				</cfif>                
                <cfif IsDefined("form.pollutantmethod") and form.pollutantmethod neq "">	
                  	<!---set string value needs to be out of SQL statement for whatever reasons, put it at the top hz 3/28/2016--->
                     and upper(e.Method_name) in (#preserveSingleQuotes(mypollutantmethod)#)
				</cfif>                
                <cfif IsDefined("form.controldevice") and form.controldevice neq "">	
   				 and ((e.CONTROL_DEVICE_1_NEI_CODE in (#preserveSingleQuotes(mycontrol)#))
                      or  (e.CONTROL_DEVICE_2_NEI_CODE in (#preserveSingleQuotes(myControl)#))
                      or  (e.CONTROL_DEVICE_3_NEI_CODE in (#preserveSingleQuotes(myControl)#))
                      or  (e.CONTROL_DEVICE_4_NEI_CODE in (#preserveSingleQuotes(myControl)#))
                      or  (e.CONTROL_DEVICE_5_NEI_CODE in (#preserveSingleQuotes(myControl)#))
                      )
	   </cfif>
        order by org_name 
</cfquery>
<!--- Anna work on SQL insert --->

<cfquery name="qryInsertSQL" datasource="#request.dataSource#" cachedwithin="#createTimeSpan(0,0,15,0)#" timeout="6000" result="r">
  Select distinct d.submission_id, c.ID, c.DOCUMENT_NAME, c.DOCUMENT_SIZE, c.DOCUMENT_TYPE, b.submission_time, a.org_name as org_name, nvl(d.facility,'not provided') as facility, 
  Report_Doc_Type, nvl(d.city, 'not provided') as city, nvl(Upper(d.state),'not provided') as state, nvl(trim(d.county),'not provided') as county, nvl(c.Report_doc_sub_type, 'Not Applicable') 
  as Report_doc_sub_type, e.POLLUTANT_NAME as POLLNAME5, regexp_replace(e.CONTROL_DEVICE_1||','||e.CONTROL_DEVICE_2||','||e.CONTROL_DEVICE_3||','||e.CONTROL_DEVICE_4 ||','||trim(e.CONTROL_DEVICE_5),',+(,|$)','\1') 
  as controlv5, COUNT(*) OVER() AS total_count from cdx_submitter a, cdx_submission b, cdx_submission_documents c, xml_parse_geo_info d left outer join Ert_flat_entity e  on d.submission_id=e.submission_id
  where a.id=b.submitter_id and b.id=c.submission_id and c.submission_id=d.submission_id and c.attachment = 0 and upper(c.document_type) in ('PDF', 'ZIP','HTML')
<cfif (session.startdate) neq ""> and b.submission_time >= to_date('#session.startdate#', 'mm/dd/yyyy')</cfif>                
<cfif #session.enddate# neq ""><cfset myend=#session.enddate#><cfset myend=trim(myend) & " 23:59:59">
       and b.submission_time <= to_date('#myend#', 'mm/dd/yyyy HH24:MI:SS')</cfif>  
<cfif #session.state# neq ""><cfset mystate=#session.state#><cfset mystate=ReplaceNoCase(mystate,"AA","","all")>  
    <cfif  #mystate# neq "" >and Upper(d.state) in (#ListQualify(mystate,"'")#)  </cfif></cfif>                  
<cfif #session.county# neq ""><cfset mycounty=#session.county#>          
      and Upper(d.county) in (#ListQualify(mycounty,"'")#) </cfif>                 
<cfif #session.city# neq ""><cfset mycity='#session.city#'>and Upper(d.city) = Upper('#mycity#'>)</cfif>  
<cfif #session.zip# neq ""><cfset myzip='#session.zip#'>and d.zip = '#myzip#' </cfif> 
<cfif #session.organization# neq ""><cfset myorganization=#session.organization#>          
       and Upper(a.org_name) like concat(concat('%',  Upper('#myorganization#')), '%') </cfif>
<cfif #session.facility# neq ""><cfset myfacility=#session.facility#>          
       and Upper(d.facility) like concat(concat('%',  Upper('#myfacility#')), '%') </cfif>
<cfif (#session.frs# neq "")  and (#session.frs# neq "All") > and Upper(d.frs) in (#ListQualify(myfrs,"'")#) </cfif>
<cfif (#session.CFRpart# neq "") and (#session.CFRpart# neq "All") >           	
                    and d.partcode  in  (#ListQualify(session.CFRpart,"'")#) </cfif> 
<cfif (#session.CFRSubpart# neq "") and (#session.CFRSubpart# neq "All")>and d.subpartcode in (#ListQualify(session.CFRSubpart,"'")#) </cfif>
 <!---  <cfif #session.reporttype# neq ""> <cfif findnocase("All",#session.reporttype#) eq 0>
    <cfset myreport_doc_type=#session.reporttype# >and c.Report_doc_type in (<cfqueryparam value= "#myreport_doc_type#" cfsqltype="cf_sql_varchar" list="yes">)   
       </cfif>   </cfif> --->
<cfif #session.scc# neq ""> <cfset myscc=replace(#session.scc#,"-","","All")>            
                    and Upper(d.scc) in (#ListQualify(scc,"'")#)  </cfif>
<cfif IsDefined("form.POLLNAME") and form.POLLNAME neq ""> and cas_number in (#preserveSingleQuotes(myPOLLNAMEstr)#)  </cfif>                
<cfif IsDefined("form.pollutantmethod") and form.pollutantmethod neq "">and upper(e.Method_name) in (#preserveSingleQuotes(mypollutantmethod)#)	</cfif>                
<cfif IsDefined("form.controldevice") and form.controldevice neq "">	
   				  and ((e.CONTROL_DEVICE_1 in (#preserveSingleQuotes(mycontrol)#))
                      or  (e.CONTROL_DEVICE_2 in (#preserveSingleQuotes(myControl)#))
                      or  (e.CONTROL_DEVICE_3 in (#preserveSingleQuotes(myControl)#))
                      or  (e.CONTROL_DEVICE_4 in (#preserveSingleQuotes(myControl)#))
                      or  (e.CONTROL_DEVICE_5 in (#preserveSingleQuotes(myControl)#)))
	   </cfif>
</cfquery>
  <cfset MySearchSQL="">
  <cfset myList="NA">
<!--- file size in MB --->
   <cfquery name="qDocsize" dbtype="query">
       select sum(document_size/1000000) as docsizesum from qryInsertSQL
   </cfquery>    
   <!---need use submission_id not ID 
   select distinct id as docids from qryInsertSQL---> 
   <cfquery name="qDocIDs" dbtype="query">
     select distinct submission_id as docids from qryInsertSQL      
   </cfquery>
    
    <cfloop  query="qDocIDs">
       <cfset myList = ValueList(qDocIDs.docids,",")>
    </cfloop>
    
 <!---    <cfoutput> List #myList# </cfoutput><cfabort> --->
    <cfset MySearchSQL="">
        <cfset MySearchSQL = #r.SQL#>
        <cfset NewUUID = #right(CreateUUID(), 15)# />
                    <cfset session.NewUUID= #NewUUID#/>
                    <cfset session.MySearchSQL= #MySearchSQL#/>
                    <cfset session.Filesizesum= #qDocsize.docsizesum# />
                    <cfset session.docidlist= #myList#/>
       <cfset Newcount=0 >
       <cfif #qryInsertSQL.total_count# neq ""> <cfset Newcount = #qryInsertSQL.total_count# > </cfif>          
           <cfset session.totalcount = #Newcount# > 
            <cfset session.origcount = #Newcount# > 
          
  <!--- <cfoutput>SQL: #session.docidlist#</cfoutput>  
 <cfset Mywhere = #r.SQL#>
  <cfdump var="#qryInsertSQL#"><br>
  <cfoutput>The Insert CMD #Mywhere# </cfoutput>
  <cfabort>  --->
<!---	<cfdump var="#qryGetERTSubmission#">	--->			   
<!--- hui debug
<cfdump var="#qryGetERTSubmission#">
<cfcatch type="Database">

	<cfoutput>
		#cfcatch.Message# <br />
		#cfcatch.Detail#
		#cfcatch.NativeErrorCode#
	</cfoutput>
</cfcatch>
</cftry>
<cfabort>
end debug group--->


<cfquery name="qryGetERTSubmissionByReportTypes" dbtype="query" >
Select Report_Doc_Type, count(*) as mycount
from qryGetERTSubmission group by Report_Doc_Type
</cfquery>

<!---
<cfdump var="#qryGetERTSubmissionByReportTypes#">

<cfabort>--->
