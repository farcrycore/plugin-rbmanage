<cfsetting enablecfoutputonly="true" requesttimeout="1000" />
<!--- @@displayname: Google Translation --->

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<admin:header />

<admin:resource key="rbmanage.headings.googletranslate@text"><cfoutput><h1>Google Translate</h1></cfoutput></admin:resource>
<admin:resource key="rbmanage.messages.googletranslate@text">
	<cfoutput><p>This utility can quickly fill out a new language bundle with translations from the <a href="http://code.google.com/apis/ajaxlanguage/">Google Translate API</a>. While these translations are not typically high quality, they can be a good place to start.</p></cfoutput>
</admin:resource>

<ft:processform action="Translate">
	<ft:processformobjects typename="rbGoogleTranslate" />
</ft:processform>

<ft:form>
	<ft:object typename="rbGoogleTranslate" key="translate" lFields="location,langFrom,langTo,targetLocale" />
	
	<ft:buttonPanel>
		<ft:button value="Translate" />
	</ft:buttonPanel>
</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />