<!--- @@displayname: Loops through a list progressing through the items and ADDING them to the index in each loop --->

<cfswitch expression="#thistag.ExecutionMode#">
	<cfcase value="start">
		
		<cfparam name="attributes.list" /><!--- The list of items to iterate through --->
		<cfparam name="attributes.delimiters" default="," /><!--- Characters that qualify as delimiters --->
		<cfparam name="attributes.index" /><!--- The variable to use as the index in the content --->
	
		<cfset thistag.index = 1 />
		<cfset thistag.endindex = listlen(attributes.list,attributes.delimiters) />
		<cfset attributes.delimiters = replacelist(attributes.delimiters,'\,[,],{,},(,),+,?,.,$,^,|,!,:','\\,\[,\],\{,\},\(,\),\+,\?,\.,\$,\^,\|,\!,\:') />
		
		<cfif thistag.endindex>
		
			<cfset thistag.items = arraynew(1) />
			<cfset last = 1 />
			<cfset next = refindnocase("[#attributes.delimiters#]",attributes.list,last,false) />
			<cfloop condition="#next#">
				
				<cfset arrayappend(thistag.items,mid(attributes.list,last,next-last))>
				<cfset last = next />
				<cfset next = refindnocase("[#attributes.delimiters#]",attributes.list,last+1,false) />
				<cfif next eq 0 and last lt len(attributes.list)+1>
					<cfset next = len(attributes.list)+1 />
				</cfif>
				
			</cfloop>
			
			<cfset caller[attributes.index] = thistag.items[1] />
		
		<cfelse>
		
			<cfexit method="exittag" />
		
		</cfif>
	
	</cfcase>
	
	<cfcase value="end">
		<cfset thistag.index = thistag.index+1 />
		
		<cfif thistag.index lte thistag.endindex>
			
			<cfset caller[attributes.index] = caller[attributes.index] & thistag.items[thistag.index] />
			<cfexit method="loop" />
			
		<cfelse>
		
			<cfset caller[attributes.index] = "" />
			
		</cfif>
	</cfcase>
</cfswitch>