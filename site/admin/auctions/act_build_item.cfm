<!--- TODO
<cfquery datasource="#request.dsn#" name="sqlItem">
	SELECT width, height, depth
	FROM items
	WHERE item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>
--->

<!--- vlad added get auction itemspecifics --->
<cfquery name="get_Return_Policy_days" datasource="#request.dsn#">
	SELECT avalue FROM settings
	WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="lister.Return_Policy_days">
</cfquery>
<cfif get_Return_Policy_days.recordcount gte 1>
	<cfset Return_Policy_days = get_Return_Policy_days.avalue>
<cfelse>
	<cfset Return_Policy_days = 14 ><!--- default to 14 --->
</cfif>


<!--- no return policy --->
<!--- vlad added get auction itemspecifics --->
<cfquery name="get_ReturnsAccepted" datasource="#request.dsn#">
	SELECT avalue FROM settings
	WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="lister.ReturnsAccepted">
</cfquery>
<cfif get_ReturnsAccepted.recordcount gte 1>
	<cfset ReturnsAccepted = get_ReturnsAccepted.avalue>
<cfelse>
	<cfset ReturnsAccepted = "ReturnsAccepted" >
</cfif>

<cfscript>
if(attributes.sandbox){
	_TMP = Duplicate(_ebay);
	_ebay.URL					= "https://api.sandbox.ebay.com/ws/api.dll";
	// SANDBOX CREDENTIALS
	/*
	_ebay.UserID				= "rs_test";
	_ebay.UserName				= "Dreamer020576";
	_ebay.Password				= "1234567890";
	_ebay.DeveloperName			= "X1RB3J9JI6L56K11LA34I8513618YB";
	_ebay.ApplicationName		= "ROSASOFTL6M215TLCYVUA8LT6H6LB5";
	_ebay.CertificateName		= "B8511D24A85$6LL91A3S3-R31GW9M2";
	_ebay.RequestToken			= "AgAAAA**AQAAAA**aAAAAA**aIu9Rw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wJnY+lCpSLqQSdj6x9nY+seQ**G1EAAA**AAMAAA**zmrzHwWFry7bmGH0umABMNRveYYu0dzlU60gdDh0Q9RXziBymTZ1U4sDan7aTs8m0ABbBEusLq0OEVME34qDTy1gCKnwVkZmAM6kbKPhevpyvNw8KaIAh70RXWaMwiG8H1B983cHsAa9rqL3T/Qlxae8TrlidZ1ahVqwxqlOx47FBYwKdHAH36DFxlUkxcPCicnhTwR4T+qaTJuM7poPZEimSaXycX4VYFt1pUEDBj6VrByA6kyJqP4oI2XK3ow0ZVF+D+e3ZSLeQ3pE4Wj6KNkf+rizAp4HQ04tKLtlGBpmBo5iWD8ym6YXv9xcg3Uo2N+3/Pn5JugMTWGWnFQGRM8A/rQwpK7OBAH8/1klErd0IpU/c66uJZ7QzI1FGhC8sxBKuEDNht8JJM7CzmhNqDnmcBW73Rk4m5lNKcCyBTVy3axDT+Up/JOXbhyJjz0O9WZJ79YIl5qgYXC9RtJIAVmpWRPRrdqaq3+t1yf1hmfqjDj6DNRMWBOzSkbVib4elhHhSs8NDBqfGwXb9EL8A3eKiIdXryQywix43dDieV/YWIfPhbJVRojPseDAh6SMttoD0RubtsTeD6JCHEAnxYO03JNf5z2+vsaoB7vq58qE8Td4uGuL7ji9hrlAxzQ1RjvmhSSnLeGKzEPKQnfEnb9FTAaSmrYopZ2UC9PeWt0VVcFWoyrS12+lzT62gKJwLUepEHoH0zpv6CjjqvUaMP1ZMpRjCwNanDQ/e6t0cvl4CgO+yOptq8N+YtV0Yh+j";
	_ebay.VIEW_ITEM_URL			= "http://cgi.sandbox.ebay.com/ws/eBayISAPI.dll?ViewItem&item=";
	*/
	_ebay.UserID				= "redhot2323";
	_ebay.UserName				= "redhot2323";
	_ebay.Password				= "Aftersix2323!";
	_ebay.DeveloperName			= "bf627406-f1df-4025-b087-ed06159110f4";
	_ebay.ApplicationName		= "Companyn-1830-4d72-882a-3173c7cf92c9";
	_ebay.CertificateName		= "9b062ef2-1713-4077-bd78-9638bfe15334";
	_ebay.RequestToken			= "AgAAAA**AQAAAA**aAAAAA**aIu9Rw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wJnY+lCpSLqQSdj6x9nY+seQ**G1EAAA**AAMAAA**zmrzHwWFry7bmGH0umABMNRveYYu0dzlU60gdDh0Q9RXziBymTZ1U4sDan7aTs8m0ABbBEusLq0OEVME34qDTy1gCKnwVkZmAM6kbKPhevpyvNw8KaIAh70RXWaMwiG8H1B983cHsAa9rqL3T/Qlxae8TrlidZ1ahVqwxqlOx47FBYwKdHAH36DFxlUkxcPCicnhTwR4T+qaTJuM7poPZEimSaXycX4VYFt1pUEDBj6VrByA6kyJqP4oI2XK3ow0ZVF+D+e3ZSLeQ3pE4Wj6KNkf+rizAp4HQ04tKLtlGBpmBo5iWD8ym6YXv9xcg3Uo2N+3/Pn5JugMTWGWnFQGRM8A/rQwpK7OBAH8/1klErd0IpU/c66uJZ7QzI1FGhC8sxBKuEDNht8JJM7CzmhNqDnmcBW73Rk4m5lNKcCyBTVy3axDT+Up/JOXbhyJjz0O9WZJ79YIl5qgYXC9RtJIAVmpWRPRrdqaq3+t1yf1hmfqjDj6DNRMWBOzSkbVib4elhHhSs8NDBqfGwXb9EL8A3eKiIdXryQywix43dDieV/YWIfPhbJVRojPseDAh6SMttoD0RubtsTeD6JCHEAnxYO03JNf5z2+vsaoB7vq58qE8Td4uGuL7ji9hrlAxzQ1RjvmhSSnLeGKzEPKQnfEnb9FTAaSmrYopZ2UC9PeWt0VVcFWoyrS12+lzT62gKJwLUepEHoH0zpv6CjjqvUaMP1ZMpRjCwNanDQ/e6t0cvl4CgO+yOptq8N+YtV0Yh+j";
	_ebay.VIEW_ITEM_URL			= "http://cgi.sandbox.ebay.com/ws/eBayISAPI.dll?ViewItem&item=";
}else{
	_ebay.VIEW_ITEM_URL			= "http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=";
	// LIVE CREDENTIALS
	_ebay.UserID				= sqlEBAccount.UserID;
	_ebay.UserName				= sqlEBAccount.UserName;
	_ebay.Password				= sqlEBAccount.Password;
	_ebay.DeveloperName			= sqlEBAccount.DeveloperName;
	_ebay.ApplicationName		= sqlEBAccount.ApplicationName;
	_ebay.CertificateName		= sqlEBAccount.CertificateName;
	_ebay.RequestToken			= sqlEBAccount.RequestToken;
}

_ebay.ThrowOnError	= false;
_ebay.CallName		= attributes.CallName;

xmlDoc = xmlNew();
xmlDoc.xmlRoot = xmlElemNew(xmlDoc, "#_ebay.CallName#Request");
StructInsert(xmlDoc.xmlRoot.xmlAttributes, "xmlns", "urn:ebay:apis:eBLBaseComponents");
xmlDoc.xmlRoot.RequesterCredentials = xmlElemNew(xmlDoc, "RequesterCredentials");
xmlDoc.xmlRoot.RequesterCredentials.eBayAuthToken = xmlElemNew(xmlDoc, "eBayAuthToken");
xmlDoc.xmlRoot.RequesterCredentials.eBayAuthToken.xmlText = _ebay.RequestToken;
xmlDoc.xmlRoot.Item = xmlElemNew(xmlDoc, "Item");

Item = xmlDoc.xmlRoot.Item;

Item.DispatchTimeMax = xmlElemNew(xmlDoc, "DispatchTimeMax");
/****
Patrick requested to change the handling time to 3 days. 20101129. 20101215 request to 1 day
Item.DispatchTimeMax.xmlText = "5";
***/
Item.DispatchTimeMax.xmlText = "#getVar('Shipping.PackagingHandlingTime', '2', 'NUMBER')#";


/***************** ReturnPolicy *****************/
Item.ReturnPolicy = xmlElemNew(xmlDoc, "ReturnPolicy");

Item.ReturnPolicy.Description = xmlElemNew(xmlDoc, "Description");
Item.ReturnPolicy.Description.xmlText = getVar('lister.Return_Policy', '<p>We photograph each item individually and describe it to the best of our ability. We will always try and work out any issues because we strive to have only satisfied customers! Our feedback rating supports that! </p>', 'HTML');

// Item.ReturnPolicy.EAN = xmlElemNew(xmlDoc, "EAN");
// Item.ReturnPolicy.EAN.xmlText = "TODO EAN is European Article Number";

Item.ReturnPolicy.RefundOption = xmlElemNew(xmlDoc, "RefundOption");
Item.ReturnPolicy.RefundOption.xmlText = "MoneyBack"; // Exchange, MerchandiseCredit, MoneyBack

Item.ReturnPolicy.ReturnsAcceptedOption = xmlElemNew(xmlDoc, "ReturnsAcceptedOption");
Item.ReturnPolicy.ReturnsAcceptedOption.xmlText  = ReturnsAccepted ; // ReturnsAccepted, ReturnsNotAccepted

Item.ReturnPolicy.ReturnsWithinOption = xmlElemNew(xmlDoc, "ReturnsWithinOption");
//Item.ReturnPolicy.ReturnsWithinOption.xmlText = "Days_7"; // Days_3, Days_7, Days_10, Days_14, Days_30, Days_60
Item.ReturnPolicy.ReturnsWithinOption.xmlText = "Days_#Return_Policy_days#"; // Days_3, Days_7, Days_10, Days_14, Days_30, Days_60


Item.ReturnPolicy.ShippingCostPaidByOption = xmlElemNew(xmlDoc, "ShippingCostPaidByOption");
Item.ReturnPolicy.ShippingCostPaidByOption.xmlText = "#_vars.lister.ReturnShippingCostPaidByOption#"; // Buyer, Seller

// Item.ReturnPolicy.WarrantyDurationOption = xmlElemNew(xmlDoc, "WarrantyDurationOption");
// Item.ReturnPolicy.WarrantyDurationOption.xmlText = "Months_1"; // Months_1, Months_3, Months_6, Years_1, Years_2, Years_3, Years_MoreThan3

// Item.ReturnPolicy.WarrantyOfferedOption = xmlElemNew(xmlDoc, "WarrantyOfferedOption");
// Item.ReturnPolicy.WarrantyOfferedOption.xmlText = "WarrantyOffered"; // WarrantyOffered

// Item.ReturnPolicy.WarrantyTypeOption = xmlElemNew(xmlDoc, "WarrantyTypeOption");
// Item.ReturnPolicy.WarrantyTypeOption.xmlText = "ReplacementWarranty"; // DealerWarranty, ManufacturerWarranty, ReplacementWarranty

/***************** COMMON *****************/
Item.PrimaryCategory = xmlElemNew(xmlDoc, "PrimaryCategory");
Item.PrimaryCategory.CategoryID = xmlElemNew(xmlDoc, "CategoryID");
Item.PrimaryCategory.CategoryID.xmlText = sqlAuction.CategoryID;

Item.Country = xmlElemNew(xmlDoc, "Country");
Item.Country.xmlText = "US";

Item.PostalCode = xmlElemNew(xmlDoc, "PostalCode");
//Item.PostalCode.xmlText = "40503";
Item.PostalCode.xmlText = "40356";//20130411 patrick request to change to 40356


Item.Currency = xmlElemNew(xmlDoc, "Currency");
Item.Currency.xmlText = "USD";

Item.Description = xmlElemNew(xmlDoc, "Description");
Item.Description.xmlText = cntDescription;//"<![CDATA[ #HTMLEditFormat(cntDescription)# ]]>";

Item.ListingDuration = xmlElemNew(xmlDoc, "ListingDuration");
if(sqlAuction.Duration EQ 0){
	Item.ListingDuration.xmlText = "GTC";
}else{
	Item.ListingDuration.xmlText = "Days_#sqlAuction.Duration#";
}


if (isnumeric(sqlAuction.itemQty)){
	if(sqlAuction.itemQty gt 1){
		Item.Quantity = xmlElemNew(xmlDoc, "Quantity");
		Item.Quantity.xmlText = "#sqlAuction.itemQty#";
	}else{
		Item.Quantity = xmlElemNew(xmlDoc, "Quantity");
		Item.Quantity.xmlText = "1";
	}
}else{
	Item.Quantity = xmlElemNew(xmlDoc, "Quantity");
	Item.Quantity.xmlText = "1";
}

/*
if (sqlAuction.upc neq ''){
Item.ProductListingDetails = xmlElemNew(xmlDoc, "ProductListingDetails");
//Item.ProductListingDetails.ProductReferenceID = xmlElemNew(xmlDoc, "ProductReferenceID");
//Item.ProductListingDetails.ProductReferenceID.xmlText = 0;//we need to set this to 0 for it to work
Item.ProductListingDetails.UPC = xmlElemNew(xmlDoc, "UPC");
Item.ProductListingDetails.UPC.xmlText = sqlAuction.upc;//we need to set this to 0 for it to work
Item.ProductListingDetails.IncludeStockPhotoURL = xmlElemNew(xmlDoc, "IncludeStockPhotoURL");
Item.ProductListingDetails.IncludeStockPhotoURL.xmlText = "true";//we need to set this to 0 for it to work
Item.ProductListingDetails.IncludePrefilledItemInformation = xmlElemNew(xmlDoc, "IncludePrefilledItemInformation");
Item.ProductListingDetails.IncludePrefilledItemInformation.xmlText = "true";//we need to set this to 0 for it to work
Item.ProductListingDetails.UseFirstProduct = xmlElemNew(xmlDoc, "UseFirstProduct");
Item.ProductListingDetails.UseFirstProduct.xmlText = "true";//we need to set this to 0 for it to work
Item.ProductListingDetails.UseStockPhotoURLAsGallery = xmlElemNew(xmlDoc, "UseStockPhotoURLAsGallery");
Item.ProductListingDetails.UseStockPhotoURLAsGallery.xmlText = "true";//we need to set this to 0 for it to work
Item.ProductListingDetails.ReturnSearchResultOnDuplicates = xmlElemNew(xmlDoc, "ReturnSearchResultOnDuplicates");
Item.ProductListingDetails.ReturnSearchResultOnDuplicates.xmlText = "true";//we need to set this to 0 for it to work
}
*/

if (sqlDefault.upc neq ''){
	Item.ProductListingDetails = xmlElemNew(xmlDoc, "ProductListingDetails");
	Item.ProductListingDetails.UPC = xmlElemNew(xmlDoc, "UPC");
	Item.ProductListingDetails.UPC.xmlText = "#sqlDefault.upc#";
}


if (sqlDefault.isbn neq ''){
	Item.ProductListingDetails = xmlElemNew(xmlDoc, "ProductListingDetails");
	Item.ProductListingDetails.ISBN = xmlElemNew(xmlDoc, "ISBN");
	Item.ProductListingDetails.ISBN.xmlText = "#sqlDefault.isbn#";
}

/* 
	20150731 added mpn which is required by ebay
*/
if (sqlDefault.mpnbrand neq '' ){
	if( not structkeyExists(Item,"ProductListingDetails") ){
		Item.ProductListingDetails = xmlElemNew(xmlDoc, "ProductListingDetails");
	}
	Item.ProductListingDetails.BrandMPN = xmlElemNew(xmlDoc, "BrandMPN");
	Item.ProductListingDetails.BrandMPN.Brand = xmlElemNew(xmlDoc, "Brand");
	Item.ProductListingDetails.BrandMPN.Brand.xmlText = "#trim(sqlDefault.mpnbrand)#";
	if(sqlDefault.mpnNum neq ''){
		Item.ProductListingDetails.BrandMPN.MPN = xmlElemNew(xmlDoc, "MPN");
		Item.ProductListingDetails.BrandMPN.MPN.xmlText = "#trim(sqlDefault.mpnNum)#";		
	}
}


Item.SiteID = xmlElemNew(xmlDoc, "SiteID");
Item.SiteID.xmlText = sqlAuction.SiteID;

// Auction
if(sqlAuction.ListingType EQ "0"){
	Item.StartPrice = xmlElemNew(xmlDoc, "StartPrice");
	Item.StartPrice.xmlText = sqlAuction.StartingPrice;

	//20101209 patrick want it to be 0 for now
	Item.ReservePrice = xmlElemNew(xmlDoc, "ReservePrice");
	//Item.ReservePrice.xmlText = sqlAuction.ReservePrice;
	Item.ReservePrice.xmlText = "0.0";


	Item.BuyItNowPrice = xmlElemNew(xmlDoc, "BuyItNowPrice");
	Item.BuyItNowPrice.xmlText = sqlAuction.BuyItNowPrice;
}else{
	Item.StartPrice = xmlElemNew(xmlDoc, "StartPrice");
	Item.StartPrice.xmlText = sqlAuction.BuyItNowPrice;

	Item.ListingType = xmlElemNew(xmlDoc, "ListingType");
	if(sqlAuction.ListingType EQ "2"){
		Item.ListingType.xmlText = "StoresFixedPrice";
	}else{
		Item.ListingType.xmlText = "FixedPriceItem";
	}
}

Item.Title = xmlElemNew(xmlDoc, "Title");
Item.Title.xmlText = sqlAuction.Title;

if(sqlAuction.SubTitle NEQ ""){
	Item.SubTitle = xmlElemNew(xmlDoc, "SubTitle");
	Item.SubTitle.xmlText = sqlAuction.SubTitle;
}

Item.Location = xmlElemNew(xmlDoc, "Location");
Item.Location.xmlText = sqlAuction.location;

/******** 20100730 Condition ID required *********/
//Item.ConditionID = xmlElemNew(xmlDoc, "ConditionID");
//Item.ConditionID.xmlText = "3000";
if(sqlAuction.ConditionID gt 1){
	Item.ConditionID = xmlElemNew(xmlDoc, "ConditionID");
	Item.ConditionID.xmlText = sqlAuction.ConditionID;

	//item condition is added only if not new
	if (sqlAuction.ConditionID neq "1000" or sqlAuction.ConditionID neq "1500"){
		Item.ConditionDescription = xmlElemNew(xmlDoc, "ConditionDescription");
		Item.ConditionDescription.xmlText = sqlDefault.specialNotes;
	}
}

/******** vlad 2011006 itemspecifics required *********/
if(get_ItemSpecifics.recordcount gte 1){
	Item.ItemSpecifics = xmlElemNew(xmlDoc, "ItemSpecifics");


	for (intRow = 1 ;intRow LTE get_ItemSpecifics.RecordCount ;intRow = (intRow + 1)){
		Item.ItemSpecifics.XmlChildren[intRow] = xmlElemNew(xmlDoc, "NameValueList");

		ArrayAppend(xmlDoc.xmlRoot.Item.ItemSpecifics.XmlChildren[intRow].xmlChildren, xmlElemNew(xmlDoc, "Name"));
		xmlDoc.xmlRoot.Item.ItemSpecifics.xmlChildren[intRow].Name.XMLText=trim(get_ItemSpecifics.iname[intRow]);

		ArrayAppend(xmlDoc.xmlRoot.Item.ItemSpecifics.XmlChildren[intRow].xmlChildren, xmlElemNew(xmlDoc, "Value"));
		xmlDoc.xmlRoot.Item.ItemSpecifics.XmlChildren[intRow].Value.XMLText=trim(get_ItemSpecifics.ivalue[intRow]);


		/* error
		xmlItemSpecificsName.Name = xmlElemNew(xmlDoc, "Name");
		xmlItemSpecificsName.Name.xmlText = get_ItemSpecifics.iname[intRow];
		ArrayAppend(xmlDoc.xmlRoot.Item.ItemSpecifics.XmlChildren[intRow].xmlChildren, xmlItemSpecificsName);

		xmlItemSpecificsValue.Value = xmlElemNew(xmlDoc, "Value");
		xmlItemSpecificsValue.Value.xmlText = get_ItemSpecifics.ivalue[intRow];
		ArrayAppend(xmlDoc.xmlRoot.Item.ItemSpecifics.XmlChildren[intRow].xmlChildren, xmlItemSpecificsValue);
		*/

	}

}


Item.PrivateListing = xmlElemNew(xmlDoc, "PrivateListing");
Item.PrivateListing.xmlText = IIF(sqlAuction.PrivateAuctions EQ "1", DE("true"), DE("false"));

PayPalEmailAddress = "";
for(i=1; i LTE ListLen(sqlAuction.PaymentMethods); i=i+1){
	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "PaymentMethods");
	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = ListGetAt(sqlAuction.PaymentMethods, i);
	if(ListGetAt(sqlAuction.PaymentMethods, i) EQ "PayPal"){
		PayPalEmailAddress = sqlEBAccount.paypal;
	}
}
if(PayPalEmailAddress NEQ ""){
	Item.PayPalEmailAddress = xmlElemNew(xmlDoc, "PayPalEmailAddress");
	Item.PayPalEmailAddress.xmlText = PayPalEmailAddress;
}

if(sqlAuction.Bold EQ 1){
	Item.ListingEnhancement = xmlElemNew(xmlDoc, "ListingEnhancement");
	Item.ListingEnhancement.xmlText = "BoldTitle";
}
if(sqlAuction.Border EQ 1){
	Item.ListingEnhancement = xmlElemNew(xmlDoc, "ListingEnhancement");
	Item.ListingEnhancement.xmlText = "Border";
}
if(sqlAuction.Highlight EQ 1){
	Item.ListingEnhancement = xmlElemNew(xmlDoc, "ListingEnhancement");
	Item.ListingEnhancement.xmlText = "Highlight";
}
if(sqlAuction.FeaturedPlus EQ 1){
	Item.ListingEnhancement = xmlElemNew(xmlDoc, "ListingEnhancement");
	Item.ListingEnhancement.xmlText = "Featured";
}
Item.BestOfferDetails = xmlElemNew(xmlDoc, "BestOfferDetails");
Item.BestOfferDetails.BestOfferEnabled = xmlElemNew(xmlDoc, "BestOfferEnabled");
if(sqlAuction.bestOffer EQ 1){
	Item.BestOfferDetails.BestOfferEnabled.xmlText = "true";
}else{
	Item.BestOfferDetails.BestOfferEnabled.xmlText = "false";
}
if(sqlAuction.StoreCategoryID GT 0){
	Item.Storefront = xmlElemNew(xmlDoc, "Storefront");
	Item.Storefront.StoreCategoryID = xmlElemNew(xmlDoc, "StoreCategoryID");
	Item.Storefront.StoreCategoryID.xmlText = sqlAuction.StoreCategoryID;
	if((sqlAuction.StoreCategory2ID NEQ "") AND (sqlAuction.StoreCategory2ID GT 0)){
		Item.Storefront.StoreCategory2ID = xmlElemNew(xmlDoc, "StoreCategory2ID");
		Item.Storefront.StoreCategory2ID.xmlText = sqlAuction.StoreCategory2ID;
	}
}
/***************** Pictures *****************/
if(sqlAuction.GalleryImage GT 0){
	imgURL = "#_layout.ia_images##sqlAuction.use_pictures#/#sqlAuction.GalleryImage#.jpg";
	/* OLD
	Item.VendorHostedPicture = xmlElemNew(xmlDoc, "VendorHostedPicture");
	Item.VendorHostedPicture.SelfHostedURL = xmlElemNew(xmlDoc, "SelfHostedURL");
	Item.VendorHostedPicture.SelfHostedURL.xmlText = imgURL;
	Item.VendorHostedPicture.PictureURL = xmlElemNew(xmlDoc, "PictureURL");
	Item.VendorHostedPicture.PictureURL.xmlText = imgURL;
	Item.VendorHostedPicture.PhotoDisplay = xmlElemNew(xmlDoc, "PhotoDisplay");
	Item.VendorHostedPicture.PhotoDisplay.xmlText = "None";
	Item.VendorHostedPicture.GalleryURL = xmlElemNew(xmlDoc, "GalleryURL");
	Item.VendorHostedPicture.GalleryURL.xmlText = imgURL;
	Item.VendorHostedPicture.GalleryType = xmlElemNew(xmlDoc, "GalleryType");
	if(sqlAuction.FeaturedPlus EQ "1"){
		Item.VendorHostedPicture.GalleryType.xmlText = "Featured";
	}else{
		Item.VendorHostedPicture.GalleryType.xmlText = "Gallery";
	}
	*/
	/* NEW */
	Item.PictureDetails = xmlElemNew(xmlDoc, "PictureDetails");
	Item.PictureDetails.GalleryType = xmlElemNew(xmlDoc, "GalleryType");
	if(sqlAuction.FeaturedPlus EQ "1"){
		Item.PictureDetails.GalleryType.xmlText = "Plus";
	}else{
		Item.PictureDetails.GalleryType.xmlText = "Gallery";
	}
	Item.PictureDetails.GalleryURL = xmlElemNew(xmlDoc, "GalleryURL");
	Item.PictureDetails.GalleryURL.xmlText = imgURL;
	
	/* :vladedit: */
	Item.PictureDetails.XmlChildren[1] = xmlElemNew(xmlDoc, "PictureURL");
	Item.PictureDetails.PictureURL.xmlText = imgURL;	
	/* add the other images */
	for (i=1;i LTE ListLast(sqlAuction.imagesLayout, '_');i=i+1) {
		
		if ( FileExists("#request.basepath##_layout.images_path##sqlAuction.use_pictures#/#i#.jpg") ){
				tempPictureURL = "#request.base#/images/#sqlAuction.use_pictures#/#i#.jpg"; 
				
				/* note
				:vladedit:20170412 - use the gallery image specified in sqlAuction.GalleryImage
				- i+1 is used coz we are forced to use the first element of array (Item.PictureDetails.XmlChildren[1]) to be the face of the listing
				- The Gallery image will be the first PictureURL in the array of PictureURL fields.
				*/
				Item.PictureDetails.XmlChildren[i+1] = xmlElemNew(xmlDoc, "PictureURL");
				Item.PictureDetails.XmlChildren[i+1].xmlText = tempPictureURL;
						
		}
	}


	
}
/*************** SHIPPING ********************/
if(sqlAuction.ShipToLocations EQ "WorldWide"){
	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "Americas"; // N. and S. America

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].ShipToLocation.xmlText = "Asia"; // Asia

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "AU"; // Australia

	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "CA"; // Canada

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "MX"; // Mexico

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "DE"; // Germany

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "Europe"; // Europe

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "GB"; // United Kingdom

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "JP"; // Japan

//	Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocations");
//	Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "Worldwide"; // Worldwide


//exclude this in ExcludeShipToLocation - For the exclusion list  to be applied to your listing you will also need to send the following tag in your listing request.
Item.xmlChildren[ArrayLen(Item.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToRegistrationCountry");
Item.xmlChildren[ArrayLen(Item.xmlChildren)].xmlText = "true"; // Canada


}else{
	Item.ShipToLocations = xmlElemNew(xmlDoc, "ShipToLocations");
	Item.ShipToLocations.xmlText = sqlAuction.ShipToLocations; // US, WorldWide
}

Item.ShippingDetails = xmlElemNew(xmlDoc, "ShippingDetails");



if(sqlAuction.ratetable EQ 1){
	Item.ShippingDetails.RateTableDetails = xmlElemNew(xmlDoc, "RateTableDetails");
	
	/* vladedit:20171012 - patrick wants rate tables*/
	/*Item.ShippingDetails.RateTableDetails.DomesticRateTable = xmlElemNew(xmlDoc, "DomesticRateTable");
	Item.ShippingDetails.RateTableDetails.DomesticRateTable.xmlText = "Default";*/
	/*- vladedit:20171012 experimental code*/
	Item.ShippingDetails.RateTableDetails.DomesticRateTableId = xmlElemNew(xmlDoc, "DomesticRateTableId");
	Item.ShippingDetails.RateTableDetails.DomesticRateTableId.xmlText = "5008138017";
	
}

if(sqlAuction.WhoPaysShipping EQ "3"){ // Buyer � Fixed Shipping Costs
	Item.ShippingDetails.ShippingType = xmlElemNew(xmlDoc, "ShippingType");
	Item.ShippingDetails.ShippingType.xmlText = "Flat";
}else if(sqlAuction.LocalPickUp EQ "0"){
	Item.ShippingDetails.ShippingType = xmlElemNew(xmlDoc, "ShippingType");
	Item.ShippingDetails.ShippingType.xmlText = "Calculated";

	Item.ShippingDetails.CalculatedShippingRate = xmlElemNew(xmlDoc, "CalculatedShippingRate");

	Item.ShippingDetails.CalculatedShippingRate.OriginatingPostalCode = xmlElemNew(xmlDoc, "OriginatingPostalCode");
	Item.ShippingDetails.CalculatedShippingRate.OriginatingPostalCode.xmlText = "40503";

	Item.ShippingDetails.CalculatedShippingRate.PackagingHandlingCosts = xmlElemNew(xmlDoc, "PackagingHandlingCosts");
	Item.ShippingDetails.CalculatedShippingRate.PackagingHandlingCosts.xmlText = "#(getVar('Shipping.PackagingHandlingCosts', '3.6', 'NUMBER') + (sqlAuction.PackedWeight + sqlAuction.PackedWeight_oz/16)* getVar('Shipping.PackagingHandlingPerPound', '0.3', 'NUMBER'))#";
	Item.ShippingDetails.CalculatedShippingRate.PackagingHandlingCosts.xmlAttributes.currencyID = "USD";

	Item.ShippingDetails.CalculatedShippingRate.ShippingPackage = xmlElemNew(xmlDoc, "ShippingPackage");
	Item.ShippingDetails.CalculatedShippingRate.ShippingPackage.xmlText = ListGetAt("PackageThickEnvelope,USPSLargePack,VeryLargePack,ExtraLargePack,USPSFlatRateEnvelope", sqlAuction.PackageSize + 1);


	/* :vladedit: 20160112
	FIX for "the-package-weight-is-not-valid-or-missing"	
	*/
	if(sqlAuction.PackedWeight eq 0){
		//sqlAuction.PackedWeight = 1; //ebay doesn't like the value of zero for weight. we will use 1 lbs instead.
		//commented out 20160922
	}
	Item.ShippingDetails.CalculatedShippingRate.WeightMajor = xmlElemNew(xmlDoc, "WeightMajor");
	Item.ShippingDetails.CalculatedShippingRate.WeightMajor.xmlText = sqlAuction.PackedWeight;
	Item.ShippingDetails.CalculatedShippingRate.WeightMajor.xmlAttributes.unit = "lbs";

	Item.ShippingDetails.CalculatedShippingRate.WeightMinor = xmlElemNew(xmlDoc, "WeightMinor");
	Item.ShippingDetails.CalculatedShippingRate.WeightMinor.xmlText = sqlAuction.PackedWeight_oz;
	Item.ShippingDetails.CalculatedShippingRate.WeightMinor.xmlAttributes.unit = "oz";
	
/* TODO
	Item.ShippingDetails.CalculatedShippingRate.PackageWidth = xmlElemNew(xmlDoc, "PackageWidth");
	Item.ShippingDetails.CalculatedShippingRate.PackageWidth.xmlText = sqlItem.width;
	Item.ShippingDetails.CalculatedShippingRate.PackageWidth.xmlAttributes.unit = "in";

	Item.ShippingDetails.CalculatedShippingRate.PackageLength = xmlElemNew(xmlDoc, "PackageLength");
	Item.ShippingDetails.CalculatedShippingRate.PackageLength.xmlText = sqlItem.height;
	Item.ShippingDetails.CalculatedShippingRate.PackageLength.xmlAttributes.unit = "in";

	Item.ShippingDetails.CalculatedShippingRate.PackageDepth = xmlElemNew(xmlDoc, "PackageDepth");
	Item.ShippingDetails.CalculatedShippingRate.PackageDepth.xmlText = sqlItem.depth;
	Item.ShippingDetails.CalculatedShippingRate.PackageDepth.xmlAttributes.unit = "in";
*/

/* try catch so that items that have missing data will still push through*/

			Item.ShippingPackageDetails = xmlElemNew(xmlDoc, "ShippingPackageDetails");
	    	Item.ShippingPackageDetails.PackageWidth = xmlElemNew(xmlDoc, "PackageWidth");
			Item.ShippingPackageDetails.PackageWidth.xmlText = numberformat(sqlDefault.width);
			Item.ShippingPackageDetails.PackageWidth.xmlAttributes.unit = "in";
		
			Item.ShippingPackageDetails.PackageLength = xmlElemNew(xmlDoc, "PackageLength");
			Item.ShippingPackageDetails.PackageLength.xmlText = numberformat(sqlDefault.height);
			Item.ShippingPackageDetails.PackageLength.xmlAttributes.unit = "in";
		
			Item.ShippingPackageDetails.PackageDepth = xmlElemNew(xmlDoc, "PackageDepth");
			Item.ShippingPackageDetails.PackageDepth.xmlText = numberformat(sqlDefault.depth);
			Item.ShippingPackageDetails.PackageDepth.xmlAttributes.unit = "in";





}

Item.ShippingDetails.ChangePaymentInstructions = xmlElemNew(xmlDoc, "ChangePaymentInstructions");
Item.ShippingDetails.ChangePaymentInstructions.xmlText = "true";

/* 20120107 remove shipping insurance coz of listing error
Item.ShippingDetails.InsuranceOption = xmlElemNew(xmlDoc, "InsuranceOption");
Item.ShippingDetails.InsuranceOption.xmlText = "Optional";
*/

if(sqlAuction.ShipToLocations EQ "WorldWide"){
	// USPSAirmailParcel
/*
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)+1] = xmlElemNew(xmlDoc, "InternationalShippingServiceOption");

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService = xmlElemNew(xmlDoc, "ShippingService");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService.xmlText = "USPSAirmailParcel";

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority.xmlText = "2";

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShipToLocation = xmlElemNew(xmlDoc, "ShipToLocation");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShipToLocation.xmlText = "Worldwide";
*/

	// USPSGlobalExpress
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)+1] = xmlElemNew(xmlDoc, "InternationalShippingServiceOption");

	InternationalShippingServiceOption = Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)];

	InternationalShippingServiceOption.ShippingService = xmlElemNew(xmlDoc, "ShippingService");
	if((sqlAuction.WhoPaysShipping EQ "3") AND (1132 GT 0)){ // (Buyer � Fixed Shipping Costs) AND (Cost specified)
		InternationalShippingServiceOption.ShippingService.xmlText = getVar('Shipping.FlatInternationalService', "StandardInternational", "STRING");

		InternationalShippingServiceOption.ShippingServiceCost = xmlElemNew(xmlDoc, "ShippingServiceCost");
		InternationalShippingServiceOption.ShippingServiceCost.xmlText = 13;//sqlAuction.TODO_NEW_FIELD;
	}else{
		InternationalShippingServiceOption.ShippingService.xmlText = getVar('Shipping.DefaultInternationalService', "USPSPriorityMailInternational", "STRING"); // old USPSExpressMailInternational, older USPSGlobalExpress
	}

	InternationalShippingServiceOption.ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
	InternationalShippingServiceOption.ShippingServicePriority.xmlText = "1";

	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "Americas"; // N. and S. America

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].ShipToLocation.xmlText = "Asia"; // Asia

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "AU"; // Australia

	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "CA"; // Canada

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "MX"; // Mexico

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "DE"; // Germany

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "Europe"; // Europe

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "GB"; // United Kingdom

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "JP"; // Japan

//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShipToLocation");
//	InternationalShippingServiceOption.xmlChildren[ArrayLen(InternationalShippingServiceOption.xmlChildren)].xmlText = "Worldwide"; // Worldwide
}

Item.ShippingDetails.PaymentInstructions = xmlElemNew(xmlDoc, "PaymentInstructions");
Item.ShippingDetails.PaymentInstructions.xmlText = "Please see auction description for details.";

if(sqlAuction.ShipToLocations NEQ "None"){
	Item.ShippingDetails.SalesTax = xmlElemNew(xmlDoc, "SalesTax");
	Item.ShippingDetails.SalesTax.xmlAttributes.currencyID = "USD";

	Item.ShippingDetails.SalesTax.SalesTaxPercent = xmlElemNew(xmlDoc, "SalesTaxPercent");
	Item.ShippingDetails.SalesTax.SalesTaxPercent.xmlText = "6.000";

	Item.ShippingDetails.SalesTax.SalesTaxState = xmlElemNew(xmlDoc, "SalesTaxState");
	Item.ShippingDetails.SalesTax.SalesTaxState.xmlText = "KY";
}

if(sqlAuction.WhoPaysShipping EQ "3"){ // Buyer � Fixed Shipping Costs
	// ShippingMethodStandard
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShippingServiceOptions");

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService = xmlElemNew(xmlDoc, "ShippingService");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService.xmlText = "ShippingMethodStandard";

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority.xmlText = "1";

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServiceCost = xmlElemNew(xmlDoc, "ShippingServiceCost");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServiceCost.xmlText = sqlAuction.ShippingServiceCost;
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServiceCost.xmlAttributes.currencyID = "USD";

	/* 20120107 remove shipping insurance coz of listing error
	Item.ShippingDetails.InsuranceOption.xmlText = "NotOffered";
	Item.ShippingDetails.InsuranceFee = xmlElemNew(xmlDoc, "InsuranceFee");
	Item.ShippingDetails.InsuranceFee.xmlText = "0.0";
	Item.ShippingDetails.InsuranceFee.xmlAttributes.currencyID = "USD";
	*/
}else if(sqlAuction.LocalPickUp NEQ "0"){
	Item.ShippingDetails.ShippingServiceOptions = xmlElemNew(xmlDoc, "ShippingServiceOptions");

	Item.ShippingDetails.ShippingServiceOptions.ShippingService = xmlElemNew(xmlDoc, "ShippingService");
	Item.ShippingDetails.ShippingServiceOptions.ShippingService.xmlText = "LocalDelivery";
	Item.ShippingDetails.ShippingServiceOptions.ShippingServiceCost = xmlElemNew(xmlDoc, "ShippingServiceCost");
	Item.ShippingDetails.ShippingServiceOptions.ShippingServiceCost.xmlText = sqlAuction.ShippingServiceCost;
	Item.ShippingDetails.ShippingServiceOptions.ShippingServiceCost.xmlAttributes.currencyID = "USD";

/* 20120107 remove shipping insurance coz of listing error
	Item.ShippingDetails.InsuranceOption.xmlText = "NotOffered";
	Item.ShippingDetails.InsuranceFee = xmlElemNew(xmlDoc, "InsuranceFee");
	Item.ShippingDetails.InsuranceFee.xmlText = "0.0";
	Item.ShippingDetails.InsuranceFee.xmlAttributes.currencyID = "USD";
*/

}else{
	if((sqlAuction.PackedWeight + sqlAuction.PackedWeight_oz/16) GT 3){
		// UPSGround
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShippingServiceOptions");

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService = xmlElemNew(xmlDoc, "ShippingService");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService.xmlText = "UPSGround";

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority.xmlText = "1";
	}else if(sqlAuction.PackedWeight eq 0 ){
		//USPSFirstClass
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShippingServiceOptions");

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService = xmlElemNew(xmlDoc, "ShippingService");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService.xmlText = "USPSFirstClass";

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority.xmlText = "1";
	}else if(sqlAuction.PackedWeight eq 0 and sqlAuction.PackedWeight_oz lte 16){
		/* 20160922 fix for  people get pissed when we say USPSPriority and ship USPSFirstClass. this affects old templates*/
		//USPSFirstClass
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShippingServiceOptions");

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService = xmlElemNew(xmlDoc, "ShippingService");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService.xmlText = "USPSFirstClass";

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority.xmlText = "1";		
	}else{
		// USPSPriority
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)+1] = xmlElemNew(xmlDoc, "ShippingServiceOptions");

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService = xmlElemNew(xmlDoc, "ShippingService");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService.xmlText = "USPSPriority";

		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
		Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority.xmlText = "1";
	}
	// LocalDelivery
	/*
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService = xmlElemNew(xmlDoc, "ShippingService");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingService.xmlText = "LocalDelivery";

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority = xmlElemNew(xmlDoc, "ShippingServicePriority");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServicePriority.xmlText = "2";

	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServiceCost = xmlElemNew(xmlDoc, "ShippingServiceCost");
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServiceCost.xmlText = 2;
	Item.ShippingDetails.xmlChildren[ArrayLen(Item.ShippingDetails.xmlChildren)].ShippingServiceCost.xmlAttributes.currencyID = "USD";
	*/
}

if(sqlAuction.WhoPaysShipping EQ 1){
	Item.ShippingTerms = xmlElemNew(xmlDoc, "ShippingTerms");
	Item.ShippingTerms.xmlText = "SellerPays";
}else if(ListFind("2,3", sqlAuction.WhoPaysShipping)){
	Item.ShippingTerms = xmlElemNew(xmlDoc, "ShippingTerms");
	Item.ShippingTerms.xmlText = "BuyerPays";
}
// SKU
Item.SKU = xmlElemNew(xmlDoc, "SKU");
Item.SKU.xmlText = sqlAuction.itemid;

// HIT COUNTER
Item.HitCounter = xmlElemNew(xmlDoc, "HitCounter");
Item.HitCounter.xmlText = "BasicStyle";

// ITEM SPECIFIC
iASA = Find("<AttributeSetArray>", sqlAuction.AttributeSetArray);
if(iASA GT 0){
	Item.AttributeSetArray = xmlElemNew(xmlDoc, "AttributeSetArray");
	sDoc = toString(xmlDoc);
	sDoc = Replace(sDoc, "<AttributeSetArray/>", Mid(sqlAuction.AttributeSetArray, iASA, Len(sqlAuction.AttributeSetArray)-iASA+1));
	xmlDoc = XMLParse(sDoc);
	// 1137 - Cars & Trucks
	if(isDefined("xmlDoc.xmlRoot.Item.AttributeSetArray")){
		for(i=1; i LTE ArrayLen(xmlDoc.xmlRoot.Item.AttributeSetArray.xmlChildren); i=i+1){
			if(ListFindNoCase("1137,1146", xmlDoc.xmlRoot.Item.AttributeSetArray.xmlChildren[i].xmlAttributes.attributeSetID)){
				// 1137:10246 "Sub Title"
				// 1146:10246 "Sub Title"
				xmlSubTitle = xmlElemNew(xmlDoc, "Attribute");
				xmlSubTitle.xmlAttributes["attributeID"] = "10246";
				xmlSubTitle.Value = xmlElemNew(xmlDoc, "Value");
				xmlSubTitle.Value.ValueLiteral = xmlElemNew(xmlDoc, "ValueLiteral");
				xmlSubTitle.Value.ValueLiteral.xmlText = sqlAuction.Title;
				ArrayAppend(xmlDoc.xmlRoot.Item.AttributeSetArray.xmlChildren[i].xmlChildren, xmlSubTitle);
				StructDelete(xmlDoc.xmlRoot.Item, "SubTitle", FALSE);
				break;
			}
		}
	}
}
</cfscript>

<!---
<cfoutput>get_ItemSpecifics.RecordCount:#get_ItemSpecifics.RecordCount#</cfoutput>
<cfdump var="#xmlDoc#">
<cfabort>
--->

<cfif isDefined("attributes.showXML")>
	<cfdump var="#xmlDoc#">
	<cfdump var="#sqlAuction#">
	<cfabort>
</cfif>
