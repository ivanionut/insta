﻿<!--- here is where the amazon items_itemid will be updated --->
<cfif NOT isAllowed("Items_ChangeStatus") AND NOT isAllowed("Items_NormalChangeStatus")>
	<cflocation url="index.cfm?dsp=slim_login" addtoken="no">
</cfif>


<cfparam name="attributes.byrOrderQtyToShip" default="1" >

<!--- manage items permission --->
<cfif not isAllowed("Items_EditDescriptions")>
	<cflocation url="index.cfm?dsp=slim_login" addtoken="no">
</cfif>

<!--- to be consistent with attrib attributes.item--->
<cfset attributes.item = attributes.instaItemid>


<!--- check that item number entered is not in use by another amazon order --->
<cfquery name="chk_amazon_itemid" datasource="#request.dsn#">
	select items_itemid from amazon_items
	where items_itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.item)#">
	and amazon_item_amazonorderid != '#attributes.amazonorderid#' <!--- select only other amazon orderid se we can keep on entering the same id --->
</cfquery>
<cfif chk_amazon_itemid.RecordCount gte 1 >
	<!--- the item number entered is already in use lets not update and relocate --->
	<cfset _machine.cflocation = "index.cfm?dsp=amazon_live.dsp_link_to_item&amazon_item=#attributes.amazonorderid#&msg=3">


<cfelse>
<!--- no error lets update --->
<cfparam name="attributes.offebay" default="1">
<cfparam name="attributes.itemCondition" default="Amazon">
<cfset LogAction("edited item #attributes.instaItemid# linked to amazon #attributes.amazonorderid#")>

<cftransaction>
<!--- link to insta itemid --->
<cfquery datasource="#request.dsn#">
	UPDATE amazon_items
	set items_itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">,
	amazon_item_orderstatus = 'awaitingTrackingNum'
	where amazon_item_amazonorderid = '#attributes.amazonorderid#'
</cfquery>

<!--- get the amazon details --->
<!--- This will be the link the amazon item to insta item. --->
<cfquery name="get_amazondtls" datasource="#request.dsn#">
	select
	   amazon_item_pkid
      ,amazon_item_amazonorderid
      ,amazon_item_asin
      ,amazon_item_sellersku
      ,amazon_item_title
      ,amazon_item_quantityordered
      ,amazon_item_quantityshipped
      ,amazon_item_giftmessagetext
      ,amazon_item_itemprice
      ,amazon_item_shippingprice
      ,amazon_item_giftwrapprice
      ,amazon_item_itemtax
      ,amazon_item_shippingtax
      ,amazon_item_giftwraptax
      ,amazon_item_shippingdiscount
      ,amazon_item_promotiondiscount
      ,amazon_account_pkid
      ,amazon_item_sellerorderid
      ,amazon_item_purchasedate
      ,amazon_item_lastupdatedate
      ,amazon_item_orderstatus
      ,amazon_item_fulfillmentchannel
      ,amazon_item_saleschannel
      ,amazon_item_orderchannel
      ,amazon_item_shipservicelevel
      ,amazon_item_shippingaddress_name
      ,amazon_item_shippingaddress_addressline1
      ,amazon_item_shippingaddress_addressline2
      ,amazon_item_shippingaddress_addressline3
      ,amazon_item_shippingaddress_city
      ,amazon_item_shippingaddress_county
      ,amazon_item_shippingaddress_district
      ,amazon_item_shippingaddress_stateorregion
      ,amazon_item_shippingaddress_postalcode
      ,amazon_item_shippingaddress_countrycode
      ,amazon_item_shippingaddress_phone
      ,amazon_item_numberofitemsshipped
      ,amazon_item_numberofitemsunshipped
      ,amazon_item_ordertotal_currencycode
      ,amazon_item_ordertotal_amount
      ,amazon_item_apiStatusFlag
      ,items_itemid
    from amazon_items
	where amazon_item_amazonorderid = '#attributes.amazonorderid#'
</cfquery>





<!--- update to internal_itemCondition --->
<cfquery datasource="#request.dsn#">
	update items
	set internal_itemCondition = '#attributes.itemCondition#',
	status = '10',<!--- update to awaiting shipment --->
	Internal_itemsku = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_sellersku#">,
	paid = '1',
	offebay = '#attributes.offebay#', <!--- set to 1 for item not ebay sold --->
	PaidTime = '#get_amazondtls.amazon_item_purchasedate#', <!--- use the date of purchasedate from amazon --->
	byrName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_name#">,
	byrStreet1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_addressline1#">,
	byrStreet2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_addressline2#">,
	byrCityName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_city#">,
	byrStateOrProvince = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_stateorregion#">,
	byrCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_countrycode#">,
	byrPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_phone#">,
	byrPostalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_amazondtls.amazon_item_shippingaddress_postalcode#">,
	byrCompanyName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.amazonorderid#">,
	byrOrderQtyToShip = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.byrOrderQtyToShip#">,
	ShipCharge = #get_amazondtls.amazon_item_shippingprice#,
	dlid = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	ShippedTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">

	WHERE item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>

<cfquery name="sqlRecord" datasource="#request.dsn#">
	SELECT * FROM records
	WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>
<cfif sqlRecord.RecordCount EQ 0>
	<cfquery name="sqlRecord" datasource="#request.dsn#">
		INSERT INTO records
		(itemid, [desc], aid, dstarted, dended, checksent, highbidder)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">,
			'AUTO-GENERATED DESCRIPTION FOR MISSING RECORD',
			<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.item, 2, '.')#">,
			NULL, NULL, '0', ''
		)
	</cfquery>
</cfif>

<!--- update records. this is also done in update item when editing --->
<cfset attributes.price = REReplace(get_amazondtls.amazon_item_ordertotal_amount, "[^0-9\.]*", "", "ALL")>
<cfif attributes.price EQ "">
	<cfset attributes.price = 0>
</cfif>
<cfquery datasource="#request.dsn#">
	UPDATE records
	SET finalprice = '#attributes.price#',
		dended = <cfif isDate(get_amazondtls.amazon_item_purchasedate)>'#get_amazondtls.amazon_item_purchasedate#'<cfelse>'#get_amazondtls.amazon_item_purchasedate#'</cfif>
	WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>
</cftransaction>

<cfset _machine.cflocation = "index.cfm?dsp=amazon_live.dsp_link_to_item&amazon_item=#attributes.amazonorderid#&msg=1&item=#attributes.item#">
</cfif>