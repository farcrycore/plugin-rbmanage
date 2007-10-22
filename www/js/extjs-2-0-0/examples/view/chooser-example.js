/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */

Ext.onReady(function(){
    var chooser, btn;
    
    function insertImage(data){
    	Ext.DomHelper.append('images', {
    		tag: 'img', src: data.url, style:'margin:10px;visibility:hidden;'
    	}, true).show(true);
    	btn.getEl().focus();
    };
    
    function choose(btn){
    	if(!chooser){
    		chooser = new ImageChooser({
    			url:'get-images.php',
    			width:515, 
    			height:400
    		});
    	}
    	chooser.show(btn.getEl(), insertImage);
    };
    
    btn = new Ext.Button({
	    text: "Insert Image",
		handler: choose,
        renderTo: 'buttons'
    });
});