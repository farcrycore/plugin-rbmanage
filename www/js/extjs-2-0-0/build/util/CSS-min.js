/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.util.CSS=function(){var rules=null;var doc=document;var camelRe=/(-[a-z])/gi;var camelFn=function(m,a){return a.charAt(1).toUpperCase();};return{createStyleSheet:function(cssText,id){var ss;var head=doc.getElementsByTagName("head")[0];var rules=doc.createElement("style");rules.setAttribute("type","text/css");if(id){rules.setAttribute("id",id);}
if(Ext.isIE){head.appendChild(rules);ss=rules.styleSheet;ss.cssText=cssText;}else{try{rules.appendChild(doc.createTextNode(cssText));}catch(e){rules.cssText=cssText;}
head.appendChild(rules);ss=rules.styleSheet?rules.styleSheet:(rules.sheet||doc.styleSheets[doc.styleSheets.length-1]);}
this.cacheStyleSheet(ss);return ss;},removeStyleSheet:function(id){var existing=doc.getElementById(id);if(existing){existing.parentNode.removeChild(existing);}},swapStyleSheet:function(id,url){this.removeStyleSheet(id);var ss=doc.createElement("link");ss.setAttribute("rel","stylesheet");ss.setAttribute("type","text/css");ss.setAttribute("id",id);ss.setAttribute("href",url);doc.getElementsByTagName("head")[0].appendChild(ss);},refreshCache:function(){return this.getRules(true);},cacheStyleSheet:function(ss){if(!rules){rules={};}
try{var ssRules=ss.cssRules||ss.rules;for(var j=ssRules.length-1;j>=0;--j){rules[ssRules[j].selectorText]=ssRules[j];}}catch(e){}},getRules:function(refreshCache){if(rules==null||refreshCache){rules={};var ds=doc.styleSheets;for(var i=0,len=ds.length;i<len;i++){try{this.cacheStyleSheet(ds[i]);}catch(e){}}}
return rules;},getRule:function(selector,refreshCache){var rs=this.getRules(refreshCache);if(!(selector instanceof Array)){return rs[selector];}
for(var i=0;i<selector.length;i++){if(rs[selector[i]]){return rs[selector[i]];}}
return null;},updateRule:function(selector,property,value){if(!(selector instanceof Array)){var rule=this.getRule(selector);if(rule){rule.style[property.replace(camelRe,camelFn)]=value;return true;}}else{for(var i=0;i<selector.length;i++){if(this.updateRule(selector[i],property,value)){return true;}}}
return false;}};}();