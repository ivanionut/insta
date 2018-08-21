<cfif NOT isDefined("session.user")>
	<cflocation url="index.cfm?dsp=slim_login" addtoken="no">
</cfif>

<cfquery datasource="#request.dsn#">
	UPDATE items
	SET bonanza_bidder = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bonanza_bidder#">
	WHERE item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>

<cfif isDefined("attributes.admin")>
	<cfset _machine.cflocation = "index.cfm?dsp=management.items.edit&item=#attributes.item#">
<cfelse>
	<cfset _machine.cflocation = "index.cfm?dsp=management.items.detail&item=#attributes.item#">
</cfif>
