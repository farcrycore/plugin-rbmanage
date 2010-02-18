<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<!--- set up page header --->
<admin:header title="Save resource bundles" />

<admin:resource key="rbmanage.headings.savebundles@text"><cfoutput><h1>Save Bundles</h1></cfoutput></admin:resource>

<ft:processform action="Save Bundles">
	<ft:processformobjects typename="rbSaveBundles" />
</ft:processform>

<ft:form>
	<ft:object typename="rbSaveBundles" key="savebundles" lFields="keys" />
	
	<ft:buttonPanel>
		<ft:button value="Save Bundles" />
	</ft:buttonPanel>
</ft:form>

<admin:footer />

<cfsetting enablecfoutputonly="false" />