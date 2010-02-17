<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<!--- set up page header --->
<admin:header title="Save resource bundles" />

<skin:loadJS id="jquery" />
<skin:loadJS id="jquery-treeTable" basehref="#application.url.webroot#/rbmanage/treeTable/javascripts/" lFiles="jquery.treeTable.js" />
<skin:loadCSS id="jquery-treeTable" basehref="#application.url.webroot#/rbmanage/treeTable/stylesheets/" lFiles="jquery.treeTable.css" />
<skin:htmlHead><cfoutput>
	<script type="text/javascript">
		
		$j(function(){
			$("##tree tbody").html("<tr><td colspan='2'>Loading data...</td></tr>").load("#application.url.webtop#/admin/customadmin.cfm?plugin=rbmanage&module=ajax/trbundles.cfm",function(responseText){
				$("##tree").treeTable();
			});
			
			// Make visible that a row is clicked
			$("input[name=keys]").live("change",function() {
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
		});
	</script>
	<style type="text/css">
		##tree { width:250px; }
			.select-header, .select-value { padding-left:20px; }
			.bundle-header, .bundle-value { width:200px; }
			.status-modified { color:red; }
			.status-unmodified { color:green; }
	</style>
</cfoutput></skin:htmlHead>

<cfoutput>
	<h1>Reports</h1>
</cfoutput>

<ft:processform action="Save">
	<cfloop list="#form.keys#" index="key">
		<cfif find(":",key)>
			<cfset application.rb.saveResource(listfirst(key,":"),listlast(key,":")) />
		<cfelse>
			<cfset application.rb.saveResource(key) />
		</cfif>
	</cfloop>
</ft:processform>

<ft:form>
	<cfoutput>
		<fieldset class="fieldset">
			<h2 class="legend">Save Bundles</h2>
			<div class="ctrlHolder inlineLabels list" >
				<label for="report" class="label">Bundles</label>
				<div class="multiField">
					<table id="tree">
						<thead>
							<tr class="ui-widget-header">
								<th class="select-header"></th>
								<th class="bundle-header">Bundle</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
				<br style="clear:both;">
			</div>
		</fieldset>
</cfoutput>
	
	<ft:buttonPanel>
		<ft:button value="Save" />
	</ft:buttonPanel>

</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />