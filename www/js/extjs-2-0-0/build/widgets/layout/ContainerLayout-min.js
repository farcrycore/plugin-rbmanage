/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.layout.ContainerLayout=function(config){Ext.apply(this,config);};Ext.layout.ContainerLayout.prototype={monitorResize:false,activeItem:null,layout:function(){this.onLayout(this.container,this.container.getLayoutTarget());},onLayout:function(ct,target){this.renderAll(ct,target);},isValidParent:function(c,target){return c.getEl().dom.parentNode==target.dom;},renderAll:function(ct,target){var items=ct.items.items;for(var i=0,len=items.length;i<len;i++){var c=items[i];if(c&&(!c.rendered||!this.isValidParent(c,target))){this.renderItem(c,i,target);}}},renderItem:function(c,position,target){if(c&&!c.rendered){if(this.extraCls){c.addClass(this.extraCls);}
c.render(target,position);if(this.renderHidden&&c!=this.activeItem){c.hide();}}else if(c&&!this.isValidParent(c,target)){if(this.extraCls){c.addClass(this.extraCls);}
if(typeof position=='number'){position=target.dom.childNodes[position]||null;}
target.dom.insertBefore(c.getEl().dom,position);if(this.renderHidden&&c!=this.activeItem){c.hide();}}},onResize:function(){if(this.container.collapsed){return;}
var b=this.container.bufferResize;if(b){if(!this.resizeTask){this.resizeTask=new Ext.util.DelayedTask(this.layout,this);this.resizeBuffer=typeof b=='number'?b:100;}
this.resizeTask.delay(this.resizeBuffer);}else{this.layout();}},setContainer:function(ct){if(this.monitorResize){if(ct&&this.container&&ct!=this.container){this.container.un('resize',this.onResize,this);}
ct.on('resize',this.onResize,this);}
this.container=ct;},parseMargins:function(v){var ms=v.split(' ');var len=ms.length;if(len==1){ms[1]=ms[0];ms[2]=ms[0];ms[3]=ms[0];}
if(len==2){ms[2]=ms[0];ms[3]=ms[1];}
return{top:parseInt(ms[0],10)||0,right:parseInt(ms[1],10)||0,bottom:parseInt(ms[2],10)||0,left:parseInt(ms[3],10)||0};}};Ext.Container.LAYOUTS['auto']=Ext.layout.ContainerLayout;