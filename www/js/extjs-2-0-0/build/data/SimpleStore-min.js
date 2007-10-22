/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.data.SimpleStore=function(config){Ext.data.SimpleStore.superclass.constructor.call(this,Ext.apply(config,{reader:new Ext.data.ArrayReader({id:config.id},Ext.data.Record.create(config.fields))}));};Ext.extend(Ext.data.SimpleStore,Ext.data.Store,{loadData:function(data,append){if(this.expandData===true){var r=[];for(var i=0,len=data.length;i<len;i++){r[r.length]=[data[i]];}
data=r;}
Ext.data.SimpleStore.superclass.loadData.call(this,data,append);}});