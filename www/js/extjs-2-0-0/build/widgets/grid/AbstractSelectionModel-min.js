/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.grid.AbstractSelectionModel=function(){this.locked=false;Ext.grid.AbstractSelectionModel.superclass.constructor.call(this);};Ext.extend(Ext.grid.AbstractSelectionModel,Ext.util.Observable,{init:function(grid){this.grid=grid;this.initEvents();},lock:function(){this.locked=true;},unlock:function(){this.locked=false;},isLocked:function(){return this.locked;}});