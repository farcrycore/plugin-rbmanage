<cfsetting enablecfoutputonly="true" requesttimeout="600" />

<cfparam name="url.report" default="missing">

<cfset stCols = application.rb.getReportColumns(report=url.report,format='query') />

<cfcontent type="text/html" variable="#ToBinary( ToBase64(outputResults(report=url.report)) )#" reset="Yes">

<cffunction name="outputResults" returntype="string" output="false" hint="Recursive function for outputing tree table rows for a report">
	<cfargument name="report" type="string" required="false" default="" hint="The report required" />
	<cfargument name="group" type="string" required="false" default="" hint="Key group, e.g. webtop.admin" />
	
	<cfset var qData = application.rb.getReport(report=arguments.report,group=arguments.group,format="query") />
	<cfset var result = createObject("java","java.lang.StringBuffer").init() />
	<cfset var childof = "" />
	<cfset var nodetype = "" />
	
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
		<cfset result.append("<td class='select-value'><input type='checkbox' name='keys' value='#qData.rbkey#' /></td>") />
		<cfloop query="stCols.columns">
			<cfif stCols.columns.dataIndex eq "value" and len(qData.value) gt 10>
				<cfset result.append("<td class='#stCols.columns.dataIndex#-value'><span class='value'><a title='#qData.value#'>#left(qData.value,10)#...</a></span></td>") />
			<cfelse>
				<cfset result.append("<td class='#stCols.columns.dataIndex#-value'><span class='value'>#qData[stCols.columns.dataIndex][qData.currentrow]#</span></td>") />
			</cfif>
		</cfloop>
		<cfset result.append("</tr>") />
		
		<cfif qData.haschildren>
			<cfset result.append(outputResults(report=arguments.report,group=qData.rbkey)) />
		</cfif>
	</cfloop>
	
	<cfreturn result.toString() />
</cffunction>

<cfsetting enablecfoutputonly="false" />