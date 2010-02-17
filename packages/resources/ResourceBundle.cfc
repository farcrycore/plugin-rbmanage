<cfcomponent hint="Encapsulates a resource bundle" output="false" extends="farcry.core.packages.resources.ResourceBundle">
	
	<!--- =========== PUBLIC =========== --->
	<cfset this.metadata = querynew("source,locale,filename,rbkey,file,fileEncoding,fileLanguage,fileCountry,fileVariant,fileManager,fileComment,group,groupComment,translated,created,modified,creator,modifier,comment","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,date,date,varchar,varchar,varchar") />
	<cfset this.cfile = "" />
	<cfset this.language = "" />
	<cfset this.country = "" />
	<cfset this.comment = "" />
	<cfset this.manager = "" />
	
	<cfset this.changed = false />
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="Loads a file into the component">
		<cfargument name="file" type="string" required="true" />
		
		<cfset super.init(arguments.file) />
		<cfset this.metadata = loadMetadata(this.file) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- =========== PRIVATE =========== --->
	
	<!--- Java Objects --->
	<cfset variables.jISR = CreateObject("java","java.io.InputStreamReader") />
	<cfset variables.jBR = CreateObject("java","java.io.BufferedReader") />
	
	<cffunction name="initMetadata" access="private" output="false" returntype="query" hint="Returns an initialized metadata variable">
	
		<cfreturn querynew("source,locale,filename,rbkey,file,fileEncoding,fileLanguage,fileCountry,fileVariant,fileManager,fileComment,group,groupComment,translated,created,modified,creator,modifier,comment","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,date,date,varchar,varchar,varchar") />
	</cffunction>
	
	<cffunction name="loadMetadata"access="private" output="false" returntype="any" hint="Reads and parses metadata in java resource bundle per locale">
		<cfargument name="file" required="Yes" type="string" />
		<cfargument name="basemetadata" type="struct" required="false" default="#structnew()#" />
		
		<cfscript>
			var line=""; // holds each line
			var exists = false; // Used to track whether a key exists already
			var key = ""; // Current key
			var result = initMetadata(); // Resulting data
			
			// Setup metadata variables
			arguments.basemetadata.filename = arguments.file;
			arguments.basemetadata.file = "";
			arguments.basemetadata.fileEncoding = "";
			arguments.basemetadata.fileLanguage = "";
			arguments.basemetadata.fileCountry = "";
			arguments.basemetadata.fileVariant = "";
			arguments.basemetadata.fileManager = "";
			arguments.basemetadata.fileComment = "";
			
			arguments.basemetadata.group = "";
			arguments.basemetadata.groupComment = "";
			
			arguments.basemetadata.translated = "";
			arguments.basemetadata.created = "";
			arguments.basemetadata.modified = "";
			arguments.basemetadata.creator = "";
			arguments.basemetadata.modifier = "";
			arguments.basemetadata.comment = "";
			
			if (fileExists(arguments.file)) { // final check, if this fails the file is not where it should be
				variables.jFIS.init(arguments.file);
				variables.jISR.init(variables.jFIS,"utf-8");
				variables.jBR.init(variables.jISR);
				
				try {
					while(true) {
						line = variables.jBR.readLine();
						
						if (len(line) and listcontains("##,!",left(line,1)))
							structappend(arguments.basemetadata,parseComment(line),true);
						else if (len(line) and refind("[^\\](=|:| )",line)) {
							arguments.basemetadata.rbkey = parseKey(line);
							result = addMetaData(result,arguments.basemetadata);
						}
					}
				}
				catch (coldfusion.runtime.UndefinedVariableException e) {
					// EOF
				}
				
				this.cfile = arguments.basemetadata.file;
				this.language = arguments.basemetadata.fileLanguage;
				this.country = arguments.basemetadata.fileCountry;
				this.manager = arguments.basemetadata.fileManager;
				this.comment = arguments.basemetadata.fileComment;
				
				this.changed = false;
				
				variables.jBR.close();
				variables.jISR.close();
				variables.jBR.close();
			}
		</cfscript>
		
		<cfreturn result />
	</cffunction>

	<!--- ======== METADATA VARIABLE ========= --->
	<cffunction name="getKeyMetadata" access="public" output="true" returntype="struct" hint="Returns the metadata for the specified key">
		<cfargument name="key" type="string" required="true" hint="The key requested" />
		
		<cfset var stMetadata = structnew() />
		<cfset var col = "" />
		
		<!--- Setup metadata variables --->
		<cfset stMetadata.file = "" />
		<cfset stMetadata.fileEncoding = "UTF-8" />
		<cfset stMetadata.fileLanguage = this.language />
		<cfset stMetadata.fileCountry = this.country />
		<cfset stMetadata.fileVariant = "" />
		<cfset stMetadata.fileManager = this.manager />
		<cfset stMetadata.fileComment = this.comment />
		
		<cfset stMetadata.group = "" />
		<cfset stMetadata.groupComment = "" />
		
		<cfset stMetadata.rbkey = arguments.key />
		<cfset stMetadata.translated = "false" />
		<cfset stMetadata.created = "" />
		<cfset stMetadata.modified = "" />
		<cfset stMetadata.creator = "" />
		<cfset stMetadata.modifier = "" />
		<cfset stMetadata.comment = "" />
		
		<cfquery dbtype="query" name="qFind">
			select	*
			from	this.metadata
			where	rbkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#" />
		</cfquery>
		
		<cfif qFind.recordcount>
			<cfloop list="#qFind.columnlist#" index="col">
				<cfset stMetadata[col] = qFind[col][1] />
			</cfloop>
		</cfif>
		
		<cfreturn stMetadata />
	</cffunction>
	
	<cffunction name="addMetadata" access="private" output="false" returntype="any" hint="Returns true if the metadata is added to the component variable">
		<cfargument name="current" type="any" required="true" />
		<cfargument name="metadata" type="struct" required="true" />
		
		<cfset var qResult = arguments.current />
		
		<!--- Initialize store --->
		<cfif not isquery(qResult)>
			<cfset qResult = querynew("source,locale,filename,rbkey,file,fileEncoding,fileLanguage,fileCountry,fileVariant,fileManager,fileComment,group,groupComment,translated,created,modified,creator,modifier,comment","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,date,date,varchar,varchar,varchar") />
		</cfif>
		
		<cfquery dbtype="query" name="qResult">
			select	*
			from	qResult
			where	rbkey<>'#arguments.metadata.rbkey#'
		</cfquery>
		
		<!--- Add the metadata --->
		<cfset queryaddrow(qResult) />
		<cfloop collection="#arguments.metadata#" item="val">
			<cfif listcontains(qResult.columnlist,val)>
				<cfset querysetcell(qResult,val,arguments.metadata[val]) />
			</cfif>
		</cfloop>
		
		<cfset this.changed = true />
		
		<cfreturn qResult />
	</cffunction>

	<cffunction name="removeMetadata" access="private" output="false" returntype="query" hint="Removes a key from the metadata struct">
		<cfargument name="current" type="any" required="true" hint="The current set of metadata" />
		<cfargument name="key" type="string" required="true" hint="The key to remove" />
		
		<cfset var qResult = arguments.current />
		
		<cfquery dbtype="query" name="qResult">
			select	*
			from	qResult
			where	rbkey <> '#arguments.key#'
		</cfquery>
		
		<cfreturn qResult />
	</cffunction>

	<!--- ========= UPDATE DATA =========== --->
	<cffunction name="setKeys" access="public" output="true" returntype="struct" hint="Adds keys to the bundle">
		<cfargument name="keys" type="query" required="true" hint="A query containing the keys and values" />
		<cfargument name="translated" type="boolean" required="true" hint="Whether keys added should be marked as translated" />
		
		<cfset var stMetadata = structnew() />
		<cfset var updates = structnew() /><!--- Track which keys are added, updated, and delted --->
		
		<cfset updates.added = "" />
		<cfset updates.updated = "" />
		<cfset updates.deleted = "" />
		
		<!--- Add key metadata --->
		<cfloop query="arguments.keys">
			<cfif len(value)><!--- If this key is being added or updated --->
				<!--- Setup metadata variables --->
				<cfset stMetadata = getKeyMetadata(key) />
				
				<!--- Add key to updates struct --->
				<cfif len(stMetadata.created)>
					<cfset updates.updated = listappend(updates.updated,key) />
				<cfelse>
					<cfset updates.added = listappend(updates.added,key) />
				</cfif>
				
				<cfswitch expression="#listfirst(key,'.')#">
					<cfcase value="webtop">
						<cfset stMetadata.group = "Webtop" />
						<cfset stMetadata.groupComment = "Keys used in the webtop menu structure" />
					</cfcase>
					<cfcase value="forms">
						<cfset stMetadata.group = "Forms" />
						<cfset stMetadata.groupComment = "Keys used in forms" />
					</cfcase>
					<cfcase value="coapi">
						<cfset stMetadata.group = "COAPI" />
						<cfset stMetadata.groupComment = "Keys used coapi metadata" />
					</cfcase>
				</cfswitch>
				
				<cfif arguments.translated>
					<cfset stMetadata.translated = "true" />
				<cfelse>
					<cfset stMetadata.translated = "false" />
				</cfif>
				
				<cfif not len(stMetadata.created)><cfset stMetadata.created=dateformat(now(),'yyyy-mm-dd') /></cfif>
				<cfif not len(stMetadata.creator)><cfset stMetadata.creator=session.dmSec.authentication.userlogin /></cfif>
				<cfset stMetadata.modified = dateformat(now(),"yyyy-mm-dd") />
				<cfset stMetadata.modifier = session.dmSec.authentication.userlogin />
				
				<!--- Update metadata --->
				<cfset this.metadata = addMetadata(this.metadata,stMetadata) />
				
				<!--- Update bundle --->
				<cfset this.bundle[key] = value />
			<cfelse><!--- If this key is being removed --->
				<cfset this.metadata = removeMetadata(this.metadata,key) />
				<cfset structdelete(this.bundle,key) />
				
				<!--- Add key to updates struct --->
				<cfset updates.deleted = listappend(updates.deleted,key) />
			</cfif>
		</cfloop>
		
		<cfset this.changed=true />
		
		<cfreturn updates />
	</cffunction>
	
	<cffunction name="setTranslated" access="public" output="false" returntype="void" hint="Sets translated flag for specified keys">
		<cfargument name="keys" type="string" required="true" hint="The keys to update" />
		<cfargument name="translated" type="boolean" required="true" hint="The value to set the translated flag to" />
		
		<cfset var item = "" />
		<cfset var stMetadata = structnew() />
		
		<cfloop list='#arguments.keys#' index="item">
			<cfset stMetadata = getKeyMetadata(item) />
			<cfset stMetadata.translated = arguments.translated />
			<cfset this.metadata = addMetadata(this.metadata,stMetadata) />
		</cfloop>
		
	</cffunction>

	<cffunction name="saveResource" access="public" output="false" returntype="void" hint="Saves the current resource data (keys and metadata) to file">
		<cfset var resource = "" />
		<cfset var dirpart = "" />
		<cfset var dir = "" />
		
		<cfquery dbtype="query" name="this.metadata">
			select	*
			from	this.metadata
			order by	[group], rbkey
		</cfquery>
		
		<cfset resource = resource & "## @file          #this.cfile##chr(13)##chr(10)#" />
		<cfset resource = resource & "## @fileEncoding  UTF-8#chr(13)##chr(10)#" />
		<cfset resource = resource & "## @fileLanguage  #this.language##chr(13)##chr(10)#" />
		<cfset resource = resource & "## @fileCountry   #this.country##chr(13)##chr(10)#" />
		<cfset resource = resource & "## @fileVariant   #chr(13)##chr(10)#" />
		<cfset resource = resource & "## @fileManager   #this.manager##chr(13)##chr(10)#" />
		<cfset resource = resource & "## @fileComment   #this.comment##chr(13)##chr(10)#" />
		<cfset resource = resource & "#chr(13)##chr(10)#" />
		
		<cfoutput query="this.metadata" group="group">
			<!--- Output group information --->
			<cfif len(group)>
				<cfset resource = resource & "## @group #group##chr(13)##chr(10)#" />
				<cfset resource = resource & "###chr(13)##chr(10)#" />
				<cfset resource = resource & "## @groupComment #groupComment##chr(13)##chr(10)#" />
				<cfset resource = resource & "###chr(13)##chr(10)#" />
			</cfif>
			
			<!--- Output keys --->
			<cfoutput>
				<!--- Metadata --->
				<cfset resource = resource & "## @translated #translated# @created #dateformat(created,'yyyy-mm-dd')# @modified #dateformat(modified,'yyyy-mm-dd')# @createdby #creator# @modifier #modifier##chr(13)##chr(10)#" />
				<cfset resource = resource & "## @comment #comment##chr(13)##chr(10)#" />
				
				<!--- Key --->
				<cfset resource = resource & escape(rbkey) & "=" & escape(this.bundle[rbkey]) & "#chr(13)##chr(10)##chr(13)##chr(10)#" />
			</cfoutput>
		</cfoutput>
		
		<cfloop list="#this.file#" index="dirpart">
			<cfset dir = dir & dirpart & "/" />
			<cfif not find(".properties",dirpart) and not directoryexists(dir)>
				<cfdirectory action="create" directory="#dir#" />
			</cfif>
		</cfloop>
		
		<cfset this.changed = false />
		
		<cfif not directoryexists(getdirectoryfrompath(this.file))>
			<cfdirectory action="create" directory="#getdirectoryfrompath(this.file)#" />
		</cfif>
		<cffile action="write" charset="utf-8" file="#this.file#" output="#resource#" />
	</cffunction>
	
	<!--- ========= METADATA PARSING ========== --->
	<cffunction name="parseComment" access="private" output="false" returntype="struct" hint="Parses a resource bundle string and returns a struct containing variables and values">
		<cfargument name="comment" type="string" required="true" />
	
		<cfset var stResult = structnew() />
		
		<!--- Processing variables --->
		<cfset var i = 0 />
		<cfset var value = "" />
		
		<cfset arguments.comment = trim(arguments.comment) />
		<cfset arguments.comment = listtoarray(arguments.comment,"@") />
		
		<cfloop from="1" to="#arraylen(arguments.comment)#" index="i">
			<cfif not listcontains("##,!",left(trim(arguments.comment[i]),1))>
				<cfset stResult[listfirst(arguments.comment[i]," ")]=listrest(arguments.comment[i]," ") />
			</cfif>
		</cfloop>
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="parseKey" access="private" returntype="string" hint="Returns the key portion of a string">
		<cfargument name="line" type="string" required="true" />
		
		<cfif refind("[^\\](=|:| )",arguments.line)>
			<cfreturn replace(left(arguments.line,refind("[^\\](=|:| )",arguments.line)),"\","","ALL") />
		<cfelse>
			<cfthrow message="This is not a key=value string" />
		</cfif>
	</cffunction>

	<cffunction name="escape" access="private" output="false" returntype="string" hint="Escapes a string to be stored in a properties file">
		<cfargument name="in" type="string" required="true" hint="The string to be escaped" />
		
		<cfset var out = arguments.in />
		
		<cfset out = replace(out,"\","\\","ALL") />
		<cfset out = replacelist(out,"#chr(9)#,#chr(10)#,#chr(12)#,#chr(13)#,"",',=,:, ,##,!","\t,\n,\f,\r,\"",\',\=,\:,\ ,\##,\!") />
		
		<cfreturn out />
	</cffunction>
	
</cfcomponent>