/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.grid.GridEditor=function(field,config){Ext.grid.GridEditor.superclass.constructor.call(this,field,config);field.monitorTab=false;};Ext.extend(Ext.grid.GridEditor,Ext.Editor,{alignment:"tl-tl",autoSize:"width",hideEl:false,cls:"x-small-editor x-grid-editor",shim:false,shadow:false});