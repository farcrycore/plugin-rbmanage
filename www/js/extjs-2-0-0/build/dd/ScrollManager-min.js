/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.dd.ScrollManager=function(){var ddm=Ext.dd.DragDropMgr;var els={};var dragEl=null;var proc={};var onStop=function(e){dragEl=null;clearProc();};var triggerRefresh=function(){if(ddm.dragCurrent){ddm.refreshCache(ddm.dragCurrent.groups);}};var doScroll=function(){if(ddm.dragCurrent){var dds=Ext.dd.ScrollManager;if(!dds.animate){if(proc.el.scroll(proc.dir,dds.increment)){triggerRefresh();}}else{proc.el.scroll(proc.dir,dds.increment,true,dds.animDuration,triggerRefresh);}}};var clearProc=function(){if(proc.id){clearInterval(proc.id);}
proc.id=0;proc.el=null;proc.dir="";};var startProc=function(el,dir){clearProc();proc.el=el;proc.dir=dir;proc.id=setInterval(doScroll,Ext.dd.ScrollManager.frequency);};var onFire=function(e,isDrop){if(isDrop||!ddm.dragCurrent){return;}
var dds=Ext.dd.ScrollManager;if(!dragEl||dragEl!=ddm.dragCurrent){dragEl=ddm.dragCurrent;dds.refreshCache();}
var xy=Ext.lib.Event.getXY(e);var pt=new Ext.lib.Point(xy[0],xy[1]);for(var id in els){var el=els[id],r=el._region;if(r&&r.contains(pt)&&el.isScrollable()){if(r.bottom-pt.y<=dds.thresh){if(proc.el!=el){startProc(el,"down");}
return;}else if(r.right-pt.x<=dds.thresh){if(proc.el!=el){startProc(el,"left");}
return;}else if(pt.y-r.top<=dds.thresh){if(proc.el!=el){startProc(el,"up");}
return;}else if(pt.x-r.left<=dds.thresh){if(proc.el!=el){startProc(el,"right");}
return;}}}
clearProc();};ddm.fireEvents=ddm.fireEvents.createSequence(onFire,ddm);ddm.stopDrag=ddm.stopDrag.createSequence(onStop,ddm);return{register:function(el){if(el instanceof Array){for(var i=0,len=el.length;i<len;i++){this.register(el[i]);}}else{el=Ext.get(el);els[el.id]=el;}},unregister:function(el){if(el instanceof Array){for(var i=0,len=el.length;i<len;i++){this.unregister(el[i]);}}else{el=Ext.get(el);delete els[el.id];}},thresh:25,increment:100,frequency:500,animate:true,animDuration:.4,refreshCache:function(){for(var id in els){if(typeof els[id]=='object'){els[id]._region=els[id].getRegion();}}}};}();