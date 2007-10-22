/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.layout.FitLayout=Ext.extend(Ext.layout.ContainerLayout,{monitorResize:true,onLayout:function(ct,target){Ext.layout.FitLayout.superclass.onLayout.call(this,ct,target);this.setItemSize(this.activeItem||ct.items.itemAt(0),target.getStyleSize());},setItemSize:function(item,size){if(item){item.setSize(size);}}});Ext.Container.LAYOUTS['fit']=Ext.layout.FitLayout;