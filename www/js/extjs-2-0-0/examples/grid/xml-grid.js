/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */

Ext.onReady(function(){

    // create the Data Store
    var ds = new Ext.data.Store({
        // load using HTTP
        url: 'sheldon.xml',

        // the return will be XML, so lets set up a reader
        reader: new Ext.data.XmlReader({
               // records will have an "Item" tag
               record: 'Item',
               id: 'ASIN',
               totalRecords: '@total'
           }, [
               // set up the fields mapping into the xml doc
               // The first needs mapping, the others are very basic
               {name: 'Author', mapping: 'ItemAttributes > Author'},
               'Title', 'Manufacturer', 'ProductGroup'
           ])
    });

    var cm = new Ext.grid.ColumnModel([
	    {header: "Author", width: 120, dataIndex: 'Author'},
		{header: "Title", width: 180, dataIndex: 'Title'},
		{header: "Manufacturer", width: 115, dataIndex: 'Manufacturer'},
		{header: "Product Group", width: 100, dataIndex: 'ProductGroup'}
	]);
    cm.defaultSortable = true;

    // create the grid
    var grid = new Ext.grid.GridPanel({
        ds: ds,
        cm: cm,
        renderTo:'example-grid',
        width:540,
        height:200
    });

    ds.load();
});