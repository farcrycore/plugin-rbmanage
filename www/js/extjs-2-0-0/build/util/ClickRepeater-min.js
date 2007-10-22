/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.util.ClickRepeater=function(el,config)
{this.el=Ext.get(el);this.el.unselectable();Ext.apply(this,config);this.addEvents({"mousedown":true,"click":true,"mouseup":true});this.el.on("mousedown",this.handleMouseDown,this);if(this.preventDefault||this.stopDefault){this.el.on("click",function(e){if(this.preventDefault){e.preventDefault();}
if(this.stopDefault){e.stopEvent();}},this);}
if(this.handler){this.on("click",this.handler,this.scope||this);}
Ext.util.ClickRepeater.superclass.constructor.call(this);};Ext.extend(Ext.util.ClickRepeater,Ext.util.Observable,{interval:20,delay:250,preventDefault:true,stopDefault:false,timer:0,handleMouseDown:function(){clearTimeout(this.timer);this.el.blur();if(this.pressClass){this.el.addClass(this.pressClass);}
this.mousedownTime=new Date();Ext.getDoc().on("mouseup",this.handleMouseUp,this);this.el.on("mouseout",this.handleMouseOut,this);this.fireEvent("mousedown",this);this.fireEvent("click",this);this.timer=this.click.defer(this.delay||this.interval,this);},click:function(){this.fireEvent("click",this);this.timer=this.click.defer(this.getInterval(),this);},getInterval:function(){if(!this.accelerate){return this.interval;}
var pressTime=this.mousedownTime.getElapsed();if(pressTime<500){return 400;}else if(pressTime<1700){return 320;}else if(pressTime<2600){return 250;}else if(pressTime<3500){return 180;}else if(pressTime<4400){return 140;}else if(pressTime<5300){return 80;}else if(pressTime<6200){return 50;}else{return 10;}},handleMouseOut:function(){clearTimeout(this.timer);if(this.pressClass){this.el.removeClass(this.pressClass);}
this.el.on("mouseover",this.handleMouseReturn,this);},handleMouseReturn:function(){this.el.un("mouseover",this.handleMouseReturn);if(this.pressClass){this.el.addClass(this.pressClass);}
this.click();},handleMouseUp:function(){clearTimeout(this.timer);this.el.un("mouseover",this.handleMouseReturn);this.el.un("mouseout",this.handleMouseOut);Ext.getDoc().un("mouseup",this.handleMouseUp);this.el.removeClass(this.pressClass);this.fireEvent("mouseup",this);}});