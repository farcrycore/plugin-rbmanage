<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Save resource bundles" />

<cfoutput>
	<link rel="stylesheet" type="text/css" href="/js/rbmanage/extjs-2-0-0/resources/css/ext-all.css" />
	<link rel="stylesheet" type="text/css" href="/js/rbmanage/extjs-2-0-0/resources/css/xtheme-gray.css" />
	<style type="text/css">
		/*
		 * Ext JS Library 2.0 Dev 5
		 * Copyright(c) 2006-2007, Ext JS, LLC.
		 * licensing@extjs.com
		 * 
		 * This code has not yet been licensed for use.
		 */
		
		.x-column-tree .x-tree-node {
		    zoom:				1;
		    background-image:	none;
		}
		.x-column-tree .x-tree-node-el {
		    /*border-bottom:1px solid ##eee; borders? */
		    zoom:				1;
		}
		.x-column-tree .x-tree-selected {
		    background: 		##d9e8fb;
		}
		.x-column-tree  .x-tree-node a {
		    line-height:		18px;
		    vertical-align:		middle;
		}
		.x-column-tree  .x-tree-node a span{
			
		}
		.x-column-tree  .x-tree-node .x-tree-selected a span{
			background:			transparent;
			color:				##000;
		}
		.x-tree-col {
		    float:				left;
		    overflow:			hidden;
		    padding:			0 1px;
		    zoom:				1;
		}
		
		.x-tree-col-text, .x-tree-hd-text {
		    overflow:			hidden;
		    -o-text-overflow: 	ellipsis;
			text-overflow: 		ellipsis;
		    padding:			3px 3px 3px 5px;
		    white-space: 		nowrap;
		    font:				normal 11px arial, tahoma, helvetica, sans-serif;
		    background:			transparent none;
		}
		
		.x-tree-headers {
		    background: 		##f9f9f9 url(/js/rbmanage/extjs-2-0-0/resources/images/default/grid/grid3-hrow.gif) repeat-x 0 bottom;
			cursor:				default;
		    zoom:				1;
		}
		
		.x-tree-hd {
		    float:				left;
		    overflow:			hidden;
		    border-left:		1px solid ##eee;
		    border-right:		1px solid ##d0d0d0;
		    background:			transparent;
		}
	</style>
	<script type="text/javascript" src="/js/rbmanage/extjs-2-0-0/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="/js/rbmanage/extjs-2-0-0/ext-all.js"></script>
	<script type="text/javascript" src="/js/rbmanage/ColumnNodeUI.js"></script>
	
	<script type="text/javascript">
		Ext.onReady(function(){
		    var tree = new Ext.tree.ColumnTree({
		        el:'bundletree',
		        width:302,
		        autoHeight:true,
		        rootVisible:false,
		        autoScroll:true,
		        title: 'Save resources',
		        
		        columns: [{ 'header' : 'Resource', 'width' : 200, 'dataIndex' : 'text' },{ 'header' : 'Status', 'width' : 100, 'dataIndex' : 'status' }],
		
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
	<div id="bundletree">
	</div>
</cfoutput>
	
	<ft:farcrybuttonpanel>
		<ft:farcrybutton value="Save" />
	</ft:farcrybuttonpanel>

</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />