/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.menu.ColorItem=function(config){Ext.menu.ColorItem.superclass.constructor.call(this,new Ext.ColorPalette(config),config);this.palette=this.component;this.relayEvents(this.palette,["select"]);if(this.selectHandler){this.on('select',this.selectHandler,this.scope);}};Ext.extend(Ext.menu.ColorItem,Ext.menu.Adapter);