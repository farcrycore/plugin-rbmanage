/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.menu.DateMenu=function(config){Ext.menu.DateMenu.superclass.constructor.call(this,config);this.plain=true;var di=new Ext.menu.DateItem(config);this.add(di);this.picker=di.picker;this.relayEvents(di,["select"]);this.on('beforeshow',function(){if(this.picker){this.picker.hideMonthPicker(true);}},this);};Ext.extend(Ext.menu.DateMenu,Ext.menu.Menu,{cls:'x-date-menu'});