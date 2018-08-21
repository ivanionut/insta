<cfif isDefined("attribtues.ResidentialAddress")>
	<cfset txtResidentialAddress = "<ResidentialAddress></ResidentialAddress>">
<cfelse>
	<cfset txtResidentialAddress = "">
</cfif>

<cfparam name="attributes.OversizePackage" default="0">

<cfset XMLRequest = '
<?xml version="1.0"?>
<AccessRequest xml:lang="en-US">
	<AccessLicenseNumber>#_vars.ups.AccessLicenseNumber#</AccessLicenseNumber>
	<UserId>#_vars.ups.UserId#</UserId>
	<Password>#_vars.ups.Password#</Password>
</AccessRequest>
<?xml version="1.0"?>
<ShipmentConfirmRequest xml:lang="en-US">
	<Request>
		<RequestAction>ShipConfirm</RequestAction>
		<RequestOption>nonvalidate</RequestOption>
		<TransactionReference>
			<CustomerContext>#session.combined#</CustomerContext>
			<XpciVersion>1.0001</XpciVersion>
		</TransactionReference>
	</Request>
	<LabelSpecification>
		<LabelPrintMethod>
			<Code>GIF</Code>
		</LabelPrintMethod>
		<HTTPUserAgent>Mozilla/4.5</HTTPUserAgent>
		<LabelImageFormat>
			<Code>GIF</Code>
		</LabelImageFormat>
	</LabelSpecification>
	<Shipment>
		<RateInformation> 
			<NegotiatedRatesIndicator /> 
		</RateInformation>		
		<Shipper>
			<Name>#_vars.upsFrom.Company#</Name>
			<AttentionName>#_vars.upsFrom.Attention#</AttentionName>
			<PhoneNumber>#REReplace(_vars.upsFrom.Telephone, "[^0-9]*", "", "ALL")#</PhoneNumber>
			<ShipperNumber>#attributes.ShipperNumber#</ShipperNumber>
			<Address>
				<AddressLine1>#_vars.upsFrom.Address1#</AddressLine1>
				<AddressLine2>#_vars.upsFrom.Address2#</AddressLine2>
				<AddressLine3>#_vars.upsFrom.Address3#</AddressLine3>
				<City>#_vars.upsFrom.City#</City>
				<StateProvinceCode>#_vars.upsFrom.State#</StateProvinceCode>
				<PostalCode>#_vars.upsFrom.ZIPCode#</PostalCode>
				<CountryCode>#_vars.upsFrom.Country#</CountryCode>
			</Address>
		</Shipper>
		<ShipTo>
			<CompanyName><![CDATA[ #attributes.TO_Company# ]]></CompanyName>
			<AttentionName>#attributes.TO_Attention#</AttentionName>
			<PhoneNumber>#REReplace(attributes.TO_Telephone, "[^0-9]*", "", "ALL")#</PhoneNumber>
			<Address>
				<AddressLine1>#attributes.TO_Address1#</AddressLine1>
				<AddressLine2>#attributes.TO_Address2#</AddressLine2>
				<AddressLine3>#attributes.TO_Address3#</AddressLine3>
				<City>#attributes.TO_City#</City>
				<StateProvinceCode>#attributes.TO_State#</StateProvinceCode>
				<PostalCode>#attributes.TO_ZIPCode#</PostalCode>
				<CountryCode>#attributes.TO_Country#</CountryCode>
				#txtResidentialAddress#
			</Address>
		</ShipTo>
		<PaymentInformation>
			<Prepaid>
				<BillShipper>
					<AccountNumber>#attributes.ShipperNumber#</AccountNumber>
				</BillShipper>
			</Prepaid>
		</PaymentInformation>
		<Service>
			<Code>#attributes.UPSService#</Code>
		</Service>
		<Package>
			<ReferenceNumber>
				<Code>PC</Code>
				<Value>#Left(session.combined, 35)#</Value>
			</ReferenceNumber>
			<PackagingType>
				<Code>#attributes.PackageType#</Code>
			</PackagingType>
			<PackageWeight>
				<UnitOfMeasurement>
					<Code>LBS</Code>
				</UnitOfMeasurement>
				<Weight>#attributes.Weight#</Weight>
			</PackageWeight>
			
			<Dimensions>
		       <UnitOfMeasurement>IN</UnitOfMeasurement>
		       <Length>#attributes.depth#</Length>
		       <Width>#attributes.width#</Width>
		       <Height>#attributes.height#</Height>
		    </Dimensions>		
'>
<!---
:vladedit: 20160930 old code and patrick request to remove--->
<cfif attributes.OversizePackage NEQ 0>
	<cfset XMLRequest = XMLRequest & '
			<OversizePackage>#attributes.OversizePackage#</OversizePackage>
'>
</cfif>


<cftry><cfset attributes.DeclaredValue = Val(attributes.DeclaredValue)><cfcatch type="any"><cfset attributes.DeclaredValue = 0></cfcatch></cftry>
<cfif attributes.DeclaredValue GT 0>
	<cfset XMLRequest = XMLRequest & '
			<PackageServiceOptions>
				<InsuredValue>
					<CurrencyCode>USD</CurrencyCode>
					<MonetaryValue>#attributes.DeclaredValue#</MonetaryValue>
				</InsuredValue>
			</PackageServiceOptions>
'>
</cfif>
<cfset XMLRequest = XMLRequest & '
		</Package>
	</Shipment>
</ShipmentConfirmRequest>
'>
<cfset upsShipUrl = "https://temp-onlinetools.ups.com/ups.app/xml/ShipConfirm">
<!---https://www.ups.com/ups.app/xml/ShipConfirm --->
<cfhttp url="#upsShipUrl#" method="POST" charset="utf-8" port="443">
	<cfhttpparam name="request" value="#XMLRequest#" type="XML"> 
</cfhttp>

<cfset goodXML = TRUE>
<cftry>
	<cfset theXML = XMLParse(ToString(cfhttp.Filecontent))>
	<cfcatch type="any">
		<cfset goodXML = FALSE>
	</cfcatch>
</cftry>

<cfif goodXML>
	<cfif theXML.xmlRoot.Response.ResponseStatusDescription.xmlText EQ "failure">
		<cfoutput><h1 style="color:red;">Failure: #theXML.xmlRoot.Response.Error.ErrorDescription.xmlText#</h1></cfoutput>
	<cfelse>
		<cfset drawForm = "accept">
	</cfif>
<cfelse>
	<cfoutput>
	<h3 style="color:red;">Could not parse as XML the following response from https://www.ups.com/ups.app/xml/ShipConfirm</h3>
	<hr>#ToString(cfhttp.Filecontent)#<hr>
	</cfoutput>
</cfif>
