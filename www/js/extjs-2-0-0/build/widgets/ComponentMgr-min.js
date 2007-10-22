/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.ComponentMgr=function(){var all=new Ext.util.MixedCollection();var types={};return{register:function(c){all.add(c);},unregister:function(c){all.remove(c);},get:function(id){return all.get(id);},onAvailable:function(id,fn,scope){all.on("add",function(index,o){if(o.id==id){fn.call(scope||o,o);all.un("add",fn,scope);}});},all:all,registerType:function(xtype,cls){types[xtype]=cls;},create:function(config,defaultType){return new types[config.xtype||defaultType](config);}};}();Ext.reg=Ext.ComponentMgr.registerType;