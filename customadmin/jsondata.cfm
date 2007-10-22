<cfsetting enablecfoutputonly="true" />

<cfparam name="url.report" default="missing">
<cfparam name="form.node" default="" />

<cfif form.node eq "root">
	<cfset form.node="" />
</cfif>

<cfset json = application.rb.getReportJSON(url.report,form.node) />

<cfoutput>#json#</cfoutput>

<cfsetting enablecfoutputonly="false" />