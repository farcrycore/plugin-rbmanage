<cfsetting enablecfoutputonly="true" requesttimeout="1000" />

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />


<admin:header>

<skin:htmlHead><cfoutput>
	<style type="text/css">
		ul { padding-left:15px; }
	</style>
</cfoutput></skin:htmlHead>

<cfoutput><h1><admin:resource key="rbmanage.walkresources@title">Walk Resources</admin:resource></h1></cfoutput>
<admin:resource key="rbmanage.walkresources@html"><cfoutput>
	<p>This utility attempts to open every webtop page, load every content type resource, and view every login webskin. This should ensure that those resources will appear in the resource bundle reports as necessary.</p>
	<p>NOTE: site tree resources, notification messages, and emails will not be effected by this utility. To ensure those appear in the reports you will need to trigger those manually.</p>
</cfoutput></admin:resource>

<ft:form>
	<ft:buttonPanel>
		<ft:button value="Walk" />
	</ft:buttonPanel>
</ft:form>

<ft:processform action="Walk">
	<cfoutput><ul id="walked"></cfoutput>
	
	<!--- Form metadata --->
	<cfloop collection="#application.stCOAPI#" item="thistype">
		<cfset o = application.fapi.getContentType(thistype) />
		<cfset qMetadata = application.stCOAPI[thistype].qMetadata />
		
		<cfoutput><li>#thistype#<ul></cfoutput>
		<cfloop query="qMetadata">
			<cfoutput><li>#qMetadata.propertyname#<ul></cfoutput>
			<cfset temp = o.getI18Property(qMetadata.propertyname,"label") />
			<cfoutput><li>label "#temp#"</li></cfoutput>
			<cfif isdefined("application.stCOAPI.#thistype#.stProps.#qMetadata.propertyname#.metadata.ftHint")>
				<cfset temp = o.getI18Property(qMetadata.propertyname,"hint") />
				<cfoutput><li>hint "#temp#"</li></cfoutput>
			</cfif>
			<cfif len(qMetadata.ftWizardStep)>
				<cfset temp = o.getI18Step(qMetadata.ftWizardStep,"label") />
				<cfoutput><li>wizard step label "#temp#"</li></cfoutput>
				<cfif len(qMetadata.ftFieldSet)>
					<cfset temp = o.getI18Fieldset(qMetadata.ftWizardStep,qMetadata.ftFieldSet,"label") />
					<cfoutput><li>fieldset label "#temp#"</li></cfoutput>
					<cfif len(qMetadata.fthelptitle)>
						<cfset temp = o.getI18Fieldset(qMetadata.ftWizardStep,qMetadata.ftFieldSet,"helptitle") />
						<cfoutput><li>fieldset help title "#temp#"</li></cfoutput>
					</cfif>
					<cfif len(qMetadata.fthelpsection)>
						<cfset temp = o.getI18Fieldset(qMetadata.ftWizardStep,qMetadata.ftFieldSet,"helpsection") />
						<cfoutput><li>fieldset help section "#temp#"</li></cfoutput>
					</cfif>
				</cfif>
			<cfelseif len(qMetadata.ftFieldSet)>
				<cfset temp = o.getI18Fieldset(fieldset=qMetadata.ftFieldSet,value="label") />
				<cfoutput><li>fieldset label "#temp#"</li></cfoutput>
				<cfif len(qMetadata.fthelptitle)>
					<cfset temp = o.getI18Fieldset(fieldset=qMetadata.ftFieldSet,value="helptitle") />
					<cfoutput><li>fieldset help title "#temp#"</li></cfoutput>
				</cfif>
				<cfif len(qMetadata.fthelpsection)>
					<cfset temp = o.getI18Fieldset(fieldset=qMetadata.ftFieldSet,value="helpsection") />
					<cfoutput><li>fieldset help section "#temp#"</li></cfoutput>
				</cfif>
			</cfif>
			<cfoutput></ul></li></cfoutput>
		</cfloop>
		
		<cfoutput></ul></li></cfoutput>
	</cfloop>
	
	<cfoutput></ul></cfoutput>
	
	<!--- Webtop pages --->
	<cfset aURLs = arraynew(1) />
	<admin:loopwebtop item="tab">
		<admin:loopwebtop parent="#tab#" item="section">
			<cfif isdefined("section.sidebar") and len(section.sidebar)>
				<cfset stURL = structnew() />
				<cfset stURL["label"] = "#section.label# sidebar" />
				<cfset stURL["url"] = section.sidebar />
				<cfif left(stURL["url"],1) eq "/">
					<cfset stURL["url"] = "#application.url.webtop##stURL.url#" />
				<cfelse>
					<cfset stURL["url"] = "#application.url.webtop#/#stURL.url#" />
				</cfif>
				<cfset arrayappend(aURLs,stURL) />
			</cfif>
			<admin:loopwebtop parent="#section#" item="menu">
				<admin:loopwebtop parent="#menu#" item="menuitem">
					<cfif len(menuitem.link)>
						<cfset stURL = structnew() />
						<cfset stURL["label"] = menuitem.label />
						<cfset stURL["url"] = menuitem.link />
						<cfif left(stURL["url"],1) eq "/">
							<cfset stURL["url"] = "#application.url.webtop##stURL.url#" />
						<cfelse>
							<cfset stURL["url"] = "#application.url.webtop#/#stURL.url#" />
						</cfif>
						<cfset arrayappend(aURLs,stURL) />
					</cfif>
				</admin:loopwebtop>
			</admin:loopwebtop>
		</admin:loopwebtop>
	</admin:loopwebtop>
	
	<!--- Login webskins --->
	<cfset stURL = structnew() />
	<cfset stURL["label"] = "Login page" />
	<cfset stURL["url"] = application.fapi.getLink(type="farLogin",view="displayLogin") />
	<cfset arrayappend(aURLs,stURL) />
	
	<cfset stURL = structnew() />
	<cfset stURL["label"] = "Edit own password" />
	<cfset stURL["url"] = application.fapi.getLink(type="farUser",view="editOwnPassword") />
	<cfset arrayappend(aURLs,stURL) />
	
	<cfset stURL = structnew() />
	<cfset q = application.fapi.getContentObjects(typename="farUser") />
	<cfset stURL["label"] = "Edit password" />
	<cfset stURL["url"] = application.fapi.getLink(type="farUser",objectid=q.objectid[1],view="editPassword") />
	<cfset arrayappend(aURLs,stURL) />
	
	<cfset stURL = structnew() />
	<cfset stURL["label"] = "Forgot password" />
	<cfset stURL["url"] = application.fapi.getLink(type="farUser",view="forgotPassword") />
	<cfset arrayappend(aURLs,stURL) />
	
	<cfset stURL = structnew() />
	<cfset stURL["label"] = "Forgot user id" />
	<cfset stURL["url"] = application.fapi.getLink(type="farUser",view="forgotUserID") />
	<cfset arrayappend(aURLs,stURL) />
	
	<cfset stURL = structnew() />
	<cfset stURL["label"] = "Register new user" />
	<cfset stURL["url"] = application.fapi.getLink(type="farUser",view="registerNewUser") />
	<cfset arrayappend(aURLs,stURL) />
	
	<cfset arrayappend(aURLs,stURL) />
	
	<cfoutput><iframe height="1" width="1" id="walker"></iframe></cfoutput>
	<skin:onReady><cfoutput>
		var aURLs = #serializeJSON(aURLs)#;
		var thisurl = 0;
		var walkInterval = setInterval(function(){
			$j("##walker").attr("src",aURLs[thisurl].url);
			$j("##walked").append("<li><a href='"+aURLs[thisurl].url+"'>"+aURLs[thisurl].label+"</a></li>");
			thisurl += 1;
			if (thisurl == aURLs.length) {
				clearInterval(walkInterval);
				$j("##walker").remove();
				$j("##walked").append("<li>DONE</li>");
			}
		},10000);
	</cfoutput></skin:onReady>
</ft:processform>

<admin:footer>

<cfsetting enablecfoutputonly="false" />