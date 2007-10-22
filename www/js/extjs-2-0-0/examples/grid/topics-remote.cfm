<cfsetting enablecfoutputonly="true">
<cfsetting showdebugoutput="false">

<cfparam name="form.start" default="0">
<cfparam name="form.limit" default="0">
<cfparam name="form.fieldnames" default="">
<cfparam name="form.sort" default="">
<cfparam name="form.dir" default="">

<cfset maxRows = 99999999 />
<cfset sortPos = 0 />

<cfset form.start = form.start + 1 />

<cfif form.start GT 0>
	<cfset maxRows = form.start + form.limit - 1 />
<cfelseif form.limit GT 0>
	<cfset maxRows = form.limit />
</cfif>

<cfquery datasource="farcry_agora" name="qTimesheets" maxrows="#maxRows#">
SELECT * FROM crmTimesheet
<cfif len(form.sort)>
	
	ORDER BY
	
	<cfset sortPos = 0 />
	<cfloop list="#form.sort#" index="i">
		<cfset sortPos = sortPos + 1 />
		<cfif sortPos GT 1>
			<cfoutput>,</cfoutput>
		</cfif>
		#listGetAt(form.sort, sortPos)# <cfif listLen(form.dir) GTE sortPos>#listGetAt(form.dir, sortPos)#</cfif>
	</cfloop>	
</cfif>
</cfquery>

<cfquery datasource="farcry_agora" name="qTimesheetsTotal">
SELECT count(objectid) as count
FROM crmTimesheet
</cfquery>

<cfoutput>{"recordcount":"#qTimesheetsTotal.count#","records":[</cfoutput>

<cfif qTimesheets.recordCount>

	<cfset bFirstRow = true />
	<cfloop query="qTimesheets" startrow="#form.start#">
		<cfif bFirstRow>
			<cfset bFirstRow = false />
		<cfelse>
			<cfoutput>,</cfoutput>
		</cfif>
		<cfoutput>{</cfoutput>
		
		<cfset bFirstColumn = true />
		<cfloop list="#qTimesheets.columnList#" index="columnName">
			<cfif bFirstColumn>
				<cfset bFirstColumn = false />
			<cfelse>
				<cfoutput>,</cfoutput>
			</cfif>
			<cfoutput>"#lCase(columnName)#":"#JSStringFormat(qTimesheets[columnName][currentRow])#"</cfoutput><!--- sort:#form.sort#...dir:#form.dir#...#structKeyList(form)#...#form.start# * #form.limit#... --->
		</cfloop>
		
		<cfoutput>}</cfoutput>
	</cfloop>
</cfif>
<cfoutput>]}</cfoutput>


<!--- 
<cfoutput>{"totalCount":"38","topics":[{"post_id":"61607","topic_title":"combobox vs. ArrayRerader","topic_id":"12604","author":"zergemedve","post_time":"1189292674","post_text":"start:#form.start#...limit:#form.limit#...fieldnames:#form.fieldnames#..Hi Guys,\r\n\r\nI have a very simple array and I'd like to select from them with a combobox on a dialog panel like this:\r\n\r\n\r\n\/*\r\nmy input array looks lik...","forum_title":"Bugs","forumid":"3","reply_count":"0"},{"post_id":"61606","topic_title":"{background: true} in NestedLayoutPanel --> incorrect resizing","topic_id":"12597","author":"Francis.Chui","post_time":"1189292250","post_text":"Yeah I had solved it before posting. It wasn't a question as such but a 'bug report'. Maybe it isn't a bug but it wasn't how I thought it should.","forum_title":"Bugs","forumid":"3","reply_count":"4"},{"post_id":"61605","topic_title":"Populate ComboBox with Inital Value f\/ DB on XHR","topic_id":"12603","author":"cluettr","post_time":"1189291693","post_text":"I'm having a 'heck' of a time getting this working. How have any of you been able to populate a combobox with the initial value from a database. The...","forum_title":"Help","forumid":"5","reply_count":"0"},{"post_id":"61604","topic_title":"{background: true} in NestedLayoutPanel --> incorrect resizing","topic_id":"12597","author":"jsakalos","post_time":"1189291612","post_text":"Is it solved then?","forum_title":"Bugs","forumid":"3","reply_count":"4"},{"post_id":"61603","topic_title":"{background: true} in NestedLayoutPanel --> incorrect resizing","topic_id":"12597","author":"Francis.Chui","post_time":"1189291251","post_text":"Here is the HTML code I use:\r\n\r\n\r\n\r\n\t\r\n\t\t\r\n\t\t\r\n\t\r\n\t\r\n\t\t\r\n\t\t\r\n\t\r\n\r\n\r\n\t\r\n\t\t\r\n\t\t\r\n\t\r\n\t\r\n\t\t\r\n\t\t\r\n\t\r\n\r\n\r\n\r\nI fixed it by removing the {background:true} con...","forum_title":"Bugs","forumid":"3","reply_count":"4"},{"post_id":"61602","topic_title":"Simple insertion of textarea into the DOM","topic_id":"12593","author":"fernando","post_time":"1189291130","post_text":"Answering my own problem:\r\n\r\n\tvar dh = Ext.DomHelper;\r\n\tvar tim = Ext.get('tim');\r\n\tvar tex = dh.append(tim, {tag: 'textarea'});\r\n\r\ninserts a textare...","forum_title":"Help","forumid":"5","reply_count":"1"},{"post_id":"61601","topic_title":"a E-Mail Cilent-fully EXT based-","topic_id":"11106","author":"steffenk","post_time":"1189290759","post_text":"Hi Frank,\n\nI'm really interst in your ticket system. Is there any source or live demo available ?","forum_title":"Examples and Extras","forumid":"7","reply_count":"15"},{"post_id":"61600","topic_title":"a E-Mail Cilent-fully EXT based-","topic_id":"11106","author":"Gunmen","post_time":"1189290563","post_text":"Please let me know too. ;)\n \nThanks!","forum_title":"Examples and Extras","forumid":"7","reply_count":"15"},{"post_id":"61598","topic_title":"Drag and Drop","topic_id":"12574","author":"junkyard5dawg","post_time":"1189289569","post_text":"Hello Animal, Thanks for that, unfortunately I don't need all of that code for my purposes. I already have a page which I need to implement this on an...","forum_title":"Help","forumid":"5","reply_count":"2"},{"post_id":"61597","topic_title":"using data.Store with multiple proxies?","topic_id":"12586","author":"ilia","post_time":"1189289499","post_text":"I'm just calling different methods on the same server. I was hoping I wouldn't have to change the server process.","forum_title":"Help","forumid":"5","reply_count":"2"}]}</cfoutput>
 --->
<cfsetting enablecfoutputonly="false">
