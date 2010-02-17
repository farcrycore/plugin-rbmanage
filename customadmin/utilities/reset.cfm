<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Reset Resource Bundles" />

<cfset application.rb=createObject("component",application.factory.oUtils.getPath("resources","RBCFC")).init(application.locales) />

<cfoutput>
	<h1>Resource Bundles components have been reloaded</h1>
</cfoutput>

<admin:footer />

<cfsetting enablecfoutputonly="false" />