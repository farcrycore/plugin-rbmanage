/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */


Ext.layout.TableLayout=Ext.extend(Ext.layout.ContainerLayout,{monitorResize:false,setContainer:function(ct){Ext.layout.TableLayout.superclass.setContainer.call(this,ct);this.currentRow=0;this.currentColumn=0;},onLayout:function(ct,target){var cs=ct.items.items,len=cs.length,c,i;if(!this.table){target.addClass('x-table-layout-ct');this.table=target.createChild({tag:'table',cls:'x-table-layout',cellspacing:0,cn:{tag:'tbody'}},null,true);this.renderAll(ct,target);}},getRow:function(index){var row=this.table.tBodies[0].childNodes[index];if(!row){row=document.createElement('tr');this.table.tBodies[0].appendChild(row);}
return row;},getNextCell:function(c){var td=document.createElement('td'),row;if(!this.columns){row=this.getRow(0);}else{if(this.currentColumn!==0&&(this.currentColumn%this.columns===0)){row=this.getRow(++this.currentRow);this.currentColumn=(c.colspan||1);}else{row=this.getRow(this.currentRow);this.currentColumn+=(c.colspan||1);}}
if(c.colspan){td.colSpan=c.colspan;}
if(c.rowspan){td.rowSpan=c.rowspan;}
td.className='x-table-layout-cell';row.appendChild(td);return td;},renderItem:function(c,position,target){if(c&&!c.rendered){c.render(this.getNextCell(c));}},isValidParent:function(c,target){return true;}});Ext.Container.LAYOUTS['table']=Ext.layout.TableLayout;