/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.data.DataReader=function(meta,recordType){this.meta=meta;this.recordType=recordType instanceof Array?Ext.data.Record.create(recordType):recordType;};Ext.data.DataReader.prototype={};