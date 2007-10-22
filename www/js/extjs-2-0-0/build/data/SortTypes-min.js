/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.data.SortTypes={none:function(s){return s;},stripTagsRE:/<\/?[^>]+>/gi,asText:function(s){return String(s).replace(this.stripTagsRE,"");},asUCText:function(s){return String(s).toUpperCase().replace(this.stripTagsRE,"");},asUCString:function(s){return String(s).toUpperCase();},asDate:function(s){if(!s){return 0;}
if(s instanceof Date){return s.getTime();}
return Date.parse(String(s));},asFloat:function(s){var val=parseFloat(String(s).replace(/,/g,""));if(isNaN(val))val=0;return val;},asInt:function(s){var val=parseInt(String(s).replace(/,/g,""));if(isNaN(val))val=0;return val;}};