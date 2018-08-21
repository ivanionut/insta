<cfif NOT isAllowed("Lister_SoldListings")>
	<cflocation url="index.cfm?dsp=slim_login&next_dsp=#attributes.dsp#" addtoken="no">
</cfif>
<cfparam name="attributes.orderby" default="7">
<cfparam name="attributes.dir" default="DESC">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.store" default="all">
<cfparam name="attributes.srch" default="Enter Search Term">
<cfparam name="attributes.srchfield" default="internal_itemSKU">
<cfparam name="attributes.showSearchAgain" default="0">
<cfquery name="sqlStores" datasource="#request.dsn#">
	SELECT DISTINCT store FROM accounts
</cfquery>




<!--- DUPLICATE AUCTIONS --->
<cfset request.opts = StructNew()>
<cffunction name="optGroup">
	<cfargument name="aid">
	<cfif NOT StructKeyExists(request.opts, "aid_#arguments.aid#")>
		<cfquery name="sqlAccount" datasource="#request.dsn#">
			SELECT first + ' ' + last AS owner
			FROM accounts
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.aid#">
		</cfquery>
		<cfquery name="sqlGroup" datasource="#request.dsn#">
			SELECT i.item
			FROM items i
				LEFT JOIN auctions a ON i.item = a.itemid
			WHERE i.status = 3<!--- Item Received --->
				AND i.aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.aid#">
				AND a.ready IS NULL
				AND i.internal_itemCondition != 'amazon'
			ORDER BY i.item
		</cfquery>

		<cfsavecontent variable="tmp">
			<cfoutput>
			<optgroup label="#sqlAccount.owner#">
				<cfloop query="sqlGroup">
					<option value="#item#">#item#</option>
				</cfloop>
			</optgroup></cfoutput>
		</cfsavecontent>
		<cfset request.opts["aid_#arguments.aid#"] = tmp>
	</cfif>
	<cfreturn request.opts["aid_#arguments.aid#"]>
</cffunction>

<cffunction name="sameSKU">
	<cfargument name="theSku" default="0" required="true" >

	<cfset var d_options = "">
	<cfquery name="getSameSKU" datasource="#request.dsn#">

		SELECT i.item, i.title,
		CASE WHEN i.dreceived=0 THEN i.dcreated ELSE i.dreceived END AS drec,
		CASE WHEN i.dreceived=0 THEN '0' ELSE '1' END AS isrec,
		a.id, u.ready, u.sandbox, i.lid,
		i.dpictured, i.internal_itemCondition,i.internal_itemSKU
	FROM accounts a
		INNER JOIN items i ON a.id = i.aid
		LEFT JOIN auctions u ON i.item = u.itemid
	WHERE i.status = '3'<!--- Item Received --->
		AND i.lid != 'RTC'
		AND i.lid != 'DTC'
		AND i.lid != 'RELOT'
		AND i.lid != 'P&S'
		AND i.internal_itemCondition != 'amazon'
		and  i.internal_itemCondition != 'craiglist'
		and  i.internal_itemCondition != 'bonanza'
		and (
			u.ready = '' 
			or u.ready is null	
			or u.ready = 0	<!--- 20160412 added. for upload pictures trigger--->		
		)
		
		<!---
		20160412 removed coz when an auction is auto created same sku doesn't show some items
		AND (
			i.dpictured IS NULL 
			or i.dpictured = ''	
							
		)--->
		
		AND CASE WHEN i.dreceived=0 THEN i.dcreated ELSE i.dreceived END > DATEADD(DAY, -#_vars.auctions.awaiting_auction_daysbackward_check#, GETDATE())
		and i.internal_itemSKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theSku#">
		<cfif session.user.store EQ "202">
			AND a.store = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user.store#">
		</cfif>


	</cfquery>


		
		<cfsavecontent variable="d_options">
			<cfoutput>
				<optgroup label="Same SKU">
					<cfloop query="getSameSKU">
						<option value="#item#">#item#</option>
					</cfloop>
				</optgroup>
			</cfoutput>
		</cfsavecontent>
	<cfset request.opts3["sameSKU_#arguments.theSku#"] = d_options>
	
	<cfreturn request.opts3["sameSKU_#arguments.theSku#"]>
</cffunction>

<cffunction name="optGroup_2">
		<cfquery name="sqlTemp_optGroup_2" datasource="#request.dsn#">
			SELECT i.item, i.title,
				CASE WHEN i.dreceived=0 THEN i.dcreated ELSE i.dreceived END AS drec,
				CASE WHEN i.dreceived=0 THEN '0' ELSE '1' END AS isrec,
				a.id, u.ready, u.sandbox, i.lid,i.internal_itemCondition,
				i.dpictured
			FROM accounts a
				INNER JOIN items i ON a.id = i.aid
				LEFT JOIN auctions u ON i.item = u.itemid
			WHERE i.status = '3'<!--- Item Received --->
				AND i.lid != 'RTC'
				AND i.lid != 'DTC'
				AND i.lid != 'RELOT'
				AND i.lid != 'P&S'
				and (u.ready = '' or u.ready is null)
		AND i.internal_itemCondition != 'amazon'
		and (u.ready = '' or u.ready is null)
		AND (i.dpictured IS NULL or i.dpictured = '')
				AND (i.dpictured IS NULL or i.dpictured = '')
				AND CASE WHEN i.dreceived=0 THEN i.dcreated ELSE i.dreceived END > DATEADD(DAY, -30, GETDATE())
				<cfif session.user.store EQ "202">
					AND a.store = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user.store#">
				</cfif>
			ORDER BY i.item asc
		</cfquery>

		<cfsavecontent variable="tmp1">
			<cfoutput>
			<optgroup label="#session.user.store#_items.awaiting_auction">
				<cfloop query="sqlTemp_optGroup_2">
					<option value="#item#">#item#</option>
				</cfloop>
			</optgroup></cfoutput>
		</cfsavecontent>
		<cfset request.opts2["aid_#session.user.store#"] = tmp1>
	<cfreturn request.opts2["aid_#session.user.store#"]>
</cffunction>

<!--- / DUPLICATE AUCTIONS --->

<cfoutput>
<script language="javascript" type="text/javascript">
<!--//
function fPage(Page){
	window.location.href = "#_machine.self#&store=#attributes.store#&orderby=#attributes.orderby#&dir=#attributes.dir#&page="+Page<cfif attributes.srch NEQ "">+"&srch=#URLEncodedFormat(attributes.srch)#&srchfield=#attributes.srchfield#"</cfif>;
}
function fSort(OrderBy){
	if (#attributes.orderby# == OrderBy){
		dir = <cfif attributes.dir EQ "ASC">"DESC"<cfelse>"ASC"</cfif>;
	}else{
		dir = "ASC";
	}
	window.location.href = "#_machine.self#&store=#attributes.store#&page=#attributes.page#&orderby="+OrderBy+"&dir="+dir<cfif attributes.srch NEQ "">+"&srch=#URLEncodedFormat(attributes.srch)#&srchfield=#attributes.srchfield#"</cfif>;
}
function fStore(store){
	window.location.href = "#_machine.self#&orderby=#attributes.orderby#&dir=#attributes.dir#&page=1&store="+store;
}
//-->
</script>
<table width="100%" style="text-align: justify;">
<tr><td>
	<font size="4"><strong>Ended Listings:</strong> (Sold)</font><br>
	<hr size="1" style="color: Black;" noshade>
	<strong>Administrator:</strong> #session.user.first# #session.user.last#<br><br>
	<table width="100%">
	<tr>
		<td width="50%" align="left">
			Store:<br>
			<select name="store" onChange="fStore(this.value)">
				<option value="all"<cfif attributes.store EQ ""> selected</cfif>>All</option>
				<cfloop query="sqlStores">
				<option value="#sqlStores.store#"<cfif attributes.store EQ sqlStores.store> selected</cfif>>#sqlStores.store#</option>
				</cfloop>
			</select>
		</td>
		<td width="50%" align="left">
			Enter Search Term:<br>
			<form method="POST" action="#_machine.self#" name="searchForm">
				<input type="text" size="20" maxlength="50" name="srch" value="#HTMLEditFormat(attributes.srch)#">
				<select name="srchfield" style="font-size: 13px;">
					#SelectOptions(attributes.srchfield, "all,All Fields;item,Item Number;title,Item Title;ebayitem,eBay Number;ebaytitle,eBay Title;aid,Account ID;internal_itemSKU,SKU;")#
				</select>
				<select name="dir"  style="font-size: 13px;">
					#SelectOptions(attributes.dir, "Asc,Ascending;Desc,Descending;")#
				</select>
				<input type="submit" value="Search">
			</form>
		</td>
	</tr>
	</table>
	<br>
	<table bgcolor="##aaaaaa" border=0 cellspacing="0" cellpadding=0 width="100%">
	<tr><td>
		<table width="100%" cellspacing="1" cellpadding="4">
		<tr bgcolor="##F0F1F3">
			<td class="ColHead">Gallery</td>
			<td class="ColHead"><a href="JavaScript: void fSort(3);">Owner</a></td>
			<td class="ColHead"><a href="JavaScript: void fSort(1);">Item Number</a></td>
			<td class="ColHead"><a href="JavaScript: void fSort(5);">Final Price</a></td>
			<td class="ColHead">Status</td>
			<td class="ColHead" colspan="2">Duplicate Auction</td>
			<td class="ColHead"><a href="JavaScript: void fSort(8);">Condition</a></td>
		</tr>
		</cfoutput>
		<cfquery name="sqlTemp" datasource="#request.dsn#">
			SELECT i.item, i.ebayitem, i.title, e.dtend AS dended, i.paid, i.shipped, e.galleryurl,i.INTERNAL_ITEMCONDITION,
				e.price AS finalprice, i.status, i.lid, i.startprice, e.hbuserid, a.ready, a.use_pictures,i.internal_itemSKU
				,a.listingtype, i.itemis_template, i.itemis_template_setdate, i.shipnote, i.specialNotes
			FROM items i
				
				INNER JOIN ebitems e ON i.ebayitem = e.ebayitem				
				LEFT JOIN auctions a ON i.item = a.itemid<!--- for DUPLICATE AUCTIONS --->
				INNER JOIN accounts acct ON i.aid = acct.id<!--- for archived account --->
			WHERE 
			(acct.is_archived != 1 or acct.is_archived is null) 
			and (i.status = 5 OR i.status = 7 OR i.status = 10 OR i.status = 11 or i.status = 4 or i.status = 8)<!--- Item was sold --->
			<cfif attributes.store NEQ "all">
				AND i.item LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.store#.%">
			</cfif>
			AND e.dtend >= '2005-11-01'
			and i.offebay != '1' 
			AND i.internal_itemCondition != 'amazon'<!--- 20120113 dont include offebay items --->

			<cfif attributes.srch NEQ "">
				AND (
				<cfswitch expression="#attributes.srchfield#">
					<cfcase value="all">
							i.title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.srch#%">
							OR i.item LIKE '%#attributes.srch#%'
							OR i.ebayitem LIKE '%#attributes.srch#%'
							OR e.title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.srch#%">
							OR i.aid LIKE '%#attributes.srch#%'
							OR i.internal_itemSKU LIKE '%#attributes.srch#%'
					</cfcase>
					<cfcase value="ebaytitle">
						e.title LIKE '%#attributes.srch#%'
					</cfcase>
					<cfcase value="internal_itemSKU">
						i.internal_itemSKU = '#attributes.srch#'
					</cfcase>
					<cfdefaultcase>
						i.#attributes.srchfield# LIKE '%#attributes.srch#%'
					</cfdefaultcase>
				</cfswitch>
				)
			</cfif>
			<!---ORDER BY #attributes.orderby# #attributes.dir# 20120607: patrick wanted the template items to be on top of the list results--->
			ORDER BY i.itemis_template_setdate desc, i.itemis_template desc, #attributes.orderby# #attributes.dir#
		</cfquery>



		<cfset _paging.RecordCount = sqlTemp.RecordCount>
		<cfset _paging.StartRow = (attributes.page-1)*_paging.RowsOnPage + 1>
		<cfoutput query="sqlTemp" maxrows="#_paging.RowsOnPage#" startrow="#_paging.StartRow#">
		<cfset dBackground = "##FFFFFF">
		<cfif sqlTemp.listingtype eq 1>
			<cfset dBackground = "##DCEAD0">
		</cfif>
		<tr bgcolor="#dBackground#">
			<td rowspan="2" bgcolor="##FFFFFF" align="center" id="tThumb#sqlTemp.item#">
				<!--- 20120216 fixing the image display coz it doesnt show up when items are duplicated --->
<!---				<cfif sqlTemp.galleryurl EQ "">
					<img src="http://pics.ebaystatic.com/aw/pics/stockimage1.jpg">
				<cfelse>
					<a href="#sqlTemp.galleryurl#" target="_blank">
					<img src="#sqlTemp.galleryurl#" width="80" border="1">
				</cfif>--->
				<cfif sqlTemp.galleryurl EQ "">
					<img src="http://pics.ebaystatic.com/aw/pics/stockimage1.jpg">
				<cfelse>
				<cftry>
						<cfhttp method="head" url="#sqlTemp.galleryurl#" result="sc">
						<cfif sc.statuscode is "200 OK">
							<a href="#sqlTemp.galleryurl#" target="_blank"><img src="#sqlTemp.galleryurl#" border="1" width="80"></a>
						<cfelse>
							<!--- use_pictures --->
							<cfset sqlTemp.galleryurl = replace(sqlTemp.galleryurl,sqlTemp.item,sqlTemp.use_pictures)>
							<img src="#sqlTemp.galleryurl#" border="1" width="80">
						</cfif>
						<!--- patrick wants smaller than 500 to display red background --->
						<cfimage source="#sqlTemp.galleryurl#" name="myImage">
						<cfif myImage.width lt 500 and myImage.height lt 500>
							<script type="text/javascript">									
								var element = document.getElementById('tThumb#sqlTemp.item#');
								element.style.background = '##ff0000';
							</script>
						</cfif>	
						
				<cfcatch>
					<img src="http://pics.ebaystatic.com/aw/pics/stockimage1.jpg">
				</cfcatch>
				</cftry>
				</cfif>


			</td>
			<td colspan="2" align="left"><b>#sqlTemp.title#</b></td>
			<td colspan="2" align="center">#strDate(sqlTemp.dended)#</td>
			<td><cfif sqlTemp.finalprice NEQ "">#DollarFormat(sqlTemp.finalprice)#<cfelse>$0</cfif><cfif sqlTemp.startprice GT 0><br><font color="blue">(#DollarFormat(sqlTemp.startprice)#)</font></cfif></td>
			<td><img src="#request.images_path#<cfif sqlTemp.paid EQ 1>paid-on.gif" alt="Paid<cfelse>paid-off.gif" alt="Not Paid</cfif>" border="0"><img src="#request.images_path#<cfif sqlTemp.shipped EQ 1>ship-on.gif" alt="Shipped<cfelse>ship-off.gif" alt="Not Shipped</cfif>" border="0"><img src="#request.images_path#<cfif sqlTemp.status EQ 7>checkout-on.gif" alt="Check Sent<cfelse>checkout-off.gif" alt="Check Not Sent</cfif>" border="0"></td>
			<td><span style="background-color:##E49BB4">#sqlTemp.shipnote#</span></td>
		</tr>
		<tr bgcolor="#dBackground#">
			<td align="center">
				<cfif sqlTemp.listingtype eq 1>FIXED PRICE ITEM<BR></cfif>
				<a href="index.cfm?dsp=management.items.edit&item=#sqlTemp.item#">#sqlTemp.item#</a></td>
			<td align="center"><cfif sqlTemp.ebayitem NEQ ""><a href="http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=#sqlTemp.ebayitem#" target="_new">#sqlTemp.ebayitem#</a></cfif></td>
			<td align="center"><cfif sqlTemp.lid NEQ ""><br>LID: #sqlTemp.lid#</cfif></td>
			<td align="center">#sqlTemp.hbuserid#</td>
			<td colspan="2" align="center">
<!--- DUPLICATE AUCTIONS --->
				<cfif sqlTemp.ready EQ "1">
					<form action="index.cfm?dsp=#attributes.dsp#&act=admin.auctions.duplicate_lister_description" method="post" name="duplicateForm">
					<input type="hidden" name="item" value="#sqlTemp.item#">
					<select name="newitem" style="width:150px;">
					<option value="">--- Select One ---</option>
					#sameSKU("#sqlTemp.internal_itemSKU#")#
					#optGroup_2()#
					#optGroup(ListGetAt(sqlTemp.item, 2, "."))#
					#optGroup(1008)#

					<!---#optGroup(4964)#--->
					</select>
<!---					<cfoutput>
						#ListGetAt(sqlTemp.item, 2, ".")#<br>
					</cfoutput>--->
					<br>
					Custom ## <input type="text" name="customitem" value="" style="width:80px; font-size:9px; height:16px;">
					<br>
					<input type="submit" value="Duplicate Auction" style="width:150px; font-size:9px; height:20px;">
					<cfif sqlTemp.itemis_template is 1>
						<h5 style="background-color:##E49BB4">
							This is an auction template<br>
						#dateformat(sqlTemp.itemis_template_setdate,"medium")#
						</h5>


					</cfif>
					<input type="hidden" name="recentSearch" value="#attributes.srch#" >

							<cfif attributes.srch neq ''>
								<input type="hidden" name="showSearchAgain" value="1" >
							<cfelse>
								<input type="hidden" name="showSearchAgain" value="0" >
							</cfif>

					</form>
				<cfelse>
					N/A
				</cfif>
<!--- / DUPLICATE AUCTIONS --->
			</td>
<td>
	#sqlTemp.internal_itemCondition#
</td>
	</tr>
<!---<tr>
<td colspan="8">
	#sqlTemp.shipnote#<br>
</td>
	</tr>
--->
		</cfoutput>



		<cfoutput>
		<tr bgcolor="##FFFFFF"><td colspan="8" align="center">
			</cfoutput><cfinclude template="../../../paging.cfm"><cfoutput>
		</td></tr>
		</table>
	</td></tr>
	</table>
</td></tr>
</table>

<cfif attributes.showSearchAgain >
	<script type="text/javascript">
		document.searchForm.submit();
	</script>
</cfif>

</cfoutput>
