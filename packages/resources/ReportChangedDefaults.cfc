<cfcomponent displayname="Changed Defaults Report" hint="Reports on key default values that don't match the base bundles">

	<cfset this.collation = "" />
	<cfset this.title = "Changed Defaults Report" />
	<cfset this.minloglevel = 2 />
	
	<cfset variables.bundles = arraynew(1) />
	<cfset variables.bundlenames = "" />

	<cffunction name="init" access="public" output="true" returntype="component" hint="Initializes and collates the report">
		<cfargument name="bundles" type="array" required="true" hint="The bundles to be processed" />
		<cfargument name="bundlenames" type="string" required="true" hint="The bundle names" />
		
		<cfset this.collation = createCollation() />
		<cfset variables.bundles = arguments.bundles />
		<cfset variables.bundlenames = arguments.bundlenames />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createCollation" access="private" output="false" returntype="query" hint="Creates a collation variable">
		
		<cfreturn querynew("label,bundle,rbkey,currentdefault,newdefault,total,haschildren","varchar,varchar,varchar,varchar,varchar,integer,bit") />
	</cffunction>

	<cffunction name="appendLogToReport" access="private" output="false" returntype="void" hint="Adds log data to a locale report">
		<cfargument name="bundle" type="string" required="true" hint="The bundle the current default is in" />
		<cfargument name="rbkey" type="string" required="true" hint="The key being added to the report" />
		<cfargument name="currentdefault" type="string" required="true" hint="The current value in the resource bundle" />
		<cfargument name="newdefault" type="string" required="true" hint="The new default being provided by requests" />
		
		<cfset var qFound = "" />
		<cfset var thiscollation = this.collation />
		
		<cfquery dbtype="query" name="qFound">
			select	*
			from	thiscollation
			where	rbkey='#arguments.rbkey#'
		</cfquery>
		
		<cfif qFound.recordcount>
			<cfquery dbtype="query" name="this.collation">
				select	label,bundle,rbkey,currentdefault,newdefault,total,haschildren
				from	thiscollation
				where	rbkey<>'#arguments.rbkey#'
				
				UNION
				
				select	label,bundle,rbkey,currentdefault,newdefault,total+1,haschildren
				from	qFound
			</cfquery>
		<cfelse>
			<cfset queryaddrow(this.collation) />
			<cfset querysetcell(this.collation,"label",listlast(listlast(arguments.rbkey,"."),"@")) />
			<cfset querysetcell(this.collation,"bundle",arguments.bundle) />
			<cfset querysetcell(this.collation,"rbkey",arguments.rbkey) />
			<cfset querysetcell(this.collation,"total",1) />
			<cfif find("@",arguments.rbkey)>
				<cfset querysetcell(this.collation,"currentdefault",arguments.currentdefault) />
				<cfset querysetcell(this.collation,"newdefault",arguments.newdefault) />
				<cfset querysetcell(this.collation,"haschildren",0) />
			<cfelse>
				<cfset querysetcell(this.collation,"currentdefault","") />
				<cfset querysetcell(this.collation,"newdefault","") />
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
				<cfset item = "{ 'uiProvider':'col', 'id':'#rbkey#', 'text':'#label#', 'currentdefault':'#currentdefault#', 'newdefault':'#newdefault#', 'total':#total#, 'leaf':" />
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
		<cfset stResult.json = listappend(stResult.json,"{ 'header' : 'Current default', 'width' : 100, 'dataIndex' : 'currentdefault' }") />
		<cfset stResult.json = listappend(stResult.json,"{ 'header' : 'New default', 'width' : 100, 'dataIndex' : 'newdefault' }") />
		<cfset stResult.json = listappend(stResult.json,"{ 'header' : 'Total', 'width' : 75, 'dataIndex' : 'total' }") />
		<cfset stResult.json = "[" & stResult.json & "]" />
		
		<cfset stResult.width = 575 />
		
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
				
				select	rbkey, newdefault
				from	thiscollation
				where	rbkey like '#thiskey#%'
						and haschildren = 0
			</cfquery>
		</cfloop>
		
		<cfloop query="qKeys">
			<cfset querysetcell(qKeys,'key',listrest(key,'.'),currentrow) />
		</cfloop>
		
		<cfreturn qKeys />
	</cffunction>

	<cffunction name="logRequest" access="public" output="false" returntype="void" hint="Updates the report with the request information">
		<cfargument name="profilelocale" type="string" required="true" hint="The locale that the user was using" />
		<cfargument name="locale" type="string" required="true" hint="The locale the key was found in" />
		<cfargument name="bundle" type="string" required="true" hint="The bundle the key was found in" />
		<cfargument name="rbkey" type="string" required="true" hint="The key being requested" />
		<cfargument name="defaultvalue" type="string" required="true" hint="The default value passed in with the request" />
		
		<cfset var path = "" />
		<cfset var step = "" />
		
		<cfif not isquery(this.collation)>
			<cfset this.collation = createCollation() />
		</cfif>
		
		<cfloop from="1" to="#arraylen(variables.bundles)#" index="i">
			<cfif structkeyexists(variables.bundles[i].base.bundle,arguments.rbkey) and variables.bundles[i].base.bundle[arguments.rbkey] neq arguments.defaultvalue>
				<cfloop list="#listgetat(variables.bundlenames,i)#.#arguments.rbkey#" delimiters="." index="step">
					<cfif find("@",step)>
						<!--- Add this item --->
						<cfset path=listappend(path,listfirst(step,"@"),".") />
						<cfset appendLogToReport(listgetat(variables.bundlenames,i),path,"","") />
						
						<!--- Add this property --->
						<cfset path=listappend(path,listlast(step,"@"),"@") />
						<cfset appendLogToReport(listgetat(variables.bundlenames,i),path,variables.bundles[i].base.bundle[rbkey],arguments.defaultvalue) />
					<cfelse>
						<cfset path=listappend(path,step,".") />
						
						<cfset appendLogToReport(listgetat(variables.bundlenames,i),path,"","") />
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>