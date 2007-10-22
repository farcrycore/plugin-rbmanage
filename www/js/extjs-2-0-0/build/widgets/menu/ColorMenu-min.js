/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.menu.ColorMenu=function(config){Ext.menu.ColorMenu.superclass.constructor.call(this,config);this.plain=true;var ci=new Ext.menu.ColorItem(config);this.add(ci);this.palette=ci.palette;this.relayEvents(ci,["select"]);};Ext.extend(Ext.menu.ColorMenu,Ext.menu.Menu);