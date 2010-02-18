<cfcomponent hint="Resource bundle utility functions" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfset var o = "" />
		<cfset var thisplugin = "" />
		<cfset var thislocale = "" />
		<cfset var locales = application.i18nUtils.getLocales() />
		<cfset var localeNames = application.i18nUtils.getLocaleNames() />
		
		<!--- Initialise locations --->
		<cfset this.qLocations = querynew("value,name") />
			<cfset queryaddrow(this.qLocations) />
			<cfset querysetcell(this.qLocations,"value","core") />
			<cfset querysetcell(this.qLocations,"name","Core") />
			
			<cfloop list="#application.plugins#" index="thisplugin">
				<cfset queryaddrow(this.qLocations) />
				<cfset querysetcell(this.qLocations,"value",thisplugin) />
				<cfif fileexists(expandpath("/farcry/plugins/#thisplugin#/install/manifest.cfc"))>
					<cfset o = createobject("component","farcry.plugins.#thisplugin#.install.manifest") />
					<cfset querysetcell(this.qLocations,"name",o.name) />
				<cfelse>
					<cfset querysetcell(this.qLocations,"name",thisplugin) />
				</cfif>
			</cfloop>
			
			<cfset queryaddrow(this.qLocations) />
			<cfset querysetcell(this.qLocations,"value","project") />
			<cfset querysetcell(this.qLocations,"name","Project") />
		
		<!--- Initialise locales --->
		<cfset this.qLocales = querynew("value,name") />
			<cfset queryaddrow(this.qLocales) />
			<cfset querysetcell(this.qLocales,"value","base") />
			<cfset querysetcell(this.qLocales,"name","Base") />
			
			<cfloop list="#application.locales#" index="thislocale">
				<cfset queryaddrow(this.qLocales) />
				<cfset querysetcell(this.qLocales,"value",thislocale) />
				<cfset querysetcell(this.qLocales,"name",listgetat(localeNames,listfind(locales,thislocale))) />
			</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getLocations" access="public" output="false" returntype="query" description="Returns the possible locations">
		
		<cfreturn this.qLocations />
	</cffunction>
	
	<cffunction name="getLocationLabel" access="public" output="false" returntype="string" description="Returns the label for a location">
		<cfargument name="location" type="string" required="true" />
		
		<cfset var q = "" />
		
		<cfquery dbtype="query" name="q">
			select		[name]
			from		this.qLocations
			where		[value]=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#" />
		</cfquery>
		
		<cfif q.recordcount>
			<cfreturn q.name />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="getLocales" access="public" output="false" returntype="query" hint="Returns the list of supported locales">
		<cfargument name="bIncludeBase" type="boolean" required="false" default="false" />
		
		<cfset var q = this.qLocales />
		
		<cfif not arguments.bIncludeBase>
			<cfquery dbtype="query" name="q">
				select		[value],[name]
				from		this.qLocales
				where		not [value]=<cfqueryparam cfsqltype="cf_sql_varchar" value="base" />
			</cfquery>
		</cfif>
		
		<cfreturn q />
	</cffunction>
	
	<cffunction name="getLocaleLabel" access="public" output="false" returntype="string" description="Returns the label for a locale">
		<cfargument name="locale" type="string" required="true" />
		
		<cfset var q = "" />
		
		<cfquery dbtype="query" name="q">
			select		[name]
			from		this.qLocales
			where		[value]=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" />
		</cfquery>
		
		<cfif q.recordcount>
			<cfreturn q.name />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
</cfcomponent>