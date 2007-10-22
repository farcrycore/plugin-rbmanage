/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.layout.ColumnLayout=Ext.extend(Ext.layout.ContainerLayout,{monitorResize:true,extraCls:'x-column',isValidParent:function(c,target){return c.getEl().dom.parentNode==this.innerCt.dom;},onLayout:function(ct,target){var cs=ct.items.items,len=cs.length,c,i;if(!this.innerCt){target.addClass('x-column-layout-ct');this.innerCt=target.createChild({cls:'x-column-inner'});this.renderAll(ct,this.innerCt);this.innerCt.createChild({cls:'x-clear'});}
var size=target.getViewSize();if(size.width<20||size.height<20){return;}
var w=size.width-target.getPadding('lr'),h=size.height-target.getPadding('tb'),pw=w;this.innerCt.setWidth(w);for(i=0;i<len;i++){c=cs[i];if(!c.columnWidth){pw-=(c.getSize().width+c.getEl().getMargins('lr'));}}
pw=pw<0?0:pw;for(i=0;i<len;i++){c=cs[i];if(c.columnWidth){c.setSize(Math.floor(c.columnWidth*pw)-c.getEl().getMargins('lr'));}}}});Ext.Container.LAYOUTS['column']=Ext.layout.ColumnLayout;