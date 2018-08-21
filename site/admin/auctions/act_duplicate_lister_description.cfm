<!---
Script Description: this script was copied from site\admin\auctions\act_duplicate.cfm.
It was edited so that when we duplicate we will use the description of the attributes.newitem instead of the attributes.item.
--->
<cfparam name="attributes.showSearchAgain" default="">
<cfparam name="attributes.recentSearch" default="">

<cfif NOT isAllowed("Lister_CreateAuction")>
	<cflocation url="index.cfm?dsp=slim_login&next_dsp=#attributes.dsp#" addtoken="no">
</cfif>
<cfset _machine.cflocation = "index.cfm?dsp=" & attributes.dsp>
<cfparam name="attributes.customitem" default="">
<cfif attributes.customitem NEQ "">
	<cfset attributes.newitem = attributes.customitem>
</cfif>


<cfif attributes.showSearchAgain NEQ "">
	<cfset _machine.cflocation = _machine.cflocation & "&showSearchAgain=#attributes.showSearchAgain#" & "&srch=#attributes.recentSearch#" & "&srchfield=all">
</cfif>

<cfif NOT isDefined("attributes.multidup")>
	<cfset attributes.multidup = 0>
	<cfset attributes.item_0 = attributes.item>
	<cfset attributes.newitem_0 = attributes.newitem>
</cfif>



<cfloop index="i" list="#attributes.multidup#">
	<cfset attributes.item = attributes["item_#i#"]>
	<cfset attributes.newitem = attributes["newitem_#i#"]>

	<cfquery datasource="#request.dsn#" name="sqlDefault">
		SELECT item, title, description, weight, weight_oz, bold, border, highlight, startprice_real, startprice, buy_it_now, internal_itemCondition, age,
		itemManual, itemComplete, itemTested, retailPackingIncluded, specialNotes, 
		internalShipToLocations, sub_description
		FROM items
		WHERE item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">
	</cfquery>

	<cfquery datasource="#request.dsn#" name="getWeight">
		SELECT  weight,weight_oz,startprice_real
		FROM items
		WHERE item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
	</cfquery>




<cfset thisDescription = "#_vars.lister.descriptionBegin#">
<cfset thisWeight = "0">
<cfset thisWeight_oz = "0">
<cfif getWeight.recordcount gte 1>
	<cfset thisWeight = getWeight.weight >
	<cfset thisWeight_oz = getWeight.weight_oz >
</cfif>

<cfif sqlDefault.recordcount gte 1 >

	<cfset DynamicDescription = #Replace(_vars.lister.descriptionBegin, '{Description}', sqlDefault.description, 'ALL')#>
	<cfset DynamicDescription = #Replace(DynamicDescription, '{internal_item_condition}', sqlDefault.internal_itemCondition, 'ALL')#>
	<cfset DynamicDescription = #Replace(DynamicDescription, '{item_title}', sqlDefault.title, 'ALL')#>
	<cfset DynamicDescription = #Replace(DynamicDescription, '{itemManual}', YesNoFormat(sqlDefault.itemManual), 'ALL')#>
	<cfset DynamicDescription = #Replace(DynamicDescription, '{itemComplete}', YesNoFormat(sqlDefault.itemComplete), 'ALL')#>
	<cfset DynamicDescription = #Replace(DynamicDescription, '{itemTested}', YesNoFormat(sqlDefault.itemTested), 'ALL')#>
	<cfset DynamicDescription = #Replace(DynamicDescription, '{retailPackingIncluded}', YesNoFormat(sqlDefault.retailPackingIncluded), 'ALL')#>
	<cfset DynamicDescription = #Replace(DynamicDescription, '{retailPrice}', sqlDefault.age, 'ALL')#>
	<cfset DynamicDescription =	#Replace(DynamicDescription, '{Sub_item_Description}', sqlDefault.sub_description, 'ALL')#>
	<cfif sqlDefault.specialNotes eq "">
		<cfset sqlDefault.specialNotes = "N/A">
	</cfif>
	<cfset DynamicDescription =  #Replace(DynamicDescription, '{specialNotes}', sqlDefault.specialNotes, 'ALL')#>
	<cfset thisDescription = DynamicDescription >
	<cfset thisWeight = "#sqlDefault.weight#">
</cfif>




<cftransaction >


<!---vry CARRY OVER THE ITEM SPECIFICS IN DUPLICATE AUCTION STARTS--->

<!---vry lets check first if there is existing itemspecifcs in the db for this itemid--->
<!--- 20130529 patrick wanted to change this: [10:10:28 PM | Edited 10:12:22 PM] Patrick Kelley: We want to use the item specifics that are connected to the item when we create it when availiable instead of the ones that are linked to the item we are duplicating with  --->
<!---<cfquery datasource="#request.dsn#" name="chk_itemspecifics">
	select * from auction_itemspecifics
	where itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">
</cfquery>	--->

<!---
	<cfif chk_itemspecifics.recordcount gte 1>
	<!---vry if there is existing lets delete and might replace with incoming or none --->
	<cfquery datasource="#request.dsn#">
		DELETE from auction_itemspecifics
		where itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">
	</cfquery>
</cfif>
--->


<!---vry pull in the itemspecifics for this item --->
<!---<cfquery name="getItemSpecifics" datasource="#request.dsn#">
	Select *
	FROM auction_itemspecifics
	WHERE 1=1
	<!--- if category id is 0 --->
	and itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">
</cfquery>

<cfif getItemSpecifics.RecordCount gte 1>
<cfloop query="getItemSpecifics">
<!---vry lets insert to db:auction_itemspecifics --->
	<cfquery datasource="#request.dsn#">
		 insert into auction_itemspecifics
		(itemid,iname,ivalue,selection_mode)
		values
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#getItemSpecifics.iname#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#getItemSpecifics.ivalue#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#getItemSpecifics.selection_mode#">
		)
	</cfquery>
</cfloop>
</cfif>--->
<!---vry CARRY OVER THE ITEM SPECIFICS IN DUPLICATE AUCTION ENDS--->


	<cfquery datasource="#request.dsn#" name="getStartPrice">
		SELECT startprice_real
		FROM items
		WHERE item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">
	</cfquery>


	<cfquery datasource="#request.dsn#">
		DELETE FROM auctions WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">
	</cfquery>
	<cfquery datasource="#request.dsn#">
		INSERT INTO auctions
		(
			itemid, ebayitem, Title, SubTitle, SiteID, CategoryID, StoreCategoryID, StoreCategory2ID, Description, ListingType,
			StartingPrice, ReservePrice, BuyItNowPrice, Duration, Layout, Bold, Border, Highlight, FeaturedPlus,
			PrivateAuctions, PaymentMethods, WhoPaysShipping, ShippingServiceCost, PackedWeight, PackedWeight_oz, PackageSize, ready, sandbox, GalleryImage,
			imagesLayout, location, scheduledBy, ShipToLocations, AttributeSetArray, LocalPickUp, use_pictures, ebayaccount, videoURL, ConditionID, conditionName,upc
		)
		SELECT
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#"> AS itemid,
			ebayitem, Title, SubTitle, SiteID, CategoryID, StoreCategoryID, StoreCategory2ID,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#thisDescription#"> As Description,
			ListingType,
			<!---StartingPrice patrick requested this 20110826---><cfqueryparam cfsqltype="cf_sql_varchar" value="#getStartPrice.startprice_real#"> AS StartingPrice,
			ReservePrice, BuyItNowPrice, Duration, Layout, Bold, Border, Highlight, FeaturedPlus,
			PrivateAuctions, PaymentMethods, WhoPaysShipping, ShippingServiceCost,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#thisWeight#"> As PackedWeight,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#thisWeight_oz#"> As PackedWeight_oz,
			PackageSize, ready, sandbox, GalleryImage,
			imagesLayout, location, scheduledBy, ShipToLocations, AttributeSetArray, LocalPickUp,
			CASE WHEN LEN(use_pictures) > 0
				THEN use_pictures
				ELSE itemid
			END AS use_pictures, ebayaccount, videoURL,ConditionID,conditionName,upc
		FROM auctions
		WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
	</cfquery>



	<cfset LogAction("duplicated auction #attributes.item# to #attributes.newitem#")>
	<cfif FileExists("#request.basepath#images/#attributes.newitem#/1.jpg")>
		<cfquery datasource="#request.dsn#">
			UPDATE auctions
			SET use_pictures = NULL
			WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.newitem#">
		</cfquery>
	</cfif>

</cftransaction>

</cfloop>
