/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.FormPanel=Ext.extend(Ext.Panel,{buttonAlign:'center',minButtonWidth:75,labelAlign:'left',monitorValid:false,monitorPoll:200,layout:'form',initComponent:function(){this.form=this.createForm();Ext.FormPanel.superclass.initComponent.call(this);this.addEvents({clientvalidation:true});this.relayEvents(this.form,['beforeaction','actionfailed','actioncomplete']);},createForm:function(){return new Ext.form.BasicForm(null,this.initialConfig);},initFields:function(){var f=this.form;var formPanel=this;var fn=function(c){if(c.doLayout&&c!=formPanel){Ext.applyIf(c,{labelAlign:c.ownerCt.labelAlign,labelWidth:c.ownerCt.labelWidth,itemCls:c.ownerCt.itemCls});if(c.items){c.items.each(fn);}}else if(c.isFormField){f.add(c);}}
this.items.each(fn);},getLayoutTarget:function(){return this.form.el;},getForm:function(){return this.form;},onRender:function(ct,position){this.initFields();Ext.FormPanel.superclass.onRender.call(this,ct,position);var o={tag:'form',method:this.method||'POST',id:this.formId||Ext.id()};if(this.fileUpload){o.enctype='multipart/form-data';}
this.form.initEl(this.body.createChild(o));},initEvents:function(){Ext.FormPanel.superclass.initEvents.call(this);if(this.monitorValid){this.startMonitoring();}},startMonitoring:function(){if(!this.bound){this.bound=true;Ext.TaskMgr.start({run:this.bindHandler,interval:this.monitorPoll||200,scope:this});}},stopMonitoring:function(){this.bound=false;},load:function(){this.form.load.apply(this.form,arguments);},bindHandler:function(){if(!this.bound){return false;}
var valid=true;this.form.items.each(function(f){if(!f.isValid(true)){valid=false;return false;}});if(this.buttons){for(var i=0,len=this.buttons.length;i<len;i++){var btn=this.buttons[i];if(btn.formBind===true&&btn.disabled===valid){btn.setDisabled(!valid);}}}
this.fireEvent('clientvalidation',this,valid);}});Ext.reg('form',Ext.FormPanel);Ext.form.FormPanel=Ext.FormPanel;