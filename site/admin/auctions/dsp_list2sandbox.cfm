<cfif NOT isAllowed("Lister_ListAuction")>
	<cflocation url="index.cfm?dsp=slim_login" addtoken="no">
</cfif>

<cfparam name="attributes.CallName" default="VerifyAddItem">
<cfparam name="attributes.sandbox" default="true" type="boolean">
<cfsavecontent variable="cntDescription">
	<cfinclude template="layout/show.cfm">
</cfsavecontent>
<cfinclude template="get_item.cfm">
<cfif attributes.sandbox>
	<cfoutput><h1 style="color:blue;">SANDBOX ENVIRONMENT</h1></cfoutput>
<!---
<cfelse>
	<cfoutput><h1 style="color:green;">PRODUCTION ENVIRONMENT</h1></cfoutput>
--->
</cfif>



<cfinclude template="act_build_item.cfm">
<cfset _ebay.XMLRequest = toString(xmlDoc)>
<cfset _ebay.SiteID = sqlAuction.SiteID>
<cfinclude template="../../api/act_call.cfm">
<cfset _ebay.SiteID = 0>
<cfif NOT isDefined("_ebay.xmlResponse") OR (_ebay.Ack EQ "failure")>
	<cfif StructKeyExists(_ebay, "xmlResponse")>
		<cfoutput><h1 style="color:red;">API call failed :(</h1></cfoutput>
		<cfloop index="i" from="1" to="#ArrayLen(_ebay.xmlResponse.xmlRoot.Errors)#">
			<cfoutput>
			<h2 style="color:red;">#_ebay.xmlResponse.xmlRoot.Errors[i].SeverityCode.xmlText#: #_ebay.xmlResponse.xmlRoot.Errors[i].ShortMessage.xmlText#</h2>
			<h3>#HTMLEditFormat(_ebay.xmlResponse.xmlRoot.Errors[i].LongMessage.xmlText)#</h3>
			</cfoutput>
			<cfif StructKeyExists(_ebay.xmlResponse.xmlRoot.Errors[i], "ErrorParameters")>
				<cfoutput><ul>Error Parameters:</cfoutput>
				<cfloop index="j" from="1" to="#ArrayLen(_ebay.xmlResponse.xmlRoot.Errors[i].ErrorParameters)#">
					<cfoutput><li>#HTMLEditFormat(_ebay.xmlResponse.xmlRoot.Errors[i].ErrorParameters[j].Value.xmlText)#</li></cfoutput>
				</cfloop>
				<cfoutput></ul></cfoutput>
			</cfif>
		</cfloop>
	<cfelse>
		<cfoutput>
		<h1 style="color:red;">API call failed: #err_message#</h1>
		<b>Error Details:</b><br>
		#err_detail#
		</cfoutput>
	</cfif>
	<cfif isDefined("attributes.debug")>
		<cfoutput><h1>DEBUG INFO</h1></cfoutput>
		<cfdump var="#_ebay#">
	</cfif>
<cfelse>
	<cfinclude template="dsp_list_item_result.cfm">
</cfif>
<cfif attributes.sandbox>
	<cfset _ebay = Duplicate(_TMP)>
</cfif>
