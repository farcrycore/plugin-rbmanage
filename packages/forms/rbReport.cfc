<cfcomponent displayname="RB Reports" hint="UI for reviewing and actioning RB reports" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="report" ftLabel="Select Report" type="string" ftType="list" ftListData="getReports" ftDefault="ReportMissing" />
	
	<cfproperty name="keys" ftLabel="Results" type="string" ftType="list" ftWatch="report" />
	
	<cfproperty name="bundle" ftLabel="Bundle" type="string" ftType="list" ftListData="getLocations" />
	<cfproperty name="locale" ftLabel="Locale" type="string" ftType="list" ftListData="getLocales" />
	<cfproperty name="translated" ftLabel="Mark as Translated" type="boolean" />
	
	
	<cffunction name="getReports" access="public" output="false" returntype="string" hint="Returns the reports that can be selected">
		
		<cfreturn application.rb.getReportList() />
	</cffunction>
	
	<cffunction name="getLocations" access="public" output="false" returntype="query" description="Returns the possible locations">
		
		<cfreturn application.fc.lib.rb.getLocations() />
	</cffunction>
	
	<cffunction name="getLocales" access="public" output="false" returntype="query" hint="Returns the list of supported locales">
		
		<cfreturn application.fc.lib.rb.getLocales(bIncludeBase=true) />
	</cffunction>
	
	<cffunction name="ftEditKeys" access="public" returntype="string" description="This will return a string of formatted HTML text to enable the editing of the property" output="false">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">
		
		<cfset var html = "" />
		<cfset var stCols = application.rb.getReportColumns(report=arguments.stObject.report,format='query') />
		
		<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
		
		<skin:loadJS id="jquery" />
		<skin:loadJS id="jquery-treeTable" basehref="#application.url.webroot#/rbmanage/treeTable/javascripts/" lFiles="jquery.treeTable.js" />
		<skin:loadCSS id="jquery-treeTable" basehref="#application.url.webroot#/rbmanage/treeTable/stylesheets/" lFiles="jquery.treeTable.css" />
		<skin:htmlHead><cfoutput>
			<style type="text/css">
				##tree { width:#stCols.width+16#px; }
					td.icon-value { padding-left:20px; }
					.select-header, .select-value { width:20px; }
					<cfloop query="stCols.columns">
						.#stCols.columns.dataIndex#-header, .#stCols.columns.dataIndex#-value { width:#stCols.columns.width#px; padding-left:2px; }
					</cfloop>
			</style>
		</cfoutput></skin:htmlHead>
		
		<cfsavecontent variable="html"><cfoutput>
			<table id="tree">
				<thead>
					<tr class="ui-widget-header">
						<th class="icon-header"></th>
						<th class="select-header"></th>
						<cfloop query="stCols.columns">
							<th class="#stCols.columns.dataIndex#-header">#stCols.columns.header#</th>
						</cfloop>
					</tr>
				</thead>
				<tbody>#outputResults(stCols=stCols,report=arguments.stObject.report,fieldname=arguments.fieldname)#</tbody>
			</table>
			<script language="javascript">
				$("##tree").treeTable();
				<cfif not structkeyexists(arguments.stMetadata,"ajaxrequest") or not arguments.stMetadata.ajaxrequest>
					// Make visible that a row is clicked
					$("input[name=keys]").live("change",function() {
						var fn = (this.checked ? "addClass" : "removeClass");
						var nodes =  [ $j(this).parents("tr.ui-widget-content")[fn]("checked") ];
						
						while (nodes.length) {
							var nodeset = nodes.shift();console.log(nodeset);
							nodeset[fn]("ui-state-highlight");
							nodeset.each(function(){
								nodes.push($j("tr.child-of-"+this.id).not(".checked"));
							});
						}
					});
				</cfif>
			</script>
		</cfoutput></cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="outputResults" returntype="string" output="false" hint="Recursive function for outputing tree table rows for a report">
		<cfargument name="stCols" type="struct" required="false" hint="The report columns" />
		<cfargument name="report" type="string" required="false" default="" hint="The report required" />
		<cfargument name="group" type="string" required="false" default="" hint="Key group, e.g. webtop.admin" />
		<cfargument name="fieldname" type="string" required="false" default="keys" hint="Fieldname to use for checkboxes" />
		
		<cfset var qData = application.rb.getReport(report=arguments.report,group=arguments.group,format="query") />
		<cfset var result = createObject("java","java.lang.StringBuffer").init() />
		<cfset var childof = "" />
		<cfset var nodetype = "" />
		
		<cfparam name="arguments.stCols" default="#application.rb.getReportColumns(report=arguments.report,format='query')#" />
		
		<cfloop query="qData">
			<cfif len(arguments.group)>
				<cfset childof = "child-of-#rereplace(arguments.group,'[^\w]','-','ALL')#" />
			<cfelse>
				<cfset childof = "" />
			</cfif>
			<cfif qData.haschildren>
				<cfset nodetype = "branch-node" />
			<cfelse>
				<cfset nodetype = "leaf-node" />
			</cfif>
			
			<cfset result.append("<tr id='#rereplace(qData.rbkey,'[^\w]','-','ALL')#' class='ui-widget-content #childof# #nodetype#'>") />
			<cfif not qData.haschildren>
				<cfset result.append("<td class='icon-value'><span class='ui-icon ui-icon-tag'></span></td>") />
			<cfelse>
				<cfset result.append("<td class='icon-value'></td>") />
			</cfif>
			<cfset result.append("<td class='select-value'><input type='checkbox' name='#arguments.fieldname#' value='#qData.rbkey#' /></td>") />
			<cfloop query="arguments.stCols.columns">
				<cfif arguments.stCols.columns.dataIndex eq "value" and len(qData.value) gt 10>
					<cfset result.append("<td class='#arguments.stCols.columns.dataIndex#-value'><span class='value'><a title='#qData.value#'>#left(qData.value,10)#...</a></span></td>") />
				<cfelse>
					<cfset result.append("<td class='#arguments.stCols.columns.dataIndex#-value'><span class='value'>#qData[arguments.stCols.columns.dataIndex][qData.currentrow]#</span></td>") />
				</cfif>
			</cfloop>
			<cfset result.append("</tr>") />
			
			<cfif qData.haschildren>
				<cfset result.append(outputResults(stCols=arguments.stCols,report=arguments.report,group=qData.rbkey,fieldname=arguments.fieldname)) />
			</cfif>
		</cfloop>
		
		<cfreturn result.toString() />
	</cffunction>

</cfcomponent>