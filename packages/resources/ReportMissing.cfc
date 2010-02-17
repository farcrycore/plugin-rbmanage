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

	<cffunction name="getData" access="public" output="false" returntype="any" hint="Returns a set of branches in JSON format">
		<cfargument name="group" type="string" required="false" default="" hint="Key group, e.g. webtop.admin" />
		<cfargument name="format" type="string" required="false" default="json" hint="json,query" />
		
		<cfset var result = "" />
		<cfset var item = "" />
		<cfset var qResult = "" />
		<cfset var locale = "" />
		<cfset var thiscollation = this.collation />
		
		<cfset var index = 0 />
		<cfset var value = structnew() />
		<cfset var sendback = arraynew(1) />
		
		<cfimport taglib="/farcry/core/tags/misc" prefix="misc" />
		
		<cfquery dbtype="query" name="qResult">
			select	*
			from	thiscollation
			<cfif len(arguments.group)>
				where	rbkey like '#arguments.group#%'
			</cfif>
			order by	haschildren,label
		</cfquery>
		
		<misc:map values="#qResult#" result="qResult">
			<cfif len(arguments.group) lt len(value.rbkey) and not refind("(\.|@)",mid(value.rbkey,len(arguments.group)+2,len(value.rbkey)))>
				<cfset sendback[1] = value />
			</cfif>
		</misc:map>
		
		<cfswitch expression="#arguments.format#">
			<cfcase value="query">
				<cfset result = qResult />
			</cfcase>
			
			<cfcase value="json">
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
			</cfcase>
		</cfswitch>
		
		<cfreturn result />
	</cffunction>

	<cffunction name="getColumns" access="public" output="false" returntype="struct" hint="Returns a JSON string describing the columns the JSON includes">
		<cfargument name="format" type="string" required="false" default="json" hint="json,query" />
		
		<cfset var stResult = structnew() />
		<cfset var qColumns = querynew("header,width,dataIndex","varchar,integer,varchar") />
		
		<cfset queryaddrow(qColumns) />
		<cfset querysetcell(qColumns,"header",'Key') />
		<cfset querysetcell(qColumns,"width",300) />
		<cfset querysetcell(qColumns,"dataIndex",'label') />
		
		<cfset queryaddrow(qColumns) />
		<cfset querysetcell(qColumns,"header",'Base') />
		<cfset querysetcell(qColumns,"width",75) />
		<cfset querysetcell(qColumns,"dataIndex",'base') />
		
		<cfloop list="#application.locales#" index="locale">
			<cfset queryaddrow(qColumns) />
			<cfset querysetcell(qColumns,"header",locale) />
			<cfset querysetcell(qColumns,"width",75) />
			<cfset querysetcell(qColumns,"dataIndex",locale) />
		</cfloop>
		
		<cfswitch expression="#arguments.format#">
			<cfcase value="query">
				<cfset stResult.columns = qColumns />
			</cfcase>
			
			<cfcase value="json">
				<cfset stResult.columns = "" />
				<cfloop query="qColumns">
					<cfset stResult.columns = listappend(stResult.columns,"{ 'header' : '#qColumns.header#', 'width' : #qColumns.width#, 'dataIndex' : '#qColumns.dataIndex#' }") />
				</cfloop>
				<cfset stResult.json = "[" & stResult.json & "]" />
			</cfcase>
		</cfswitch>
		
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