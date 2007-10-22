/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.Viewport=Ext.extend(Ext.Container,{initComponent:function(){Ext.Viewport.superclass.initComponent.call(this);this.el=Ext.getBody();this.el.setHeight=Ext.emptyFn;this.el.setWidth=Ext.emptyFn;this.el.setSize=Ext.emptyFn;this.el.setStyle({overflow:'hidden',margin:'0',border:'0 none'});this.el.dom.scroll='no';this.allowDomMove=false;this.autoWidth=true;this.autoHeight=true;Ext.EventManager.onWindowResize(this.fireResize,this);this.renderTo=this.el;},fireResize:function(w,h){this.fireEvent('resize',this,w,h,w,h);}});Ext.reg('viewport',Ext.Viewport);