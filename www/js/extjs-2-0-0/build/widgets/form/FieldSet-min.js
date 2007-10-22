/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.form.FieldSet=Ext.extend(Ext.Panel,{baseCls:'x-fieldset',layout:'form',onRender:function(ct,position){if(!this.el){this.el=document.createElement('fieldset');this.el.appendChild(document.createElement('legend')).className='x-fieldset-header';}
Ext.form.FieldSet.superclass.onRender.call(this,ct,position);if(this.checkboxToggle){var o=typeof this.checkboxToggle=='object'?this.checkboxToggle:{tag:'input',type:'checkbox',name:this.checkboxName||this.id+'-checkbox'};this.checkbox=this.header.insertFirst(o);this.checkbox.dom.checked=!this.collapsed;this.checkbox.on('click',this.onCheckClick,this);}},onCollapse:function(doAnim,animArg){if(this.checkbox){this.checkbox.dom.checked=false;}
this.afterCollapse();},onExpand:function(doAnim,animArg){if(this.checkbox){this.checkbox.dom.checked=true;}
this.afterExpand();},onCheckClick:function(){this[this.checkbox.dom.checked?'expand':'collapse']();}});Ext.reg('fieldset',Ext.form.FieldSet);