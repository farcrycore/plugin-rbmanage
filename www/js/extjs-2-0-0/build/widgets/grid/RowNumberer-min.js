/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.grid.RowNumberer=function(config){Ext.apply(this,config);if(this.rowspan){this.renderer=this.renderer.createDelegate(this);}};Ext.grid.RowNumberer.prototype={header:"",width:23,sortable:false,fixed:true,dataIndex:'',id:'numberer',rowspan:undefined,renderer:function(v,p,record,rowIndex){if(this.rowspan){p.cellAttr='rowspan="'+this.rowspan+'"';}
return rowIndex+1;}};