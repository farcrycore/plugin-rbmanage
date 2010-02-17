<cfsetting enablecfoutputonly="true" />

<cfset result = "" />

<cfloop from="1" to="#arraylen(application.rb.aSets)#" index="bundleindex">
	<cfset changed = false />
	<cfloop collection="#application.rb.aSets[bundleindex]#" item="locale">
		<cfset changed = changed or application.rb.aSets[bundleindex][locale].changed />
	</cfloop>
	<cfif changed>
		<cfset status = "modified" />
	<cfelse>
		<cfset status = "unmodified" />
	</cfif>
	
	<cfset result = result & "<tr id='#listgetat(application.rb.lSets,bundleindex)#' class='ui-widget-content status-#status#'><td class='select-value'><input type='checkbox' name='keys' value='#listgetat(application.rb.lSets,bundleindex)#' /></td><td>#listgetat(application.rb.lSets,bundleindex)#</td></tr>" />
	
	<cfloop collection="#application.rb.aSets[bundleindex]#" item="locale">
		<cfif application.rb.aSets[bundleindex][locale].changed>
			<cfset status = "modified" />
		<cfelse>
			<cfset status = "unmodified" />
		</cfif>
		
		<cfset result = result & "<tr id='#listgetat(application.rb.lSets,bundleindex)#-#locale#' class='ui-widget-content child-of-#listgetat(application.rb.lSets,bundleindex)# status-#status#'><td class='select-value'><input type='checkbox' name='keys' value='#listgetat(application.rb.lSets,bundleindex)#:#locale#' /></td><td>#locale#</td></tr>" />
	</cfloop>
</cfloop>

<cfoutput>#result#</cfoutput>

<cfsetting enablecfoutputonly="false" />