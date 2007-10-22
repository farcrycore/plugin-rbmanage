/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.state.Manager=function(){var provider=new Ext.state.Provider();return{setProvider:function(stateProvider){provider=stateProvider;},get:function(key,defaultValue){return provider.get(key,defaultValue);},set:function(key,value){provider.set(key,value);},clear:function(key){provider.clear(key);},getProvider:function(){return provider;}};}();