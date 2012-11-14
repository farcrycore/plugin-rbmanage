<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Reset Resource Bundles" />

<admin:resource key="rbmanage.reset@title"><cfoutput><h1>Reset Resource Bundles</h1></cfoutput></admin:resource>

<ft:form>
	<ft:buttonPanel>
		<ft:button value="Reset" />
	</ft:buttonPanel>
</ft:form>

<ft:processform action="Reset">
	<cfset application.rb=createObject("component",application.factory.oUtils.getPath("resources","RBCFC")).init(application.locales) />
	<admin:resource key="rbmanage.reset.complete@text"><cfoutput>Resource Bundles components have been reloaded</cfoutput></admin:resource>
</ft:processform>

<admin:footer />

<cfsetting enablecfoutputonly="false" />