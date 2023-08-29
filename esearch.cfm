<cfinclude template="assets/header1.cfm">
<!--googleon: all-->
      <h1 class="page-title">WebFIRE</h1>
      <div class="panel-pane pane-node-content">
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">
            <h2>WebFIRE Report Search and Retrieval</h2>
            <div>
			<!---
					<cfif #dateCompare('06/30/2020', '07/03/2020', 'd')# lte "3" >
						<p><strong>The WebFIRE Report Search feature is undergoing maintenance Wednesday, July 1, 2020 thru COB Thursday, July 2, 2020 and will be unavailable during this time.</strong></p>
					</cfif> --->
            	<p>WebFIRE contains the following types of reports that are submitted to the EPA's Compliance and Emissions Data Reporting Interface (<a href="https://www3.epa.gov/ttn/chief/cedri/index.html" title="CEDRI" target="_blank">CEDRI</a>):</p>
                <ul>
                  <li><a href="##" onClick="newPopup('../fire/view/glossary.html##AER')" title="Click here for description of Notification of Status Reports">Air Emissions Reports</a> - Air emissions reports (AERs) for an applicable regulation (e.g., compliance summary and excess emissions reports).</li>
                  <li><a href="##" onClick="newPopup('../fire/view/glossary.html##pt')" title="Click here for description of Performance Reports">Performance Test Reports</a> - Emissions source test data and performance evaluations/relative accuracy test audits (RATA) submitted by facilities.</li>
                  <li><a href="##" onClick="newPopup('../fire/view/glossary.html##nocr')" title="Click here for description of Notification of Status Reports">Notification of reports</a> - Notifications of compliance status (NOCS) submitted by facilities certifying that initial compliance with an applicable regulation was achieved.</li>
                 </ul>
                 <p>To begin your search, specify the report type(s) of interest below:</p>
             </div>
            <form name="searchform" id="searchform" action="https://appdev4.erg.com/webfireAnna23/reports/esearch2.cfm" class="form-basic"  method="post">
              <fieldset>
             
                  <div>
                      <div>
                        <label for="reporttype">Report Type</label>  
                        <select name="reporttype" multiple="multiple" id="reporttype" class="notification">
                          <option value="All">All</option>
                          <option value="ST">Performance Test Reports</option>
                          <option value="AER">Air Emissions Reports</option>
                          <option value="NOCS">Notification of Compliance Status Reports</option>
                        </select>
                        <p>(Control-Click for multiple selections)</p>
                     </div> 
                  </div>
                  
              

                <div class="buttonrow">   
                	<p class="text-left">
                    <input name="Submit" id="Submit"  type="submit" value="Submit Search" /> 
                    <input name="reset" id="reset"  type="reset" value="Reset" alt="Reset"  />
                  </p>
                 
                </div>
                </fieldset>
              </form>
<!---              <div id="test"></div>--->
			</div><!--/.node-->
          </div><!--/.pane-content-->
        </div><!--/.panel-pane-->
      <div id="block-epa-og-footer" class="block block-epa-og">
 <!---       <p>{FOOTER CONTENT}</p>--->
      </div>
<cfinclude template="assets/footer1.cfm">

</body>
</html>
