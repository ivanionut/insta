<cfif isDefined("attributes.finish")>
	<cfset _machine.cflocation = "index.cfm?dsp=management.items.awaiting_listing">
<cfelseif isDefined("attributes.ItemSpecific")>
	<cfset _machine.cflocation = "index.cfm?dsp=admin.auctions.item_specific&item=#attributes.item#">
<cfelse>
	<cfset _machine.cflocation = "index.cfm?dsp=admin.auctions.step2&item=#attributes.item#">
</cfif>

<cfquery datasource="#request.dsn#" name="sqlCurrent">
	SELECT CategoryID, ebayaccount
	FROM auctions
	WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>

<cfif isDefined("attributes.ebayaccount")>
	<cfquery datasource="#request.dsn#" name="sqlDef">
		SELECT location
		FROM ebaccounts
		WHERE eBayAccount = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ebayaccount#">
	</cfquery>
</cfif>



<cfquery datasource="#request.dsn#">
	UPDATE auctions
	SET Title			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Title#" maxlength="80">,
		SubTitle		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SubTitle#" maxlength="55">,
		videoURL		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.videoURL#" maxlength="250">,
		SiteID			= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SiteID#">,
		CategoryID		= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CategoryID#">,
		StoreCategoryID	= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.StoreCategoryID#">,
		StoreCategory2ID	= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.StoreCategory2ID#">,
		Description		= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.Description#">,
		scheduledBy		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(session.user.first, 1)##Left(session.user.last, 1)#">
	<!--- clear Item Specific when category changed --->
	<cfif (sqlCurrent.RecordCount NEQ 0) AND (sqlCurrent.CategoryID NEQ attributes.CategoryID)>
		, AttributeSetArray = NULL
	</cfif>
	<!--- clear Item Specific when category changed --->
	<cfif isDefined("attributes.ebayaccount")>
		, ebayaccount = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ebayaccount#">
		<cfif sqlCurrent.ebayaccount NEQ attributes.ebayaccount><!--- 20120517: vlad fix coz the location of the ebay account is not carrying over. added an cflese but basically the conidition should have been removed --->
			, location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sqlDef.location#">
		<cfelse>
			, location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sqlDef.location#">
		</cfif>
	</cfif>
	WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>


<cfloop index="i" from="#ArrayLen(application.recentCategories)#" to="1" step="-1">
	<cfif application.recentCategories[i].CategoryID EQ attributes.CategoryID>
		<cfset ArrayDeleteAt(application.recentCategories, i)>
	</cfif>
</cfloop>

<cfquery name="sqlCategory" datasource="#request.dsn#">
	SELECT CategoryName
	FROM ebcategories
	WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CategoryID#">
		AND SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SiteID#">
</cfquery>

<cfscript>
	tmp = StructNew();
	tmp.CategoryID = attributes.CategoryID;
	tmp.CategoryName = sqlCategory.CategoryName;
	ArrayPrepend(application.recentCategories, tmp);
	for(i=ArrayLen(application.recentCategories); i GT _vars.lister.maxRecentCategories; i=i-1){
		ArrayDeleteAt(application.recentCategories, i);
	}
</cfscript>

<cftry>
	<cfinclude template="act_GetCategory2CS.cfm"><!--- TODO DEBUG --->
	<cfcatch type="any">
		<!--- do nothing --->
	</cfcatch>
</cftry>

<cfquery name="sqlItemSpecific" datasource="#request.dsn#">
	SELECT COUNT(*) AS cnt
	FROM category2cs
	WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#attributes.CategoryID#">
</cfquery>

<cfif sqlItemSpecific.cnt EQ 0>
	<cfset _machine.cflocation = "index.cfm?dsp=admin.auctions.step2&item=#attributes.item#">
</cfif>
