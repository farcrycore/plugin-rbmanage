<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Save resource bundles" />

<skin:htmlHead library="extjs" />
<skin:htmlHead><cfoutput>
	<script type="text/javascript" src="#application.url.farcry#/js/ext/custom/ColumnNodeUI.js"></script>
	<link type="text/css" rel="stylesheet" href="#application.url.farcry#/js/ext/custom/ColumnNodeUI.css" />
	<script type="text/javascript">
		Ext.onReady(function(){
		    var tree = new Ext.tree.ColumnTree({
		        el:'bundletree',
		        width:302,
		        autoHeight:true,
		        rootVisible:false,
		        autoScroll:true,
		        title: 'Save resources',
		        
		        
		
		        loader: new Ext.tree.TreeLoader({
		            dataUrl:'/farcry/admin/customadmin.cfm?plugin=rbmanage&module=bundlesjson.cfm',
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
	<div id="bundletree">
	</div>
</cfoutput>
	
	<ft:farcrybuttonpanel>
		<ft:farcrybutton value="Save" />
	</ft:farcrybuttonpanel>

</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />