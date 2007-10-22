
<cfimport prefix="ft" taglib="/farcry/core/tags/formtools" />

<cfimport taglib="/farcry/core/tags/extjs" prefix="extjs" />


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Grid3 Example</title>

    <link rel="stylesheet" type="text/css" href="../../resources/css/ext-all.css" />

    <!-- GC -->
 	<!-- LIBS -->
 	<script type="text/javascript" src="../../adapter/ext/ext-base.js"></script>
 	<!-- ENDLIBS -->

    <script type="text/javascript" src="../../ext-all.js"></script>


    <script type="text/javascript" src="RowExpander.js"></script>

    <link rel="stylesheet" type="text/css" href="grid-examples.css" />


    <style type="text/css">

        .icon-grid {
            background-image:url(../shared/icons/fam/grid.png) !important;
        }
	
        .add {
            background-image:url(../shared/icons/fam/add.gif) !important;
        }
        .option {
            background-image:url(../shared/icons/fam/plugin.gif) !important;
        }
        .remove {
            background-image:url(../shared/icons/fam/delete.gif) !important;
        }
        .save {
            background-image:url(../shared/icons/save.gif) !important;
        }
    </style>
</head>
<body>
<!--- <script type="text/javascript" src="../examples.js"></script><!-- EXAMPLES --> --->
<h1>GridView3 Example</h1>

<p>
selections.each(function(s){
    			s.set('completed', true);
    		});
</p>

<p>var selectionModel = grid.getSelectionModel();
var record = selectionModel.getSelected();
alert(record.data['is_folder']);</p>

<cfquery datasource="farcry_agora" name="qTimesheets">
SELECT * FROM crmTimesheet
</cfquery>
<cfdump var="#qTimesheets#" expand="false" label="qTimesheets" />

<!--- <cfform>
<cfgrid query="qTimesheets" pagesize="10" name="timesheetGrid" format="flash">
	<cfgridcolumn >
</cfgrid>
</cfform> --->
<ft:form Validation="false">

<script type="text/javascript">
/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */





Ext.onReady(function(){

    Ext.QuickTips.init();
    
    var xg = Ext.grid;
    // create the Data Store
    
	 var t = new Ext.Template(
	 	
	    '<div>this is a template...{title}'
	);
    
    var ds = new Ext.data.GroupingStore({
        // load using script tags for cross domain, if the data in on the same domain as
        // this page, an HttpProxy would be better
        // load using HTTP
        url: 'topics-remote.cfm',
        remoteSort: true,
        sortInfo: {field: "worktype", direction: "ASC"},
        <!--- baseParams: {start:0,limit:10}, --->
		groupField:'worktype',
        // create reader that reads the Topic records
        reader: new Ext.data.JsonReader({
            root: 'records',
            totalProperty: 'recordcount',
            id: 'objectid'
	        }, [
	            {name: 'title', mapping: 'title'} ,
	            {name: 'worktype', mapping: 'worktype'} ,
	            {name: 'note', mapping: 'note'},
	            {name: 'timeEntered', mapping: 'timeEntered', type: 'date', dateFormat: 'timestamp'},
	            {name: 'hours', mapping: 'hours', type: 'float'},
	            {name: 'ticketNumber', mapping: 'ticketNumber'},
	            {name: 'profileID', mapping: 'profileID'}
	        ]),
        // turn on remote sorting
        remoteSort: true
    });
   	ds.setDefaultSort("worktype","ASC"); 
    
    var sm = new xg.CheckboxSelectionModel();

        
        // the column model has information about grid columns
    // dataIndex maps the column to the specific data field in
    // the data store
    var cm = new Ext.grid.ColumnModel([sm,

    	{
           id: 'topic', // id assigned so we can apply custom css (e.g. .x-grid-col-topic b { color:#333 })
           header: "Topic",
           dataIndex: 'title',
           width: 490,
           renderer: renderTopicPlain,
           css: 'white-space:normal;',
           sortable: true
        } ,{
           header: "Work Type",
           dataIndex: 'worktype',
           width: 100,
           sortable:true
        }<!---,{
           id: 'last',
           header: "Last Post",
           dataIndex: 'lastPost',
           width: 150,
           renderer: renderLast 
        } --->]);
        
        
    // pluggable renders
    function renderTopic(value, p, record){
        return String.format('<b>{0}</b>', value, record.data['note']);
         	
    }
    function renderTopicPlain(value,p,record){
        //return String.format('<b><i>{0}</i></b>', value);
        <!--- alert(Ext.urlEncode(record.data));
        debugger; --->
        return t.applyTemplate(record.data);
    }
    function renderLast(value, p, record){
        return String.format('{0}<br/>by {1}', value);
        <!--- return String.format('{0}<br/>by {1}', value.dateFormat('M j, Y, g:i a'), record.data['author']); --->
    }
    function renderLastPlain(value){
        return value;
    }

    ////////////////////////////////////////////////////////////////////////////////////////
    // Grid 4
    ////////////////////////////////////////////////////////////////////////////////////////

	var editWin;
	var editWin2;

    var grid = new xg.GridPanel({
        id:'button-grid',
		ds: ds,
		cm: cm,
        sm: sm,
        view: new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        }),
        viewConfig: {
            forceFit:true
        },

        // inline buttons
        buttons: [
        	{
        		text:'Save'
        		,tooltip:'Add a new row'
        		,iconCls:'add'
        		,type:'submit'
        		,handler: function(){
        			//alert(sm.getSelections());
        			alert(sm.getCount());
					alert(sm.getSelected().data['title']);        			
	           		<!--- <cfoutput>Ext.getDom('#request.farcryform.name#').submit();</cfoutput> --->
	        	}
        	}
        	,{text:'Cancel'}
        	,{text:'Approve'}
        	,{text:'Delete'}
        ],
        buttonAlign:'left',

        // inline toolbars
        tbar:[{
            text:'Edit',
            tooltip:'Add a new row',
            iconCls:'edit',
            type:'submit',
            handler: function(){
		        if(!editWin){
		            editWin = new Ext.Window({
		                el:'hello-win',
		                layout:'fit',
		                width:500,
		                height:300,
		                closeAction:'hide',
		                plain: true,
		                 
		                items: new Ext.TabPanel({
		                    el: 'hello-tabs',
		                    autoTabs:true,
		                    activeTab:0,
		                    deferredRender:false,
		                    border:false
		                }),
		
		                buttons: [{
		                    text:'Submit',
		                    disabled:true
		                },{
		                    text: 'Close',
		                    handler: function(){
		                        editWin.hide();
		                    }
		                }, {
		                    text: 'Pop Another',
		                    handler: function(){

						        if(!editWin2){
						            editWin2 = new Ext.Window({
						                el:'hello-win2',
						                layout:'fit',
						                width:500,
						                height:300,
						                closeAction:'hide',
						                plain: true,
						                 
						                items: new Ext.TabPanel({
						                    el: 'hello-tabs2',
						                    autoTabs:true,
						                    activeTab:0,
						                    deferredRender:false,
						                    border:false
						                }),
						
						                buttons: [{
						                    text:'Submit',
						                    disabled:true
						                },{
						                    text: 'Close',
						                    handler: function(){
						                        editWin2.hide();
						                    }
						                }, {
						                    text: 'Pop Another',
						                    handler: function(){
						                        alert('pop another');
						                    }
						                }]
						            });
						        }
						        editWin.show(this); 



		                    }
		                }]
		            });
		        }
		        editWin.show(this);            	
           	 	<!--- <cfoutput>Ext.getDom('#request.farcryform.name#').submit();</cfoutput> --->
        	}
        }, '-', {
            text:'Options',
            tooltip:'Blah blah blah blaht',
            iconCls:'option'
        },'-',{
            text:'Remove Something',
            tooltip:'Remove the selected item',
            iconCls:'remove'
        }],
        
        <cfset pageSize = "10" />
        
        bbar: new Ext.PagingToolbar({
            <cfoutput>pageSize: #pageSize#,</cfoutput>
            store: ds,
            displayInfo: true,
            displayMsg: 'Displaying topics {0} - {1} of {2}',
            emptyMsg: "No topics to display",
            items:[
                '-', {
                pressed: false,
                enableToggle:true,
                text: 'Show Details',
                cls: 'x-btn-text-icon details',
                toggleHandler: toggleDetails 
            }]
        }),

        width:800,
        height:600,
        frame:true,
        title:'Support for standard Panel features such as framing, buttons and toolbars',
        iconCls:'icon-grid',
        renderTo: document.body
    });
    

    
     function toggleDetails(btn, pressed){
        cm.getColumnById('topic').renderer = pressed ? renderTopic : renderTopicPlain;
        grid.getView().refresh();
    }
     
     // trigger the data store load
   <cfoutput> ds.load({params:{start:0, limit:#pageSize#}});</cfoutput>
    
    
});




    
</script>

</ft:form>

<div id="hello-win" class="x-hidden">
	<div id="hello-tabs"></div>
</div>	

<div id="hello-win2" class="x-hidden">
	<div id="hello-tabs2"></div>
</div>	



</body>
</html>
