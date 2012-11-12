<cfcomponent displayname="Save Bundles" hint="Saves the selected bundles to file" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="keys" ftLabel="Bundles" type="string" ftType="list" />
	
	
	<cffunction name="ftEditKeys" access="public" returntype="string" description="This will return a string of formatted HTML text to enable the editing of the property" output="false">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">
		
		<cfset var html = "" />
		<cfset var bundleindex = "" />
		<cfset var changed = "" />
		<cfset var status = "" />
		
		<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
		
		<skin:loadJS id="jquery" />
		<skin:loadJS id="jquery-treeTable" basehref="/farcry/plugins/rbmanage/www/treeTable/javascripts/" lFiles="jquery.treeTable.js" />
		<skin:loadCSS id="jquery-treeTable" basehref="/farcry/plugins/rbmanage/www/treeTable/stylesheets/" lFiles="jquery.treeTable.css" />
 		<skin:htmlHead><cfoutput>
			<style type="text/css">
				##tree { width:250px; }
					.select-header, .select-value { padding-left:20px; }
					.bundle-header, .bundle-value { width:200px; }
					.status-modified { color:red; }
					.status-unmodified { color:green; }
			</style>
		</cfoutput></skin:htmlHead>
		
		<cfsavecontent variable="html"><cfoutput>
			<table id="tree">
				<thead>
					<tr class="ui-widget-header">
						<th class="select-header"></th>
						<th class="bundle-header">Bundle</th>
					</tr>
				</thead>
				<tbody>
			</cfoutput>
			
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
				
				<cfoutput>
					<tr id='#listgetat(application.rb.lSets,bundleindex)#' class='ui-widget-content status-#status#'>
						<td class='select-value'><input type='checkbox' name='#arguments.fieldname#' value='#listgetat(application.rb.lSets,bundleindex)#' /></td>
						<td>#application.fc.lib.rb.getLocationLabel(listgetat(application.rb.lSets,bundleindex))#</td>
					</tr>
				</cfoutput>
				
				<cfloop collection="#application.rb.aSets[bundleindex]#" item="locale">
					<cfif application.rb.aSets[bundleindex][locale].changed>
						<cfset status = "modified" />
					<cfelse>
						<cfset status = "unmodified" />
					</cfif>
					
					<cfoutput>
						<tr id='#listgetat(application.rb.lSets,bundleindex)#-#locale#' class='ui-widget-content child-of-#listgetat(application.rb.lSets,bundleindex)# status-#status#'>
							<td class='select-value'><input type='checkbox' name='#arguments.fieldname#' value='#listgetat(application.rb.lSets,bundleindex)#:#locale#' /></td>
							<td>#application.fc.lib.rb.getLocaleLabel(locale)#</td>
						</tr>
					</cfoutput>
				</cfloop>
			</cfloop>
			
			<cfoutput>
				</tbody>
			</table>
			<script language="javascript">
				$j("##tree").treeTable();
				<cfif not structkeyexists(arguments.stMetadata,"ajaxrequest") or not arguments.stMetadata.ajaxrequest>
					// Make visible that a row is clicked
					$j("input[name=keys]").live("change",function() {
						var fn = (this.checked ? "addClass" : "removeClass");
						var nodes =  [ $j(this).parents("tr.ui-widget-content")[fn]("checked") ];
						
						while (nodes.length) {
							var nodeset = nodes.shift();console.log(nodeset);
							nodeset[fn]("ui-state-highlight");
							nodeset.each(function(){
								nodes.push($j("tr.child-of-"+this.id).not(".checked"));
							});
						}
					});
				</cfif>
			</script>
		</cfoutput></cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	
	<cffunction name="process" access="public" output="false" returntype="struct">
		<cfargument name="stProperties" type="struct" required="true" />
		
		<cfset var key = "" />
		<cfset var localeNames = application.i18nUtils.getLocaleNames() />
		<cfset var aVars = arraynew(1) />
		
		<cfloop list="#arguments.stProperties.keys#" index="key">
			<cfset aVars = arraynew(1) />
			
			<cfif find(":",key)>
				<cfset application.rb.saveResource(listfirst(key,":"),listlast(key,":")) />
				<cfset aVars[2] = application.fc.lib.rb.getLocaleLabel(listlast(key,":")) /><!--- Locale name --->
				<cfset aVars[1] = application.fc.lib.rb.getLocationLabel(listfirst(key,":")) /><!--- Bundle name --->
				
				<skin:bubble message="#application.fapi.getResource(key='rbmanage.messages.savebundlesmany@text',default='{1} has been saved to {2}',substituteValues=aVars)#" />
			<cfelse>
				<cfset application.rb.saveResource(key) />
				<cfset aVars[1] = application.fc.lib.rb.getLocationLabel(key) /><!--- Bundle name --->
				
				<skin:bubble message="#application.fapi.getResource(key='rbmanage.messages.savebundlesone@text',default='All locales have been saved to {1}',substituteValues=aVars)#" />
			</cfif>
			
		</cfloop>
	
		<cfreturn arguments.stProperties />
	</cffunction>
	
</cfcomponent>