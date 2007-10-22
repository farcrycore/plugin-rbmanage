/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.menu.DateItem=function(config){Ext.menu.DateItem.superclass.constructor.call(this,new Ext.DatePicker(config),config);this.picker=this.component;this.addEvents({select:true});this.picker.on("render",function(picker){picker.getEl().swallowEvent("click");picker.container.addClass("x-menu-date-item");});this.picker.on("select",this.onSelect,this);};Ext.extend(Ext.menu.DateItem,Ext.menu.Adapter,{onSelect:function(picker,date){this.fireEvent("select",this,date,picker);Ext.menu.DateItem.superclass.handleClick.call(this);}});