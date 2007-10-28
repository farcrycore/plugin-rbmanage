<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<cfparam name="url.report" default="reportmissing">

<!--- set up page header --->
<admin:header title="Report" />

<cfset columns = application.rb.getReportColumns(url.report) />
	
<skin:htmlHead library="extjs" />
<skin:htmlHead><cfoutput>
	<script type="text/javascript" src="#application.url.farcry#/js/ext/custom/ColumnNodeUI.js"></script>
	<link type="text/css" rel="stylesheet" href="#application.url.farcry#/js/ext/custom/ColumnNodeUI.css" />
	<script type="text/javascript">
		Ext.onReady(function(){
		    var tree = new Ext.tree.ColumnTree({
		        el:'rbtree',
		        width:#columns.width+2#,
		        autoHeight:true,
		        rootVisible:false,
		        autoScroll:true,
		        title: '#application.rb.getReportTitle(url.report)#',
		        
		        columns:#columns.json#,
		
		        loader: new Ext.tree.TreeLoader({
		            dataUrl:'/farcry/admin/customadmin.cfm?plugin=rbmanage&module=jsondata.cfm&report=#url.report#',
		            uiProviders:{
		                'col': Ext.tree.ColumnNodeUI
		            }
		        }),
		
		        root: new Ext.tree.AsyncTreeNode({
		            text:'Keys',
					draggable:false,
					id:'root'
		        })
		    });
		    tree.render();
		});
	</script>
</cfoutput></skin:htmlHead>

<cfif structkeyexists(url,"reprocess")>
	<cfoutput>
	 	<p class="success">Reports updated: #application.rb.processLog()#</p>
	 </cfoutput>
</cfif>

<ft:form method="get">
	<cfoutput>
		<input type="hidden" name="plugin" value="#url.plugin#" />
		<input type="hidden" name="module" value="#url.module#" />
		<select name="report">
	</cfoutput>
	
	<cfloop list="#application.rb.getReportList()#" index="reportname">
		<cfoutput>
			<option value="#listfirst(reportname,':')#"<cfif listfirst(reportname,":") eq url.report> selected</cfif>>#listlast(reportname,':')#</option>
		</cfoutput>
	</cfloop>
	
	<cfoutput>
		</select>
	</cfoutput>
	
	<ft:farcrybuttonPanel>
		<ft:farcrybutton value="Go to report" />
	</ft:farcrybuttonPanel>
</ft:form>

<cfoutput>
	<br/>
</cfoutput>

<ft:processform action="Update resource with defaults">
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

<ft:form action="#cgi.SCRIPT_NAME#?plugin=#url.plugin#&module=#url.module#&report=#url.report#">

<cfoutput>
	<div id="rbtree">
	</div>
</cfoutput>
		
	<ft:farcrybuttonPanel>
		<!--- Select bundle --->
		<cfoutput>
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
		</cfoutput>
		
		<!--- Select locale --->
		<cfoutput>
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
			<label><input type="checkbox" name="translated" value="1" /> Mark as translated</label>
		</cfoutput>
		
		<ft:farcryButton value="Update resource with defaults" />
	</ft:farcrybuttonPanel>

</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />