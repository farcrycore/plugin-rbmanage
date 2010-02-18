<cfsetting enablecfoutputonly="true" requesttimeout="1000" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<admin:header />

<admin:resource key="rbmanage.headings.reports@text"><cfoutput><h1>Reports</h1></cfoutput></admin:resource>

<ft:processform action="Update Bundle">
	<ft:processformobjects typename="rbReport">
		<cfset updates = application.rb.setKeys(stProperties.bundle,stProperties.locale,application.rb.getKeys(stProperties.report,stProperties.keys),stProperties.translated) />
		
		<cfset aVars = arraynew(1) />
		<cfset aVars[1] = listlen(updates.added) />
		<cfset aVars[2] = listlen(updates.updated) />
		<cfset aVars[3] = listlen(updates.deleted) />
		<admin:resource key="rbmanage.messages.bundleupdateresult@text" variables="#aVars#"><cfoutput>
			<p class="success">
				Keys added: {1}<br/>
				Keys updates: {2} (when updating a base resource, locale resources are marked as NOT translated)<br/>
				Keys deleted: {3}<br/>
				NOTE: Resource bundle changes have NOT been saved to file
			</p>
		</cfoutput></admin:resource>
	</ft:processformobjects>
</ft:processform>

<ft:form>
	<ft:object typename="rbReport" key="report" lFields="report" legend="Select Report" />
	<ft:object typename="rbReport" key="report" lFields="keys" legend="Results" />
	<ft:object typename="rbReport" key="report" lFields="bundle,locale,translated" legend="Update Bundle" />
	
	<ft:buttonPanel>
		<ft:button value="Update Bundle" />
	</ft:buttonPanel>
</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />