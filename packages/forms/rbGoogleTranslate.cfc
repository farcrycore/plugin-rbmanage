<cfcomponent displayname="Google Translate" hint="UI for translating existing bundles into new languages with Google Translate" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="location" type="string" ftType="list" ftListData="getLocations" ftLabel="Location" />
	
	<cfproperty name="langFrom" type="string" ftType="list" ftListData="getGTLanguages" ftDefault="listfirst(application.config.general.locale,'_')" ftDefaultType="evaluate" ftLabel="Source Language" />
	<cfproperty name="langTo" type="string" ftType="list" ftListData="getGTLanguages" ftLabel="Target Language" />
	
	<cfproperty name="targetLocale" type="string" ftType="list" ftListData="getLocales" ftLabel="Target Locale" />
	
	
	<cffunction name="getLocations" access="public" output="false" returntype="query" description="Returns the possible locations">
		
		<cfreturn application.fc.lib.rb.getLocations() />
	</cffunction>
	
	<cffunction name="getGTLanguages" access="public" output="false" returntype="string" description="Returns the Google Translate supported languages">
		<cfset var result = "" />
		
		<cfset result = listappend(result,"af:Afrikaans") />
		<cfset result = listappend(result,"sq:Albanian") />
		<cfset result = listappend(result,"am:Amharic") />
		<cfset result = listappend(result,"ar:Arabic") />
		<cfset result = listappend(result,"hy:Armenian") />
		<cfset result = listappend(result,"az:Azerbaijani") />
		<cfset result = listappend(result,"eu:Basque") />
		<cfset result = listappend(result,"be:Belarusian") />
		<cfset result = listappend(result,"bn:Bengali") />
		<cfset result = listappend(result,"bh:Bihari") />
		<cfset result = listappend(result,"bg:Bulgarian") />
		<cfset result = listappend(result,"my:Burmese") />
		<cfset result = listappend(result,"ca:Catalan") />
		<cfset result = listappend(result,"chr:Cherokee") />
		<cfset result = listappend(result,"zh:Chinese") />
		<cfset result = listappend(result,"zh-CN:Chinese Simplified") />
		<cfset result = listappend(result,"zh-TW:Chinese Traditional") />
		<cfset result = listappend(result,"hr:Croatian") />
		<cfset result = listappend(result,"cs:Czech") />
		<cfset result = listappend(result,"da:Danish") />
		<cfset result = listappend(result,"dv:Dhivehi") />
		<cfset result = listappend(result,"nl:Dutch") />
		<cfset result = listappend(result,"en:English") />
		<cfset result = listappend(result,"eo:Esperanto") />
		<cfset result = listappend(result,"et:Estonian") />
		<cfset result = listappend(result,"tl:Filipino") />
		<cfset result = listappend(result,"fi:Finnish") />
		<cfset result = listappend(result,"fr:French") />
		<cfset result = listappend(result,"gl:Galician") />
		<cfset result = listappend(result,"ka:Georgian") />
		<cfset result = listappend(result,"de:German") />
		<cfset result = listappend(result,"el:Greek") />
		<cfset result = listappend(result,"gn:Guarani") />
		<cfset result = listappend(result,"gu:Gujarati") />
		<cfset result = listappend(result,"iw:Hebrew") />
		<cfset result = listappend(result,"hi:Hindi") />
		<cfset result = listappend(result,"hu:Hungarian") />
		<cfset result = listappend(result,"is:Icelandic") />
		<cfset result = listappend(result,"id:Indonesian") />
		<cfset result = listappend(result,"iu:Inuktitut") />
		<cfset result = listappend(result,"ga:Irish") />
		<cfset result = listappend(result,"it:Italian") />
		<cfset result = listappend(result,"ja:Japanese") />
		<cfset result = listappend(result,"kn:Kannada") />
		<cfset result = listappend(result,"kk:Kazakh") />
		<cfset result = listappend(result,"km:Khmer") />
		<cfset result = listappend(result,"ko:Korean") />
		<cfset result = listappend(result,"ku:Kurdish") />
		<cfset result = listappend(result,"ky:Kyrgyz") />
		<cfset result = listappend(result,"lo:Laothian") />
		<cfset result = listappend(result,"lv:Latvian") />
		<cfset result = listappend(result,"lt:Lithuanian") />
		<cfset result = listappend(result,"mk:Macedonian") />
		<cfset result = listappend(result,"ms:Malay") />
		<cfset result = listappend(result,"ml:Malayalam") />
		<cfset result = listappend(result,"mt:Maltese") />
		<cfset result = listappend(result,"mr:Marathi") />
		<cfset result = listappend(result,"mn:Mongolian") />
		<cfset result = listappend(result,"ne:Nepali") />
		<cfset result = listappend(result,"no:Norwegian") />
		<cfset result = listappend(result,"or:Oriya") />
		<cfset result = listappend(result,"ps:Pashto") />
		<cfset result = listappend(result,"fa:Persian") />
		<cfset result = listappend(result,"pl:Polish") />
		<cfset result = listappend(result,"pt-PT:Portuguese") />
		<cfset result = listappend(result,"pa:Punjabi") />
		<cfset result = listappend(result,"ro:Romanian") />
		<cfset result = listappend(result,"ru:Russian") />
		<cfset result = listappend(result,"sa:Sanskrit") />
		<cfset result = listappend(result,"sr:Serbian") />
		<cfset result = listappend(result,"sd:Sindhi") />
		<cfset result = listappend(result,"si:Sinhalese") />
		<cfset result = listappend(result,"sk:Slovak") />
		<cfset result = listappend(result,"sl:Slovenian") />
		<cfset result = listappend(result,"es:Spanish") />
		<cfset result = listappend(result,"sw:Swahili") />
		<cfset result = listappend(result,"sv:Swedish") />
		<cfset result = listappend(result,"tg:Tajik") />
		<cfset result = listappend(result,"tl:Tagalog") />
		<cfset result = listappend(result,"te:Telugu") />
		<cfset result = listappend(result,"th:Thai") />
		<cfset result = listappend(result,"bo:Tibetan") />
		<cfset result = listappend(result,"tr:Turkish") />
		<cfset result = listappend(result,"uk:Ukrainian") />
		<cfset result = listappend(result,"ur:Urdu") />
		<cfset result = listappend(result,"uz:Uzbek") />
		<cfset result = listappend(result,"ug:Uighur") />
		<cfset result = listappend(result,"vi:Vietnamese") />
		<cfset result = listappend(result,"cy:Welsh") />
		<cfset result = listappend(result,"yi:Yiddish") />
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="getLocales" access="public" output="false" returntype="query" hint="Returns the list of supported locales">
		
		<cfreturn application.fc.lib.rb.getLocales() />
	</cffunction>
	
	<cffunction name="process" access="public" output="false" returntype="struct">
		<cfargument name="stProperties" type="struct" required="true" />
		
		<cfset var qKeys = application.rb.getCurrentKeys(location=stProperties.location) />
		<cfset var url = "" />
		<cfset var cfhttp = structnew() />
		<cfset var thispage = 0 />
		<cfset var stTranslations = "" />
		<cfset var i = 0 />
		
		<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
		
		<cfquery dbtype="query" name="qKeys">
			select	[key],[value],'' as [translation]
			from	qKeys
		</cfquery>
		
		<!--- &q=hello%20world&q=goodbye --->
		<cfloop from="0" to="#int(qKeys.recordcount / 100)#" index="thispage">
			<cfif qKeys.recordcount gt thispage*100>
				<cfhttp url="http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair=#arguments.stProperties.langFrom#%7C#arguments.stProperties.langTo#" method="POST">
					<cfloop query="qKeys">
						<cfif qKeys.currentrow gt thispage * 100 and qKeys.currentrow lte (thispage+1)*100>
							<cfhttpparam type="formfield" name="q" encoded="true" value="#qKeys.value#" />
						</cfif>
					</cfloop>
				</cfhttp>
				
				<cfif cfhttp.statuscode eq "200 OK">
					<cfset stTranslations = DeserializeJSON(cfhttp.filecontent) />
					<cfloop from="1" to="#arraylen(stTranslations.responseData)#" index="i">
						<cfset querysetcell(qKeys,"translation",rereplace(stTranslations.responseData[i].responseData.translatedText,"\((\d+)\)","{$1}","ALL"),thispage*100+i) />
					</cfloop>
				</cfif>
				
				<cfset oThread = CreateObject("java", "java.lang.Thread") />
				<cfset oThread.sleep(1000) />
			</cfif>
		</cfloop>
		
		<cfquery dbtype="query" name="qKeys">
			select	[key],[translation] as [value],[value] as [original]
			from	qKeys
		</cfquery>
		
		<cfset updates = application.rb.setKeys(arguments.stProperties.location,arguments.stProperties.targetLocale,qKeys,false) />
		
		<skin:bubble message="#application.fapi.getResource(key='rbmanage.messages.googletranslatecomplete@text',default='Base bundle has been translated. NOTE: Resource bundle changes have NOT been saved to file.')#" />
		
		<cfreturn arguments.stProperties />
	</cffunction>
	
</cfcomponent>