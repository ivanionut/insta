<cfsavecontent variable="auctionContent">

<style type="text/css">
h1{
	background-color:##CCCCCC;
	text-align:center;
}
</style>

	<cfoutput query="sqlAuction" maxrows="1">
	<table bgcolor="white" border="0" align="center" cellpadding="0" cellspacing="0" width="100%" style='table-layout:fixed'>
	<tr><td align="left" valign="top">
		#sqlEBAccount.TemplateHeader#
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td width="100%" style="background-image:url(#_layout.ia_design#bar.gif)" valign="middle" height="22" align="center">
			
			<a href="##description">
				<img alt="Description" src="#_layout.ia_design#bar-description.jpg" border="0">
			</a>
			
			<a href="##payment">
				<img alt="Payment" src="#_layout.ia_design#bar-payment.jpg" border="0">
			</a>
			
			<a href="##shipping">
				<img alt="Shipping" src="#_layout.ia_design#bar-shipping.jpg" border="0">
			</a>
					<!---<a href="##franchising"><img alt="Franchising" src="#_layout.ia_design#bar-franchising.jpg" border="0"></a>--->
					<a href="##aboutus"><img alt="About Us" src="#_layout.ia_design#bar-aboutus.jpg" border="0"></a></td></tr>
		</table>
		<br>
		<center><font size=4 face=arial><strong>#sqlAuction.Title#</strong></font><br><br></center>
		</cfoutput>
		<cfset variables.jsPreload = "">
		<cfset attributes.imagesLayout = sqlAuction.imagesLayout>
		
		<!--- uses \site\admin\auctions\layout\images\left_8.cfm --->	
		<cfinclude template="../images/#attributes.imagesLayout#.cfm">
		
		<!---
		:vladedit: 20170601 - ebay disables active content
		<cfif variables.jsPreload NEQ "">
			<cfoutput>
			<script language="javascript">
			<!--//
			#variables.jsPreload#
			//-->
			</script>
			</cfoutput>
		</cfif>--->
		
		<cfoutput query="sqlAuction" maxrows="1">
		<table align="left">
		<tr><td id="description">
			<hr width=90%>
			<a name="description" ></a><img src="#_layout.ia_design#description.jpg" alt="Description"><br><br>
			#sqlEBAccount.TemplateDescription#
		</td></tr>
		<tr><td id="shipping">
			<hr width=90%>
			<a name="shipping" ></a>
				<!---<img src="#_layout.ia_design#sell-with-us.jpg" alt="Sell With US" border="0">--->
				<img src="#_layout.ia_design#aboutus.jpg" alt="About Us">
			<br><br>
			#sqlEBAccount.TemplateSellWithUs#
		</td></tr>
		<tr>
			<td id="payment">
				<hr width=90%>
				<a name="payment"></a><img src="#_layout.ia_design#payment.jpg" alt="Payment"><br><br>
				#sqlEBAccount.TemplatePayment#
			</td>
		</tr>
		<tr><td id="shipping">
			<hr width=90%>
			<a name="shipping"></a><img src="#_layout.ia_design#shipping.jpg" alt="Shipping"><br><br>
			#sqlEBAccount.TemplateShipping#
			
			#sqlEBAccount.TemplateAboutUs#
		</td></tr>
		<!---<tr><td>
			<hr width=90%>
			<a name="aboutus"></a><img src="#_layout.ia_design#aboutus.jpg" alt="About Us"><br><br>
			#sqlEBAccount.TemplateAboutUs#
		</td></tr>--->
		</table>
	</td></tr>
	</table>
	</cfoutput>
</cfsavecontent>

<cfif Trim(sqlAuction.videoURL) EQ "">
	<cfset video = ''>
<cfelse>
	<cfset video = '<object width="425" height="350"><param name="movie" value="#sqlAuction.videoURL#"> </param> <embed src="#sqlAuction.videoURL#" type="application/x-shockwave-flash" width="425" height="350"></embed></object>'>
</cfif>
<cfscript>
	auctionContent = Replace(auctionContent, "{ITEM_DESCRIPTION}", Replace(sqlAuction.Description, CHR(13), "<BR>", "ALL"), "ALL");
	auctionContent = Replace(auctionContent, "{ITEM_PAYMENT_METHODS}", sqlAuction.PaymentMethods, "ALL");
	auctionContent = Replace(auctionContent, "{ITEM_ITEMID}", sqlAuction.itemid, "ALL");
	auctionContent = Replace(auctionContent, "{ITEM_WHO_SCHEDULED}", sqlAuction.scheduledBy, "ALL");
	auctionContent = Replace(auctionContent, "{ITEM_VIDEO}", video, "ALL");
</cfscript>
<cfoutput>#auctionContent#</cfoutput>
