<cfcomponent hint="Manage resource bundles" output="false" extends="farcry.core.packages.resources.RBCFC">
	
	<cfset this.reports = structnew() />
	
	<cffunction name="init" access="public" output="false" returntype="component" hint="Initializes component">
		<cfargument name="locales" type="string" required="false" default="" />
		
		<cfset var item = "" />
		
		<cfset super.init(arguments.locales) />
		
		<!--- Set up reports --->
		<cfloop list="#application.factory.oUtils.getComponents('resources')#" index="item">
			<cfif findnocase("report",item)>
				<cfset this.reports[item] = createobject("component",application.factory.oUtils.getPath("resources",item)).init(this.aSets,this.lSets) />
				<cfif this.reports[item].minloglevel gt application.stPlugins.rbmanage.loglevel>
					<cfset structdelete(this.reports,item) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getResource" access="public" output="false" returntype="string" hint="Returns the resource string">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="default" type="string" required="false" default="#arguments.key#" />
		<cfargument name="locale" type="string" required="false" />
		
		<cfset var i = 0 />
		
		<cfif structkeyexists(session,"dmProfile")>
			<cfparam name="arguments.locale" default="#session.dmProfile.locale#" />
		<cfelse>
			<cfparam name="arguments.locale" default="#application.config.general.locale#" />
		</cfif>
		
		<!--- Log levels: 0: none, 1: uses of default value, 2: uses of base resource, 3: all requests --->
		<cfloop from="#arraylen(this.aSets)#" to="1" step="-1" index="i">
			<cfif structkeyexists(this.aSets[i],arguments.locale) and structkeyexists(this.aSets[i][arguments.locale].bundle,arguments.key)>
				<cfif application.stPlugins.rbmanage.loglevel gte application.stPlugins.rbmanage.log_all>
					<cfset logRequest(arguments.locale,arguments.locale,listgetat(this.lSets,i),arguments.key,arguments.default) />
				</cfif>
				<cfreturn this.aSets[i][arguments.locale].bundle[arguments.key] />
			</cfif>
			<cfif structkeyexists(this.aSets[i]["base"].bundle,arguments.key)>
				<cfif application.stPlugins.rbmanage.loglevel gte application.stPlugins.rbmanage.log_base>
					<cfset logRequest(arguments.locale,"base",listgetat(this.lSets,i),arguments.key,arguments.default) />
				</cfif>
				<cfreturn this.aSets[i]["base"].bundle[arguments.key] />
			</cfif>
		</cfloop>
		
		<cfif application.stPlugins.rbmanage.loglevel gte application.stPlugins.rbmanage.log_unfound>
			<cfset logRequest(arguments.locale,"NA","NA",arguments.key,arguments.default) />
		</cfif>
		<cfreturn arguments.default />
	</cffunction>

	<cffunction name="logRequest" access="public" output="false" returntype="void" hint="Logs a resource attempt resource">
		<cfargument name="profilelocale" type="string" required="true" />
		<cfargument name="locale" type="string" required="true" />
		<cfargument name="bundle" type="string" required="true" />
		<cfargument name="rbkey" type="string" required="true" />
		<cfargument name="defaultvalue" type="string" required="true" />
		
		<cfset var report = "" />
		
		<cfloop collection="#this.reports#" item="report">
			<cfset this.reports[report].logRequest(profilelocale,locale,bundle,rbkey,defaultvalue) />
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getKeyMetadata" access="public" output="false" returntype="struct" hint="Returns the resource string">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="locale" type="string" required="false" default="" />
		
		<cfset var i = 0 />
		
		<cfif structkeyexists(session,"dmProfile")>
			<cfparam name="arguments.locale" default="#session.dmProfile.locale#" />
		<cfelse>
			<cfparam name="arguments.locale" default="#application.config.general.locale#" />
		</cfif>
		
		<cfloop from="#arraylen(this.aSets)#" to="1" step="-1" index="i">
			<cfif structkeyexists(this.aSets[i],arguments.locale) and structkeyexists(this.aSets[i][arguments.locale].metadata,arguments.key)>
				<cfreturn this.aSets[i][arguments.locale].metadata[arguments.key] />
			</cfif>
			<cfif structkeyexists(this.aSets[i],"base") and structkeyexists(this.aSets[i]["base"].metadata,arguments.key)>
				<cfreturn this.aSets[i]["base"].metadata[arguments.key] />
			</cfif>
		</cfloop>
		
		<cfreturn structnew() />
	</cffunction>
	
	<cffunction name="getReportJSON" access="public" output="false" returntype="string" hint="Returns a set of branches in JSON format">
		<cfargument name="report" type="string" required="false" default="" hint="The report required" />
		<cfargument name="group" type="string" required="false" default="" hint="Key group, e.g. webtop.admin" />
		
		<cfreturn this.reports[arguments.report].getJSONData(arguments.group) />
	</cffunction>
	
	<cffunction name="getReportColumns" access="public" output="false" returntype="struct" hint="Returns the columns returned in the JSON string">
		<cfargument name="report" type="string" required="false" default="" hint="The report required" />
		
		<cfreturn this.reports[arguments.report].getJSONColumns() />
	</cffunction>
	
	<cffunction name="getReportTitle" access="public" output="false" returntype="string" hint="Returns the title of a report">
		<cfargument name="report" type="string" required="true" hint="The name of the report" />

		<cfreturn this.reports[arguments.report].title />
	</cffunction>
	
	<cffunction name="getReportList" access="public" output="false" returntype="string" hint="Returns a list of available reports">
		<cfset var result = "" />
		<cfset var name = "" />
		
		<cfloop collection="#this.reports#" item="name">
			<cfset result = listappend(result,"#name#:#this.reports[name].title#") />
		</cfloop>
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="setKeys" access="public" output="true" returntype="struct" hint="Added keys and key groups and returns full list of keys added">
		<cfargument name="bundle" type="string" required="true" hint="The bundle the keys are to be added to" />
		<cfargument name="locale" type="string" required="true" hint="The locale resource to update" />
		<cfargument name="keys" type="query" required="true" hint="Query of keys and values" />
		<cfargument name="translated" type="boolean" required="true" hint="Whether keys added should be marked as translated" />
		
		<cfset var stResult = this.aSets[listfind(this.lSets,arguments.bundle)][arguments.locale].setKeys(arguments.keys,arguments.translated) />
		<cfset var thislocale = "" />
		
		<cfif arguments.locale eq "base">
			<cfloop collection="#this.aSets[listfind(this.lSets,arguments.bundle)]#" item="thislocale">
				<cfif not thislocale eq "base">
					<cfset this.aSets[listfind(this.lSets,arguments.bundle)][thislocale].setTranslated(stResult.updated,false) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="getKeys" access="public" output="false" returntype="query" hint="Returns a key-value query for a particular report">
		<cfargument name="report" type="string" required="true" hint="The report being queried" />
		<cfargument name="keys" type="string" required="true" hint="A list of the keys being requested" />

		<cfreturn this.reports[arguments.report].getKeys(arguments.keys) />
	</cffunction>
	
	<cffunction name="saveResource" access="public" output="false" returntype="void" hint="Saves a resource">
		<cfargument name="bundle" type="string" required="true" hint="The bundle the keys are to be added to" />
		<cfargument name="locale" type="string" required="false" default="base,#this.locales#" hint="The locale resource to update" />
		
		<cfset var thislocale = "" />
		
		<cfloop list="#arguments.locale#" index="thislocale">
			<cfset this.aSets[listfind(lcase(this.lSets),lcase(arguments.bundle))][thislocale].saveResource() />
		</cfloop>
	</cffunction>
	
</cfcomponent>