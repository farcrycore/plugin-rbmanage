<cfcomponent displayname="Missing Keys Report" hint="Reports on keys that are missing from the resource bundles">

	<cfset this.collation = "" />
	<cfset this.title = "Missing Keys Report" />
	<cfset this.minloglevel = 1 />

	<cffunction name="init" access="public" output="false" returntype="any" hint="Initializes and collates the report">
		<cfargument name="bundles" type="array" required="true" hint="The bundles to be processed" />
		<cfargument name="bundlenames" type="string" required="true" hint="The bundle names" />
		
		<cfset this.collation = createCollation() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createCollation" access="private" output="false" returntype="query" hint="Creates a collation variable">
		<cfreturn querynew("label,profilelocale,locale,bundle,rbkey,defaultvalue,base,#application.locales#,haschildren","varchar,varchar,varchar,varchar,varchar,varchar,integer#repeatstring(',integer',listlen(application.locales))#,bit") />
	
	</cffunction>

	<cffunction name="appendLogToReport" access="private" output="false" returntype="void" hint="Adds log data to a locale report">
		<cfargument name="profilelocale" type="string" required="true" />
		<cfargument name="locale" type="string" required="true" />
		<cfargument name="rbkey" type="string" required="true" />
		<cfargument name="bundle" type="string" required="true" />
		<cfargument name="defaultvalue" type="string" required="true" />
		
		<cfset var qFound = "" />
		<cfset var thislocale = "" />
		<cfset var thiscollation = this.collation />
		
		<cfquery dbtype="query" name="qFound">
			select	*
			from	thiscollation
			where	rbkey='#arguments.rbkey#'
		</cfquery>
		
		<cfif qFound.recordcount>
			<cfquery dbtype="query" name="this.collation">
				select	*
				from	thiscollation
				where	rbkey<>'#arguments.rbkey#'
			</cfquery>
			
			<cfset queryaddrow(this.collation) />
			<cfset querysetcell(this.collation,"label",qFound.label) />
			<cfset querysetcell(this.collation,"profilelocale",qFound.profilelocale) />
			<cfset querysetcell(this.collation,"locale",qFound.locale) />
			<cfset querysetcell(this.collation,"rbkey",qFound.rbkey) />
			<cfset querysetcell(this.collation,"bundle",qFound.bundle) />
			<cfset querysetcell(this.collation,"defaultvalue",qFound.defaultvalue) />
			<cfloop list="base,#application.locales#" index="thislocale">
				<cfif thislocale eq arguments.profilelocale and (arguments.locale eq "NA" or arguments.locale eq "base")>
					<cfset querysetcell(this.collation,thislocale,qFound[thislocale][1] + 1) />
				<cfelseif thislocale eq "base" and arguments.locale eq "NA">
					<cfset querysetcell(this.collation,thislocale,qFound[thislocale][1] + 1) />
				<cfelse>
					<cfset querysetcell(this.collation,thislocale,qFound[thislocale][1]) />
				</cfif>
			</cfloop>
			<cfset querysetcell(this.collation,"haschildren",qFound.haschildren) />
		<cfelse>
			<cfset queryaddrow(this.collation) />
			<cfset querysetcell(this.collation,"label",listlast(listlast(arguments.rbkey,"."),"@")) />
			<cfset querysetcell(this.collation,"profilelocale",arguments.profilelocale) />
			<cfset querysetcell(this.collation,"locale",arguments.locale) />
			<cfset querysetcell(this.collation,"rbkey",arguments.rbkey) />
			<cfloop list="base,#application.locales#" index="thislocale">
				<cfif thislocale eq arguments.profilelocale and (arguments.locale eq "NA" or arguments.locale eq "base")>
					<cfset querysetcell(this.collation,thislocale,1) />
				<cfelseif thislocale eq "base" and arguments.locale eq "NA">
					<cfset querysetcell(this.collation,thislocale,1) />
				<cfelse>
					<cfset querysetcell(this.collation,thislocale,0) />
				</cfif>
			</cfloop>
			<cfif find("@",arguments.rbkey)>
				<cfset querysetcell(this.collation,"bundle",arguments.bundle) />
				<cfset querysetcell(this.collation,"defaultvalue",arguments.defaultvalue) />
				<cfset querysetcell(this.collation,"haschildren",0) />
			<cfelse>
				<cfset querysetcell(this.collation,"bundle","") />
				<cfset querysetcell(this.collation,"defaultvalue","") />
				<cfset querysetcell(this.collation,"haschildren",1) />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getJSONData" access="public" output="false" returntype="string" hint="Returns a set of branches in JSON format">
		<cfargument name="group" type="string" required="false" default="" hint="Key group, e.g. webtop.admin" />
		
		<cfset var result = "" />
		<cfset var item = "" />
		<cfset var qResult = "" />
		<cfset var locale = "" />
		<cfset var thiscollation = this.collation />
		
		<cfquery dbtype="query" name="qResult">
			select	*
			from	thiscollation
			<cfif len(arguments.group)>
				where	rbkey like '#arguments.group#%'
			</cfif>
			order by	haschildren,label
		</cfquery>
		
		<cfloop query="qResult">
			<cfif len(arguments.group) lt len(rbkey) and not refind("(\.|@)",mid(rbkey,len(arguments.group)+2,len(rbkey)))>
				<cfset item = "{ 'uiProvider':'col', 'id':'#rbkey#', 'text':'#label#', 'defaultvalue':'#defaultvalue#', 'base':#qResult['base'][currentrow]#, " />
				<cfloop list="#application.locales#" index="locale">
					<cfset item = item & "'#locale#':#qResult[locale][currentrow]#, ">
				</cfloop>
				<cfset item = item & "'leaf':" />
				<cfif haschildren>
					<cfset item = item & "false" />
				<cfelse>
					<cfset item = item & "true" />
				</cfif>
				<cfset item = item & " }" />
				
				<cfset result = listappend(result,item) />
			</cfif>
		</cfloop>
		
		<cfset result = "[" & result & "]" />
		
		<cfreturn result />
	</cffunction>

	<cffunction name="getJSONColumns" access="public" output="false" returntype="struct" hint="Returns a JSON string describing the columns the JSON includes">
		<cfset var stResult = structnew() />
		
		<cfset stResult.json = "" />
		<cfset stResult.json = listappend(stResult.json,"{ 'header' : 'Key', 'width' : 300, 'dataIndex' : 'text' }") />
		<cfset stResult.json = listappend(stResult.json,"{ 'header' : 'Base', 'width' : 75, 'dataIndex' : 'base' }") />
		
		<cfloop list="#application.locales#" index="locale">
			<cfset stResult.json = listappend(stResult.json,"{ 'header' : '#locale#', 'width' : 75, 'dataIndex' : '#locale#' }") />
		</cfloop>
		
		<cfset stResult.json = listappend(stResult.json,"{ 'header' : 'Latest default', 'width' : 100, 'dataIndex' : 'defaultvalue' }") />
		
		<cfset stResult.json = "[" & stResult.json & "]" />
		<cfset stResult.width = 475 + listlen(application.locales)*75 />
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="getKeys" access="public" output="false" returntype="query" hint="Returns a query containing the requested keys and their default values">
		<cfargument name="keys" type="string" required="true" hint="List of keys / key groups" />
		
		<cfset var qKeys = querynew("key,value","varchar,varchar") />
		<cfset var thiscollation = this.collation />
		
		<cfloop list="#arguments.keys#" index="thiskey">
			<cfquery dbtype="query" name="qKeys">
				select	[key], [value]
				from	qKeys
				
				UNION
				
				select	rbkey, defaultvalue
				from	thiscollation
				where	rbkey like '#thiskey#%'
						and haschildren = 0
			</cfquery>
		</cfloop>
		
		<cfreturn qKeys />
	</cffunction>

	<cffunction name="logRequest" access="public" output="false" returntype="void" hint="Updates the report with the request information">
		<cfargument name="profilelocale" type="string" required="true" hint="The locale that the user was using" />
		<cfargument name="locale" type="string" required="true" hint="The locale the key was found in" />
		<cfargument name="bundle" type="string" required="true" hint="The bundle the key was found in" />
		<cfargument name="rbkey" type="string" required="true" hint="The key being requested" />
		<cfargument name="defaultvalue" type="string" required="true" hint="The default value passed in with the request" />
		
		<cfset var step = "" />
		<cfset var path = "" />
		
		<cfif not isquery(this.collation)>
			<cfset this.collation = createCollation() />
		</cfif>
		
		<cfif arguments.locale eq "NA" or arguments.locale eq "base">
			<cfloop list="#rbkey#" delimiters="." index="step">
				<cfif find("@",step)>
					<!--- Add this item --->
					<cfset path=listappend(path,listfirst(step,"@"),".") />
					<cfset appendLogToReport(arguments.profilelocale,arguments.locale,path,arguments.bundle,arguments.defaultvalue) />
					
					<!--- Add this property --->
					<cfset path=listappend(path,listlast(step,"@"),"@") />
					<cfset appendLogToReport(arguments.profilelocale,arguments.locale,path,arguments.bundle,arguments.defaultvalue) />
				<cfelse>
					<cfset path=listappend(path,step,".") />
					<cfset appendLogToReport(arguments.profilelocale,arguments.locale,path,arguments.bundle,arguments.defaultvalue) />
				</cfif>
			</cfloop>
		</cfif>
		
	</cffunction>
	
</cfcomponent>