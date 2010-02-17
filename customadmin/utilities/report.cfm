<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<cfparam name="url.report" default="reportmissing">

<cfset stCols = application.rb.getReportColumns(report=url.report,format='query') />

<admin:header />

<skin:loadJS id="jquery" />
<skin:loadJS id="jquery-treeTable" basehref="#application.url.webroot#/rbmanage/treeTable/javascripts/" lFiles="jquery.treeTable.js" />
<skin:loadCSS id="jquery-treeTable" basehref="#application.url.webroot#/rbmanage/treeTable/stylesheets/" lFiles="jquery.treeTable.css" />
<skin:htmlHead><cfoutput>
	<script type="text/javascript">
		
		$j(function(){
			$("##tree tbody").html("<tr><td colspan='#stCols.columns.recordcount+2#'>Loading data...</td></tr>").load("#application.url.webtop#/admin/customadmin.cfm?plugin=rbmanage&module=ajax/trdata.cfm&report=#url.report#",function(responseText){
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
		##tree { width:#stCols.width+16#px; }
			td.icon-value { padding-left:20px; }
			.select-header, .select-value { width:20px; }
			<cfloop query="stCols.columns">
				.#stCols.columns.dataIndex#-header, .#stCols.columns.dataIndex#-value { width:#stCols.columns.width#px; padding-left:2px; }
			</cfloop>
	</style>
</cfoutput></skin:htmlHead>

<cfoutput>
	<h1>Reports</h1>
</cfoutput>

<ft:processform action="Update Bundle">
	<cfparam name="form.translated" default="0" />
	<cfset updates = application.rb.setKeys(form.bundle,form.locale,application.rb.getKeys(url.report,form.keys),form.translated) />
	<cfoutput>
		<p class="success">
			Keys added: #listlen(updates.added)#<br/>
			Keys updates: #listlen(updates.updated)# (when updating a base resource, locale resources are marked as NOT translated)<br/>
			Keys deleted: #listlen(updates.deleted)#<br/>
			NOTE: Resource bundle changes have NOT been saved
		</p>
	</cfoutput>
</ft:processform>

<ft:form method="get">
	<cfoutput>
		<input type="hidden" name="plugin" value="#url.plugin#" />
		<input type="hidden" name="module" value="#url.module#" />
		<fieldset class="fieldset">
			<h2 class="legend">Select Report</h2>
			<div class="ctrlHolder inlineLabels list" >
				<label for="report" class="label">Report</label>
				<div class="multiField">
					<select name="report" id="report">
	</cfoutput>
	
	<cfloop list="#application.rb.getReportList()#" index="reportname">
		<cfoutput>
			<option value="#listfirst(reportname,':')#"<cfif listfirst(reportname,":") eq url.report> selected</cfif>>#listlast(reportname,':')#</option>
		</cfoutput>
	</cfloop>
	
	<cfoutput>
					</select>
				</div>
				<br style="clear:both;">
			</div>
		</fieldset>
	</cfoutput>
	
	<ft:buttonPanel>
		<ft:button value="Run Report" />
	</ft:buttonPanel>
</ft:form>

<ft:form>
	<cfoutput>
		<fieldset class="fieldset">
			<h2 class="legend">#application.rb.getReportTitle(url.report)#</h2>
			<div class="ctrlHolder inlineLabels list" >
				<label for="report" class="label">Results</label>
				<div class="multiField">
					<table id="tree">
						<thead>
							<tr class="ui-widget-header">
								<th class="icon-header"></th>
								<th class="select-header"></th>
								<cfloop query="stCols.columns">
									<th class="#stCols.columns.dataIndex#-header">#stCols.columns.header#</th>
								</cfloop>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
				<br style="clear:both;">
			</div>
		</fieldset>
		
		<fieldset class="fieldset">
			<h2 class="legend">Update Bundle</h2>
			<div class="ctrlHolder inlineLabels list" >
				<label for="bundle" class="label">Bundle</label>
				<div class="multiField">
					<!--- Select bundle --->
					<select name="bundle">
						<option value="project">Project</option>
	</cfoutput>
	
	<cfloop list="#application.plugins#" index="plugin">
		<cfoutput>
			<option value="#plugin#">#plugin#</option>
		</cfoutput>
	</cfloop>
		
	<cfoutput>
						<option value="core">Core</option>
					</select>
				</div>
				<br style="clear:both;">
			</div>
			<div class="ctrlHolder inlineLabels list" >
				<label for="locale" class="label">Locale</label>
				<div class="multiField">
					<!--- Select locale --->
						<select name="locale">
							<option value="base">Base resource</option>
	</cfoutput>
	
	<cfloop list="#application.locales#" index="locale">
		<cfoutput>
			<option value="#locale#">#locale#</option>
		</cfoutput>
	</cfloop>
					
	<cfoutput>
					</select>
				</div>
				<br style="clear:both;">
			</div>
			<div class="ctrlHolder inlineLabels boolean" >
				<label for="translated" class="label">Mark as Translated</label>
				<div class="multiField">
					<input type="checkbox" name="translated" value="1" /> Mark as translated</label>
				</div>
				<br style="clear:both;">
			</div>
		</fieldset>
	</cfoutput>
	
	<ft:buttonPanel>
		<ft:button value="Update Bundle" />
	</ft:buttonPanel>
</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />