<cfcomponent displayname="Unused Keys Report" hint="Reports on resource bundle keys that weren't requested">

	<cfset this.collation = "" />
	<cfset this.title = "Unused Keys Report" />
	<cfset this.minloglevel = 2 />
	
	<cfset variables.bundles = arraynew(1) />
	<cfset variables.bundlenames = "" />
	
	<cfset variables.bundlekeys = arraynew(1) />

	<cffunction name="init" access="public" output="true" returntype="any" hint="Initializes and collates the report">
		<cfargument name="bundles" type="array" required="true" hint="The bundles to be processed" />
		<cfargument name="bundlenames" type="string" required="true" hint="The bundle names" />
		
		<cfset var bundleindex = 0 />
		<cfset var locale = "" />
		<cfset var key = "" />
		<cfset var id = "" />
		<cfset var result = structnew() />
		<cfset var path = "" />
		
		<cfimport taglib="../../tags" prefix="rb" />
		
		<cfset this.collation = createCollation() />
		<cfset variables.bundles = arguments.bundles />
		<cfset variables.bundlenames = arguments.bundlenames />
		
		<!--- Get all keys for each resource --->
		<cfloop from="1" to="#arraylen(variables.bundles)#" index="bundleindex">
			<cfset variables.bundlekeys[bundleindex] = structnew() />
			<cfloop collection="#variables.bundles[bundleindex]#" item="locale">
				<cfloop collection="#variables.bundles[bundleindex][locale].bundle#" item="key">
					<cfif not find(".",key)>
						<cfset id = "#listgetat(variables.bundlenames,bundleindex)#.#locale#.#ucase(left(key,1))#.#ucase(mid(key,2,1))#.#key#" />
					<cfelse>
						<cfset id = "#listgetat(variables.bundlenames,bundleindex)#.#locale#.#key#" />
					</cfif>
					
					<rb:growlist list="#id#" index="path" delimiters=".@">
						<cfif  structkeyexists(result,path)>
							<cfset result[path].total = result[path].total + 1 />
						<cfelse>
							<cfset result[path] = structnew() />
							<cfset result[path].total = 1 />
							<cfset result[path].path = path />
							<cfset result[path].bundle = listgetat(variables.bundlenames,bundleindex) />
							<cfset result[path].locale = locale />
							<cfif path eq id>
								<cfset result[path].value = variables.bundles[bundleindex][locale].bundle[key] />
							<cfelse>
								<cfset result[path].value = "" />
							</cfif>
						</cfif>
					</rb:growlist>
				</cfloop>
			</cfloop>
					
			<cfloop collection="#result#" item="path">
				<cfset appendLogToReport(result[path].bundle,result[path].locale,result[path].path,result[path].value,result[path].total) />
			</cfloop>
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createCollation" access="private" output="false" returntype="query" hint="Creates a collation variable">
		
		<cfreturn querynew("label,bundle,locale,rbkey,value,total,haschildren","varchar,varchar,varchar,varchar,varchar,integer,bit") />
	</cffunction>

	<cffunction name="appendLogToReport" access="private" output="false" returntype="void" hint="Adds log data to a locale report">
		<cfargument name="bundle" type="string" required="true" hint="The bundle the current default is in" />
		<cfargument name="locale" type="string" required="true" hint="The locale of the key" />
		<cfargument name="rbkey" type="string" required="true" hint="The key being added to the report" />
		<cfargument name="value" type="string" required="true" hint="The value of the key" />
		<cfargument name="total" type="numeric" required="true" hint="The number of resource under this one" />
		
		<cfset var qFound = "" />
		<cfset var thiscollation = this.collation />

		<cfset queryaddrow(this.collation) />
		<cfset querysetcell(this.collation,"label",listlast(arguments.rbkey,".@")) />
		<cfset querysetcell(this.collation,"bundle",arguments.bundle) />
		<cfset querysetcell(this.collation,"locale",arguments.locale) />
		<cfset querysetcell(this.collation,"rbkey",arguments.rbkey) />
		<cfset querysetcell(this.collation,"value",arguments.value) />
		<cfset querysetcell(this.collation,"total",arguments.total) />
		<cfif len(arguments.value)>
			<cfset querysetcell(this.collation,"haschildren",0) />
		<cfelse>
			<cfset querysetcell(this.collation,"haschildren",1) />
		</cfif>
	</cffunction>
	
	<cffunction name="removeFromReport" access="private" output="false" returntype="void" hint="Removes log data from a locale report">
		<cfargument name="bundle" type="string" required="true" hint="The bundle the current default is in" />
		<cfargument name="locale" type="string" required="true" hint="The locale of the key" />
		<cfargument name="rbkey" type="string" required="true" hint="The key being added to the report" />
		
		<cfset var qFound = "" />
		<cfset var thiscollation = this.collation />

		<cfquery dbtype="query" name="qFound">
			select	*
			from	thiscollation
			where	rbkey='#arguments.rbkey#'
		</cfquery>
		
		<cfquery dbtype="query" name="this.collation">
			select	label,bundle,locale,rbkey,[value],total,haschildren
			from	thiscollation
			where	rbkey<>'#arguments.rbkey#'
			
			<cfif qFound.recordcount and qFound.total gt 1>
				UNION
				
				select	label,bundle,locale,rbkey,[value],total-1,haschildren
				from	qFound
			</cfif>
		</cfquery>
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
			select	distinct *
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
						<cfset item = "{ 'uiProvider':'col', 'id':'#rbkey#', 'text':'#label#', 'value':'#value#', 'total':#total#, 'leaf':" />
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
		<cfset querysetcell(qColumns,"width",180) />
		<cfset querysetcell(qColumns,"dataIndex",'label') />
		
		<cfset queryaddrow(qColumns) />
		<cfset querysetcell(qColumns,"header",'Value') />
		<cfset querysetcell(qColumns,"width",130) />
		<cfset querysetcell(qColumns,"dataIndex",'value') />
		
		<cfset queryaddrow(qColumns) />
		<cfset querysetcell(qColumns,"header",'Total') />
		<cfset querysetcell(qColumns,"width",105) />
		<cfset querysetcell(qColumns,"dataIndex",'total') />
		
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
		
		<cfset stResult.width = 415 />
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="getKeys" access="public" output="false" returntype="query" hint="Returns a query containing the requested keys and their default values">
		<cfargument name="keys" type="string" required="true" hint="List of keys / key groups" />
		
		<cfset var qKeys = querynew("key,value","varchar,varchar") />
		<cfset var thiscollation = this.collation />
		<cfset var thiskey = "" />
		
		<cfloop list="#arguments.keys#" index="thiskey">
			<cfquery dbtype="query" name="qKeys">
				select	[key], [value]
				from	qKeys
				
				UNION
				
				select	rbkey, ''
				from	thiscollation
				where	rbkey like '#thiskey#%'
						and haschildren = 0
			</cfquery>
		</cfloop>
		
		<cfloop query="qKeys">
			<cfset thiskey = application.factory.oUtils.listSlice(key,3,-1,'.') />
			<cfif len(listfirst(thiskey,".")) eq 1>
				<cfset thiskey = application.factory.oUtils.listSlice(thiskey,3,-1,'.') />
			</cfif>
			<cfset querysetcell(qKeys,'key',thiskey,currentrow) />
		</cfloop>
		
		<cfreturn qKeys />
	</cffunction>

	<cffunction name="logRequest" access="public" output="false" returntype="void" hint="Updates the report with the request information">
		<cfargument name="profilelocale" type="string" required="true" hint="The locale that the user was using" />
		<cfargument name="locale" type="string" required="true" hint="The locale the key was found in" />
		<cfargument name="bundle" type="string" required="true" hint="The bundle the key was found in" />
		<cfargument name="rbkey" type="string" required="true" hint="The key being requested" />
		<cfargument name="defaultvalue" type="string" required="true" hint="The default value passed in with the request" />
		
		<cfset var bundleindex = 0 />
		<cfset var thislocale = "" />
		<cfset var thiscollation = this.collation />
		<cfset var path = "" />
		<cfset var step = "" />
		
		<cfimport taglib="../../tags" prefix="rb" />
		
		<cfif not isquery(this.collation)>
			<cfset this.collation = createCollation() />
		</cfif>
		
		<cfloop from="1" to="#arraylen(variables.bundles)#" index="bundleindex">
			<cfloop collection="#variables.bundles[bundleindex]#" item="thislocale">
				<cfif structkeyexists(variables.bundles[bundleindex][thislocale].bundle,arguments.rbkey)>
					<rb:growlist list="#listgetat(variables.bundlenames,bundleindex)#.#thislocale#.#arguments.rbkey#" index="path" delimiters=".@">
						<cfset removeFromReport(listgetat(variables.bundlenames,bundleindex),thislocale,path) />
					</rb:growlist>
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>

</cfcomponent>