<cfsetting enablecfoutputonly="true" />

<cfset result = "" />

<cfloop from="1" to="#arraylen(application.rb.aSets)#" index="bundleindex">
	<cfset thisbundle = "" />

	<cfset locales = "" />
	<cfset changed = false />
	<cfloop collection="#application.rb.aSets[bundleindex]#" item="locale">
		<cfset thislocale = "{ 'uiProvider':'col', 'id':'#listgetat(application.rb.lSets,bundleindex)#:#locale#', 'text':'#locale#', " />
		<cfif application.rb.aSets[bundleindex][locale].changed>
			<cfset thislocale = thislocale & "'status':'<span class=\'error\'>modified</span>', " />
		<cfelse>
			<cfset thislocale = thislocale & "'status':'<span class=\'success\'>unmodified</span>', " />
		</cfif>
		<cfset thislocale = thislocale & "'leaf':true }">
		
		<cfset changed = changed or application.rb.aSets[bundleindex][locale].changed />
		<cfset locales = listappend(locales,thislocale) />
	</cfloop>
	
	<cfset thisbundle = "{ 'uiProvider':'col', 'id':'#listgetat(application.rb.lSets,bundleindex)#', 'text':'#listgetat(application.rb.lSets,bundleindex)#', " />
	<cfif changed>
		<cfset thisbundle = thisbundle & "'status':'<span class=\'error\'>modified</span>', " />
	<cfelse>
		<cfset thisbundle = thisbundle & "'status':'<span class=\'success\'>unmodified</span>', " />
	</cfif>
	<cfset thisbundle = thisbundle & "'children': [#locales#], 'leaf':false }" />
	
	<cfset result = listappend(result,thisbundle) />
</cfloop>

<cfoutput>[#result#]</cfoutput>

<cfsetting enablecfoutputonly="false" />