/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.grid.EditorGridPanel=Ext.extend(Ext.grid.GridPanel,{clicksToEdit:2,isEditor:true,trackMouseOver:false,detectEdit:false,initComponent:function(){Ext.grid.EditorGridPanel.superclass.initComponent.call(this);if(!this.selModel){this.selModel=new Ext.grid.CellSelectionModel();}
this.activeEditor=null;this.addEvents({"beforeedit":true,"afteredit":true,"validateedit":true});},initEvents:function(){Ext.grid.EditorGridPanel.superclass.initEvents.call(this);this.on("bodyscroll",this.stopEditing,this);if(this.clicksToEdit==1){this.on("cellclick",this.onCellDblClick,this);}else{if(this.clicksToEdit=='auto'&&this.view.mainBody){this.view.mainBody.on("mousedown",this.onAutoEditClick,this);}
this.on("celldblclick",this.onCellDblClick,this);}
this.getGridEl().addClass("xedit-grid");},onCellDblClick:function(g,row,col){this.startEditing(row,col);},onAutoEditClick:function(e,t){var row=this.view.findRowIndex(t);var col=this.view.findCellIndex(t);if(row!==false&&col!==false){if(this.selModel.getSelectedCell){var sc=this.selModel.getSelectedCell();if(sc&&sc.cell[0]===row&&sc.cell[1]===col){this.startEditing(row,col);}}else{if(this.selModel.isSelected(row)){this.startEditing(row,col);}}}},onEditComplete:function(ed,value,startValue){this.editing=false;this.activeEditor=null;ed.un("specialkey",this.selModel.onEditorKey,this.selModel);if(String(value)!==String(startValue)){var r=ed.record;var field=this.colModel.getDataIndex(ed.col);var e={grid:this,record:r,field:field,originalValue:startValue,value:value,row:ed.row,column:ed.col,cancel:false};if(this.fireEvent("validateedit",e)!==false&&!e.cancel){r.set(field,e.value);delete e.cancel;this.fireEvent("afteredit",e);}}
this.view.focusCell(ed.row,ed.col);},startEditing:function(row,col){this.stopEditing();if(this.colModel.isCellEditable(col,row)){this.view.ensureVisible(row,col,true);var r=this.store.getAt(row);var field=this.colModel.getDataIndex(col);var e={grid:this,record:r,field:field,value:r.data[field],row:row,column:col,cancel:false};if(this.fireEvent("beforeedit",e)!==false&&!e.cancel){this.editing=true;var ed=this.colModel.getCellEditor(col,row);if(!ed.rendered){ed.render(this.view.getEditorParent(ed));}
(function(){ed.row=row;ed.col=col;ed.record=r;ed.on("complete",this.onEditComplete,this,{single:true});ed.on("specialkey",this.selModel.onEditorKey,this.selModel);this.activeEditor=ed;var v=r.data[field];ed.startEdit(this.view.getCell(row,col),v);}).defer(50,this);}}},stopEditing:function(){if(this.activeEditor){this.activeEditor.completeEdit();}
this.activeEditor=null;}});Ext.reg('editorgrid',Ext.grid.EditorGridPanel);