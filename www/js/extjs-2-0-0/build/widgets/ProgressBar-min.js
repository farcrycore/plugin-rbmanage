/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.ProgressBar=Ext.extend(Ext.BoxComponent,{baseCls:'x-progress',waitTimer:null,initComponent:function(){Ext.ProgressBar.superclass.initComponent.call(this);this.addEvents({"update":true});},onRender:function(ct,position){Ext.ProgressBar.superclass.onRender.call(this,ct,position);var tpl=new Ext.Template('<div class="{cls}-wrap">','<div class="{cls}-inner">','<div class="{cls}-bar">','<div class="{cls}-text">','<div>&#160;</div>','</div>','</div>','<div class="{cls}-text {cls}-text-back">','<div>&#160;</div>','</div>','</div>','</div>');if(position){this.el=tpl.insertBefore(position,{cls:this.baseCls},true);}else{this.el=tpl.append(ct,{cls:this.baseCls},true);}
if(this.id){this.el.dom.id=this.id;}
var inner=this.el.dom.firstChild;this.progressBar=Ext.get(inner.firstChild);if(this.textEl){this.textEl=Ext.get(this.textEl);delete this.textTopEl;}else{this.textTopEl=Ext.get(this.progressBar.dom.firstChild);var textBackEl=Ext.get(inner.childNodes[1]);this.textTopEl.setStyle("z-index",99).addClass('x-hidden');this.textEl=new Ext.CompositeElement([this.textTopEl.dom.firstChild,textBackEl.dom.firstChild]);this.textEl.setWidth(inner.offsetWidth);}
if(this.value){this.updateProgress(this.value,this.text);}else{this.updateText(this.text);}
this.setSize(this.width||'auto','auto');this.progressBar.setHeight(inner.offsetHeight);},updateProgress:function(value,text){this.value=value||0;if(text){this.updateText(text);}
var w=Math.floor(value*this.el.dom.firstChild.offsetWidth);this.progressBar.setWidth(w);if(this.textTopEl){this.textTopEl.removeClass('x-hidden').setWidth(w);}
this.fireEvent('update',this,value,text);return this;},wait:function(o){if(!this.waitTimer){var scope=this;o=o||{};this.waitTimer=Ext.TaskMgr.start({run:function(i){var inc=o.increment||10;this.updateProgress(((((i+inc)%inc)+1)*(100/inc))*.01);},interval:o.interval||1000,duration:o.duration,onStop:function(){if(o.fn){o.fn.apply(o.scope||this);}
this.reset();},scope:scope});}
return this;},isWaiting:function(){return this.waitTimer!=null;},updateText:function(text){this.text=text||'&#160;';this.textEl.update(this.text);return this;},setSize:function(w,h){Ext.ProgressBar.superclass.setSize.call(this,w,h);if(this.textTopEl){var inner=this.el.dom.firstChild;this.textEl.setSize(inner.offsetWidth,inner.offsetHeight);}
return this;},reset:function(hide){this.updateProgress(0);if(this.textTopEl){this.textTopEl.addClass('x-hidden');}
if(this.waitTimer){this.waitTimer.onStop=null;Ext.TaskMgr.stop(this.waitTimer);this.waitTimer=null;}
if(hide===true){this.hide();}
return this;}});Ext.reg('progress',Ext.ProgressBar);