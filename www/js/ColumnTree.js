/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */

Ext.onReady(function(){
    var tree = new Ext.tree.ColumnTree({
        el:'rbtree',
        width:552,
        autoHeight:true,
        rootVisible:false,
        autoScroll:true,
        title: 'Resource Log Report',
        
        columns:[{
            header:'Key',
            width:350,
            dataIndex:'text'
        },{
            header:'Total',
            width:100,
            dataIndex:'total'
        },{
            header:'Default',
            width:100,
            dataIndex:'defaultvalue'
        }],

        loader: new Ext.tree.TreeLoader({
            dataUrl:'/farcry/admin/customadmin.cfm?module=jsondata.cfm&plugin=rbmanage',
            uiProviders:{
                'col': Ext.tree.ColumnNodeUI
            }
        }),

        root: new Ext.tree.AsyncTreeNode({
            text:'Keys',
			draggable:false,
			id:'keyroot'
        })
    });
    tree.render();
});