/*
 * Ext JS Library 2.0 Dev 5
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * This code has not yet been licensed for use.
 */

Ext.onReady(function(){

    Ext.QuickTips.init();

    // turn on validation errors beside the field globally
    Ext.form.Field.prototype.msgTarget = 'side';

    var bd = Ext.getBody();

    /*
     * ================  Simple form  =======================
     */
    bd.createChild({tag: 'h2', html: 'Form 1 - Very Simple'});


    var simple = new Ext.FormPanel({
        labelWidth: 75, // label settings here cascade unless overridden
        url:'save-form.php',
        frame:true,
        title: 'Simple Form',
        bodyStyle:'padding:5px 5px 0',
        width: 350,
        defaults: {width: 230},
        defaultType: 'textfield',

        items: [{
                fieldLabel: 'First Name',
                name: 'first',
                allowBlank:false
            },{
                fieldLabel: 'Last Name',
                name: 'last'
            },{
                fieldLabel: 'Company',
                name: 'company'
            }, {
                fieldLabel: 'Email',
                name: 'email',
                vtype:'email'
            }, new Ext.form.TimeField({
                fieldLabel: 'Time',
                name: 'time',
                minValue: '8:00am',
                maxValue: '6:00pm'
            })
        ],

        buttons: [{
            text: 'Save'
        },{
            text: 'Cancel'
        }]
    });

    simple.render(document.body);

    
    /*
     * ================  Form ?  =======================
     */
    bd.createChild({tag: 'h2', html: 'Form 2 - Adding fieldsets'});

    var fsf = new Ext.FormPanel({
        labelWidth: 75, // label settings here cascade unless overridden
        url:'save-form.php',
        frame:true,
        title: 'Simple Form with FieldSets',
        bodyStyle:'padding:5px 5px 0',
        width: 350,

        items: [{
            xtype:'fieldset',
            checkboxToggle:true,
            title: 'User Information',
            autoHeight:true,
            defaults: {width: 210},
            defaultType: 'textfield',
            collapsed: true,
            items :[{
                    fieldLabel: 'First Name',
                    name: 'first',
                    allowBlank:false
                },{
                    fieldLabel: 'Last Name',
                    name: 'last'
                },{
                    fieldLabel: 'Company',
                    name: 'company'
                }, {
                    fieldLabel: 'Email',
                    name: 'email',
                    vtype:'email'
                }
            ]
        },{
            xtype:'fieldset',
            title: 'Phone Number',
            collapsible: true,
            autoHeight:true,
            defaults: {width: 210},
            defaultType: 'textfield',
            items :[{
                    fieldLabel: 'Home',
                    name: 'home',
                    value: '(888) 555-1212'
                },{
                    fieldLabel: 'Business',
                    name: 'business'
                },{
                    fieldLabel: 'Mobile',
                    name: 'mobile'
                },{
                    fieldLabel: 'Fax',
                    name: 'fax'
                }
            ]
        }],

        buttons: [{
            text: 'Save'
        },{
            text: 'Cancel'
        }]
    });

    fsf.render(document.body);

    /*
     * ================  Form 2  =======================
     */
    bd.createChild({tag: 'h2', html: 'Form 2 - A little more complex'});


    var top = new Ext.FormPanel({
        labelAlign: 'top',
        frame:true,
        title: 'Multi Column, Nested Layouts and Anchoring',
        bodyStyle:'padding:5px 5px 0',
        width: 600,
        items: [{
            layout:'column',
            items:[{
                columnWidth:.5,
                layout: 'form',
                items: [{
                    xtype:'textfield',
                    fieldLabel: 'First Name',
                    name: 'first',
                    anchor:'95%'
                }, {
                    xtype:'textfield',
                    fieldLabel: 'Company',
                    name: 'company',
                    anchor:'95%'
                }]
            },{
                columnWidth:.5,
                layout: 'form',
                items: [{
                    xtype:'textfield',
                    fieldLabel: 'Last Name',
                    name: 'last',
                    anchor:'95%'
                },{
                    xtype:'textfield',
                    fieldLabel: 'Email',
                    name: 'email',
                    vtype:'email',
                    anchor:'95%'
                }]
            }]
        },{
            xtype:'htmleditor',
            id:'bio',
            fieldLabel:'Biography',
            height:200,
            anchor:'98%'
        }],

        buttons: [{
            text: 'Save'
        },{
            text: 'Cancel'
        }]
    });

    top.render(document.body);


    /*
     * ================  Form 3  =======================
     */
    bd.createChild({tag: 'h2', html: 'Form 3 - Forms can be a TabPanel...'});



    var tabs = new Ext.FormPanel({
        labelWidth: 75,
        border:false,
        width: 350,

        items: {
            xtype:'tabpanel',
            activeTab: 0,
            defaults:{autoHeight:true, bodyStyle:'padding:10px'}, 
            items:[{
                title:'Personal Details',
                layout:'form',
                defaults: {width: 230},
                defaultType: 'textfield',

                items: [{
                    fieldLabel: 'First Name',
                    name: 'first',
                    allowBlank:false,
                    value: 'Jack'
                },{
                    fieldLabel: 'Last Name',
                    name: 'last',
                    value: 'Slocum'
                },{
                    fieldLabel: 'Company',
                    name: 'company',
                    value: 'Ext JS'
                }, {
                    fieldLabel: 'Email',
                    name: 'email',
                    vtype:'email'
                }]
            },{
                title:'Phone Numbers',
                layout:'form',
                defaults: {width: 230},
                defaultType: 'textfield',

                items: [{
                    fieldLabel: 'Home',
                    name: 'home',
                    value: '(888) 555-1212'
                },{
                    fieldLabel: 'Business',
                    name: 'business'
                },{
                    fieldLabel: 'Mobile',
                    name: 'mobile'
                },{
                    fieldLabel: 'Fax',
                    name: 'fax'
                }]
            }]
        },

        buttons: [{
            text: 'Save'
        },{
            text: 'Cancel'
        }]
    });

    tabs.render(document.body);



    /*
     * ================  Form 4  =======================
     */
    bd.createChild({tag: 'h2', html: 'Form 3 - ... and forms can contain TabPanel(s)'});

    var tab2 = new Ext.FormPanel({
        labelAlign: 'top',
        title: 'Inner Tabs',
        bodyStyle:'padding:5px',
        width: 600,
        items: [{
            layout:'column',
            border:false,
            items:[{
                columnWidth:.5,
                layout: 'form',
                border:false,
                items: [{
                    xtype:'textfield',
                    fieldLabel: 'First Name',
                    name: 'first',
                    anchor:'95%'
                }, {
                    xtype:'textfield',
                    fieldLabel: 'Company',
                    name: 'company',
                    anchor:'95%'
                }]
            },{
                columnWidth:.5,
                layout: 'form',
                border:false,
                items: [{
                    xtype:'textfield',
                    fieldLabel: 'Last Name',
                    name: 'last',
                    anchor:'95%'
                },{
                    xtype:'textfield',
                    fieldLabel: 'Email',
                    name: 'email',
                    vtype:'email',
                    anchor:'95%'
                }]
            }]
        },{
            xtype:'tabpanel',
            plain:true,
            activeTab: 0,
            height:235,
            defaults:{bodyStyle:'padding:10px'},
            items:[{
                title:'Personal Details',
                layout:'form',
                defaults: {width: 230},
                defaultType: 'textfield',

                items: [{
                    fieldLabel: 'First Name',
                    name: 'first',
                    allowBlank:false,
                    value: 'Jack'
                },{
                    fieldLabel: 'Last Name',
                    name: 'last',
                    value: 'Slocum'
                },{
                    fieldLabel: 'Company',
                    name: 'company',
                    value: 'Ext JS'
                }, {
                    fieldLabel: 'Email',
                    name: 'email',
                    vtype:'email'
                }]
            },{
                title:'Phone Numbers',
                layout:'form',
                defaults: {width: 230},
                defaultType: 'textfield',

                items: [{
                    fieldLabel: 'Home',
                    name: 'home',
                    value: '(888) 555-1212'
                },{
                    fieldLabel: 'Business',
                    name: 'business'
                },{
                    fieldLabel: 'Mobile',
                    name: 'mobile'
                },{
                    fieldLabel: 'Fax',
                    name: 'fax'
                }]
            },{
                title:'Biography',
                layout:'fit',
                items: {
                    xtype:'htmleditor',
                    id:'bio',
                    fieldLabel:'Biography'
                }
            }]
        }],

        buttons: [{
            text: 'Save'
        },{
            text: 'Cancel'
        }]
    });

    tab2.render(document.body);

    return;

    top.column(
        {width:282}, // precise column sizes or percentages or straight CSS
        new Ext.form.TextField({
            fieldLabel: 'First Name',
            name: 'first',
            width:225
        }),

        new Ext.form.TextField({
            fieldLabel: 'Company',
            name: 'company',
            width:225
        })
    );

    top.column(
        {width:272, style:'margin-left:10px', clear:true}, // apply custom css, clear:true means it is the last column
        new Ext.form.TextField({
            fieldLabel: 'Last Name',
            name: 'last',
            width:225
        }),

        new Ext.form.TextField({
            fieldLabel: 'Email',
            name: 'email',
            vtype:'email',
            width:225
        })
    );

    top.container({},
        new Ext.form.HtmlEditor({
            id:'bio',
            fieldLabel:'Biography',
            width:550,
            height:200
        })
    );

    top.addButton('Save');
    top.addButton('Cancel');

    top.render('form-ct2');


    /*
     * ================  Form 3  =======================
     */
    var fs = new Ext.form.Form({
        labelAlign: 'right',
        labelWidth: 80
    });

    fs.fieldset(
        {legend:'Contact Information'},
        new Ext.form.TextField({
            fieldLabel: 'First Name',
            name: 'first',
            width:190
        }),

        new Ext.form.TextField({
            fieldLabel: 'Last Name',
            name: 'last',
            width:190
        }),

        new Ext.form.TextField({
            fieldLabel: 'Company',
            name: 'company',
            width:190
        }),

        new Ext.form.TextField({
            fieldLabel: 'Email',
            name: 'email',
            vtype:'email',
            width:190
        }),

        new Ext.form.ComboBox({
            fieldLabel: 'State',
            hiddenName:'state',
            store: new Ext.data.SimpleStore({
                fields: ['abbr', 'state'],
                data : Ext.exampledata.states // from states.js
            }),
            displayField:'state',
            typeAhead: true,
            mode: 'local',
            triggerAction: 'all',
            emptyText:'Select a state...',
            selectOnFocus:true,
            width:190
        }),

        new Ext.form.DateField({
            fieldLabel: 'Date of Birth',
            name: 'dob',
            width:190,
            allowBlank:false
        })
    );

    fs.addButton('Save');
    fs.addButton('Cancel');

    fs.render('form-ct3');

    /*
     * ================  Form 4  =======================
     */
    var form = new Ext.form.Form({
        labelAlign: 'right',
        labelWidth: 75
    });

    form.column({width:342, labelWidth:75}); // open column, without auto close
    form.fieldset(
        {legend:'Contact Information'},
        new Ext.form.TextField({
            fieldLabel: 'Full Name',
            name: 'fullName',
            allowBlank:false,
            value: 'Jack Slocum'
        }),

        new Ext.form.TextField({
            fieldLabel: 'Job Title',
            name: 'title',
            value: 'Jr. Developer'
        }),

        new Ext.form.TextField({
            fieldLabel: 'Company',
            name: 'company',
            value: 'Ext JS'
        }),

        new Ext.form.TextArea({
            fieldLabel: 'Address',
            name: 'address',
            grow: true,
            preventScrollbars:true,
            value: '4 Redbulls Drive'
        })
    );
    form.fieldset(
        {legend:'Phone Numbers'},
        new Ext.form.TextField({
            fieldLabel: 'Home',
            name: 'home',
            value: '(888) 555-1212'
        }),

        new Ext.form.TextField({
            fieldLabel: 'Business',
            name: 'business'
        }),

        new Ext.form.TextField({
            fieldLabel: 'Mobile',
            name: 'mobile'
        }),

        new Ext.form.TextField({
            fieldLabel: 'Fax',
            name: 'fax'
        })
    );
    form.end(); // closes the last container element (column, layout, fieldset, etc) and moves up 1 level in the stack

    
    form.column(
        {width:202, style:'margin-left:10px', clear:true}
    );

    form.fieldset(
        {id:'photo', legend:'Photo'}
    );
    form.end();

    form.fieldset(
        {legend:'Options', hideLabels:true},
        new Ext.form.Checkbox({
            boxLabel:'Ext 1.0 User',
            name:'extuser'
        }),
        new Ext.form.Checkbox({
            boxLabel:'Ext Commercial User',
            name:'extcomm'
        }),
        new Ext.form.Checkbox({
            boxLabel:'Ext Premium Member',
            name:'extprem'
        }),
        new Ext.form.Checkbox({
            boxLabel:'Ext Team Member',
            name:'extteam',
            checked:true
        })
    );

    form.end(); // close the column

    
    form.applyIfToFields({
        width:230
    });

    form.addButton('Save');
    form.addButton('Cancel');

    form.render('form-ct4');

    // The form elements are standard HTML elements. By assigning an id (as we did above)
    // we can manipulate them like any other element
    var photo = Ext.get('photo');
    var c = photo.createChild({
        tag:'center', 
        cn: {
            tag:'img',
            src: 'http://extjs.com/forum/image.php?u=2&dateline=1175747336',
            style:'margin-bottom:5px;'
        }
    });
    new Ext.Button({
        text: 'Change Photo',
        renderTo: c
    });
});