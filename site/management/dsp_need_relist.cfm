<cfif NOT isAllowed("Lister_ReserveNotMet")>
	<cflocation url="index.cfm?dsp=slim_login&next_dsp=#attributes.dsp#" addtoken="no">
</cfif>





<cfparam name="attributes.orderby" default="17">
<cfparam name="attributes.dir" default="asc">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.srch" default="">
<cfparam name="attributes.srchfield" default="all">
<cfparam name="attributes.secondSort" default="4">

<!--- form handler --->

<cfif isdefined("form.submitted")>
	
	<cfloop list="#form.chkRelist#" index="item">
		
		<cfquery datasource="#request.dsn#">
			update items
			set status = 17
			where item = '#item#'
		</cfquery>	
		
	</cfloop>
		
</cfif>







<cfquery name="sqlTemp" datasource="#request.dsn#">
	SELECT i.item, i.ebayitem, i.title, e.dtend, i.status, e.galleryurl,
		a.first, a.last, i.aid, i.startprice, e.price, e.hbemail, i.refundpr,
		i.lid, i.dlid, ea.UserID, i.internal_itemsku,
		i.exception, DATEDIFF(DAY, e.dtend, GETDATE()) AS ap, a.phone, i.internal_itemCondition
		
	<cfif attributes.dsp NEQ "management.apayment" and attributes.dsp neq "management.reserve">
		, i.shipnote
	</cfif>
	
	<cfif attributes.dsp EQ "management.apayment">
		, MAX(t.PaidTime) AS PaidTime
	</cfif>
	
	,max(u.use_pictures) as use_pictures,
	max(status.status) as istatus
	FROM items i
		INNER JOIN ebitems e ON i.ebayitem = e.ebayitem
		LEFT JOIN accounts a ON a.id = i.aid
		LEFT JOIN auctions u ON u.itemid = i.item
		LEFT JOIN status status ON i.status = status.id
		LEFT JOIN ebaccounts ea ON u.ebayaccount = ea.eBayAccount
	<cfif attributes.dsp EQ "management.reserve">
		
		WHERE i.status = 6<!--- Reserve Not Met --->


	GROUP BY i.item, i.ebayitem, i.title, e.dtend, i.status, e.galleryurl,
		a.first, a.last, i.aid, i.startprice, e.price, e.hbemail, i.refundpr, i.lid, i.dlid, ea.UserID,
		i.exception, <!---DATEDIFF(DAY, e.dtend, GETDATE()),---> a.phone, i.internal_itemsku, i.internal_itemCondition
		
			
	<cfelseif attributes.dsp EQ "management.apayment">
		LEFT JOIN ebtransactions t ON i.ebayitem = t.itmItemID
		LEFT JOIN queue q ON i.item = q.itemid
		
	WHERE q.itemid IS NULL
		and i.status != 16<!--- dont include fixed inventory list --->
		AND
		(
			(
				(i.exception = 2)
					AND
				(i.status NOT IN (12,14,17,11))<!--- 17 is relist confirm which is to be relisted --->
				<!---  i.status != 11 paid and shipped --->
				
			)<!--- Need to Call, Item Relotted --->
			
			<!---
			:vladedit: 20160115
			- We have some very slow payers right now and is clogging up my main list with all that
			-  All those items are already in the green list tab --->
			
			
			<cfif attributes.srch is "0" and attributes.srchfield is "exception">
			OR
			(
				(i.status = 5)<!--- Awaiting Payment ---> 
					and
				(e.dtend < DATEADD(DAY, -25, GETDATE()))
					AND
				(e.dtend >= '2005-10-01')
					AND
				(i.exception = 0)
			)
			</cfif>
			
		)
		<cfif attributes.srch NEQ "">
			<cfswitch expression="#attributes.srchfield#">
				<cfcase value="aid">
					AND i.aid = #attributes.srch#
				</cfcase>
				<cfcase value="exception">
					AND i.exception = #attributes.srch#						
				</cfcase>
				<cfcase value="price">
					AND e.price = #attributes.srch#
				</cfcase>
				<cfcase value="client_name">
					AND a.first + ' ' + a.last LIKE '%#attributes.srch#%'
				</cfcase>
				<cfcase value="AP">
					AND (#attributes.srch# = DATEDIFF(DAY, e.dtend, GETDATE()))
				</cfcase>
				<cfcase value="listingType">
					AND u.listingtype = #attributes.srch#
				</cfcase>
				<cfdefaultcase>
					AND i.#attributes.srchfield# LIKE '%#attributes.srch#%'
				</cfdefaultcase>
			</cfswitch>
		</cfif>
		
	GROUP BY i.item, i.ebayitem, i.title, e.dtend, i.status, e.galleryurl,
		a.first, a.last, i.aid, i.startprice, e.price, e.hbemail, i.refundpr, i.lid, i.dlid, ea.UserID,
		i.exception, <!---DATEDIFF(DAY, e.dtend, GETDATE()),---> a.phone, i.internal_itemsku, i.internal_itemCondition
		
	</cfif>
	ORDER BY #attributes.orderby# #attributes.dir#
	
	<!--- :vladedit: fix: we want to sort by date ended but errors coz it twice appeared in sort  --->
	<cfif attributes.secondSort and	structkeyExists(url,'orderby') and url.orderby neq 4 >
		, #attributes.secondSort# #attributes.dir#
	</cfif>
</cfquery>


<!---<cfdump var="#sqlTemp#" >--->
<cfset _paging.RecordCount = sqlTemp.RecordCount>
<cfset _paging.StartRow = (attributes.page-1)*_paging.RowsOnPage + 1>

<cfif isDefined("attributes.printable")>
	<cfset  _machine.layout = "none">
<cfelse>
	<cfoutput>
	<script language="javascript" type="text/javascript">
	<!--//
		function fPage(Page){
			window.location.href = "#_machine.self#&orderby=#attributes.orderby#&secondSort=#attributes.secondSort#&dir=#attributes.dir#&page="+Page<cfif attributes.srch NEQ "">+"&srch=#URLEncodedFormat(attributes.srch)#&srchfield=#attributes.srchfield#"</cfif>;
		}
		function fSort(OrderBy){
			if (#attributes.orderby# == OrderBy){
				dir = <cfif attributes.dir EQ "ASC">"DESC"<cfelse>"ASC"</cfif>;
			}else{
				dir = "ASC";
			}
			window.location.href = "#_machine.self#&page=#attributes.page#&orderby="+OrderBy+"&dir="+dir<cfif attributes.srch NEQ "">+"&srch=#URLEncodedFormat(attributes.srch)#&srchfield=#attributes.srchfield#"</cfif>;
		}
		function fShipNote(itemid){
			ShipNoteWin = window.open("index.cfm?dsp=admin.ship.note&itemid="+itemid, "ShipNoteWin", "height=300,width=600,location=no,scrollbar=yes,menubar=yes,toolbars=yes,resizable=yes");
			ShipNoteWin.opener = self;
			ShipNoteWin.focus();
		}
		function scndSort(firstSort,sSort){
			if (#attributes.orderby# == firstSort){
				dir = <cfif attributes.dir EQ "ASC">"DESC"<cfelse>"ASC"</cfif>;
			}else{
				dir = "ASC";
			}
			window.location.href = "#_machine.self#&page=#attributes.page#&orderby="+firstSort+"&secondSort="+sSort+"&dir="+dir<cfif attributes.srch NEQ "">+"&srch=#URLEncodedFormat(attributes.srch)#&srchfield=#attributes.srchfield#"</cfif>;
		}

		function toggle(source) {
		  checkboxes = document.getElementsByName('chkRelist');
		  for(var i=0, n=checkboxes.length;i<n;i++) {
		    checkboxes[i].checked = source.checked;
		  }
		}

	//-->
	</script>
	</cfoutput>
</cfif>

<cfoutput>

<table width="100%" style="text-align: justify;">
<tr><td>
	<table cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td align="left"><font size="4"><strong>
			<cfif attributes.dsp EQ "management.reserve">
				Need to Relist (Reserve Not Met):
			<cfelseif attributes.dsp EQ "management.apayment">
				Need to Relist (Awaiting Payment 25+ Days):
			</cfif>
			</strong></font><br></td>
		<td align="right" style="padding-right:10px;">
			<cfif isDefined("attributes.printable")>
				Page #attributes.page# of #Int(0.9999 + _paging.RecordCount/_paging.RowsOnPage)#
			<cfelse>
				<a href="index.cfm?dsp=admin.auctions.relistItems" >Bulk Relist</a>
				<a href="#_machine.self#&page=#attributes.page#&orderby=#attributes.orderby#&dir=#attributes.dir#&printable" target="_blank">Printable version</a>
			</cfif>
		</td>
	</tr>
	</table>
	<cfif NOT isDefined("attributes.printable")>
		<hr size="1" style="color: Black;" noshade>
		<table width="100%">
		<tr>
			<td width="40%" align="left" valign="top">
				<strong>Administrator:</strong> #session.user.first# #session.user.last#
				<br><br style="line-height:5px;">
				<a href="index.cfm?dsp=#attributes.dsp#&srchfield=price&srch=9.99">$9.99 list</a>
				|
				<a href="index.cfm?dsp=#attributes.dsp#&srchfield=exception&srch=0" style="color:##008000;">Green list</a>
				|
				<a href="index.cfm?dsp=#attributes.dsp#&srchfield=listingtype&srch=1">Fixed list</a>
			</td>
			<td width="60%" align="left">
			<cfif attributes.dsp NEQ "management.apayment">
				&nbsp;
			<cfelse>
				Enter Search Term:<br>
				<form method="POST" action="#_machine.self#">
					<input type="text" size="20" maxlength="50" name="srch" value="#HTMLEditFormat(attributes.srch)#">
					<select name="srchfield" style="font-size: 13px;">
						#SelectOptions(attributes.srchfield, "item,item number;title,item title;aid,account number;ebayitem,ebay number;client_name,client name;AP,days since auction;price,end price;internal_itemSKU,SKU")#
					</select>
					<input type="submit" value="Search">
				</form>
			</cfif>
			</td>
		</tr>
		</table>
	</cfif>
	<cfif isDefined("attributes.error_message")>
		<h3 style="color:red;">#attributes.error_message#</h3>
	</cfif>
<form method="post" action="index.cfm?dsp=management.apayment">	
	<table bgcolor="##aaaaaa" border=0 cellspacing="0" cellpadding=0 width="100%">
	<tr><td>
		<table width="100%" cellspacing="1" cellpadding="4">
		<tr bgcolor="##F0F1F3">
			<td class="ColHead">Gallery</td>
			<td class="ColHead">Note</td>
		<cfif isDefined("attributes.printable")>
			<td class="ColHead">Owner</td>
			<td class="ColHead">Item ID</td>
			<td class="ColHead">eBay Item</td>
			<td class="ColHead">Date Ended</td>
		<cfelse>
			<td class="ColHead"><a href="JavaScript: void fSort(7);">Owner</a> |
			<a href="JavaScript: void fSort(17);">SKU</a> | <a href="JavaScript: void scndSort(17,4);">SKU&D-End</a>
			</td>
			<td class="ColHead"><a href="JavaScript: void fSort(1);">Item ID</a><br><a href="JavaScript: void fSort(14);">LID</a> | <a href="JavaScript: void fSort(15);">DLID</a></td>
			<td class="ColHead"><a href="JavaScript: void fSort(16);">Account</a><br><a href="JavaScript: void fSort(2);">eBay Item</a></td>
			<td class="ColHead"><a href="JavaScript: void fSort(4);">Date Ended</a><br><a href="JavaScript: void fSort(11);">End Price</a> (<a href="JavaScript: void fSort(10);">Reserve</a>)</td>
		</cfif>
			<td align="center">Check All<br>
				<input type="checkbox" onClick="toggle(this)" name="chkRelist" value="">
			</td>
		</tr>
		</cfoutput>
		<cfif isDefined("attributes.printable")>
			<cfset _paging.RowsOnPage = 1000000>
			<cfset _paging.StartRow = 1>
		</cfif>
		<cfoutput query="sqlTemp" maxrows="#_paging.RowsOnPage#" startrow="#_paging.StartRow#">
			<tr bgcolor="###iif(currentrow MOD 4,DE('ffffff'),DE('E3E1EF'))#">
				<td rowspan="2" align="center" id="tThumb#sqlTemp.item#">
						<!--- 20120216 thumb fix  --->
						<cfset galleryUrlThumb = sqlTemp.galleryurl >
					
						<!---<cftry>
							
							<cfhttp method="head" url="#sqlTemp.galleryurl#" result="sc">

							
							<cfif sc.statuscode is "200 OK">
								
								<cfset galleryUrlThumb = sqlTemp.galleryurl >
								
							<cfelse>
								<!--- use_pictures --->
								<cfset galleryUrlThumb = replace(sqlTemp.galleryurl,sqlTemp.item,sqlTemp.use_pictures)>
							</cfif>
							
							
							<!--- patrick wants smaller than 500 to display red background --->
							<!---<cfimage source="#galleryUrlThumb#" name="myImage" >--->
							<!---<cfset myImage = imageNew("#galleryUrlThumb#")>---> 
								
							<cfif myImage.width lt 500 and myImage.height lt 500>
								<script type="text/javascript">									
									var element = document.getElementById('tThumb#sqlTemp.item#');
									element.style.background = '##ff0000';
								</script>
							</cfif>
							
							
						<cfcatch>
							<cfset galleryUrlThumb = "http://pics.ebaystatic.com/aw/pics/stockimage1.jpg">
						</cfcatch>
						</cftry>--->
						
					<a href="#galleryUrlThumb#" target="_blank">
						<cfif isDefined("attributes.printable") AND sqlTemp.lid NEQ "">
							LID: #sqlTemp.lid#
						<cfelse>
								<img src="#galleryUrlThumb#" border="1" width="80"
								<!---onload="imgLoaded(this)"---> 
								onError="this.onerror=null;this.src='http://pics.ebaystatic.com/aw/pics/stockimage1.jpg';">
						</cfif>
					</a>



				</td>
				<cfif attributes.dsp EQ "management.apayment">
					<cfquery name="sqlAPayment" datasource="#request.dsn#">
						SELECT shipnote
						FROM items
						WHERE item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sqlTemp.item#">
					</cfquery>
				<td rowspan="2" align="center"><cfif isAllowed("Listings_EditShippingNote")><a href="javascript: fShipNote('#sqlTemp.item#')"><cfif sqlAPayment.shipnote EQ ""><img src="#request.images_path#icon14.gif" border=0><cfelse>Edit</cfif></a><cfelse><cfif sqlAPayment.shipnote EQ "">N/A<cfelse><a href="javascript: fShipNote('#sqlTemp.item#')">View</a></cfif></cfif></td>

				<cfelse>
					<td rowspan="2" align="center"><cfif isAllowed("Listings_EditShippingNote")><a href="javascript: fShipNote('#sqlTemp.item#')"><cfif sqlTemp.shipnote EQ ""><img src="#request.images_path#icon14.gif" border=0><cfelse>Edit</cfif></a><cfelse><cfif sqlTemp.shipnote EQ "">N/A<cfelse><a href="javascript: fShipNote('#sqlTemp.item#')">View</a></cfif></cfif></td>
				</cfif>
            	<td colspan="3" align="left">
            		<strong<cfif (attributes.dsp EQ "management.apayment") AND (sqlTemp.exception EQ 0)> style="color:##008000;"</cfif>>            			
            		#sqlTemp.title#</strong>
            		
            			<strong style="color:##6868F2">
	            			<span style="float:right">SKU: 
	            			#sqlTemp.internal_itemsku#</span>
							
	            			<span style="float:left;">
	            			cond:
	            			#sqlTemp.internal_itemCondition#
	            			</span>
            			</strong>
            	</td>
				<td align="center"><b>#DateFormat(sqlTemp.dtend, "mmm d, yyyy")#</b></td>
			</tr>

			<tr bgcolor="###iif(currentrow MOD 4,DE('ffffff'),DE('E3E1EF'))#">
				<td align="center"><a href="index.cfm?dsp=account.edit&id=#sqlTemp.aid#">#sqlTemp.first# #sqlTemp.last#</a><br>#sqlTemp.phone#</td>
				<td align="center"><a href="index.cfm?dsp=management.items.edit&item=#sqlTemp.item#">#sqlTemp.item#</a><cfif sqlTemp.lid NEQ "">
					<br>LID: #sqlTemp.lid#<br>
					Status: #sqlTemp.istatus#<br>

				<strong>DLID: #DateFormat(sqlTemp.dlid, "mmm d, yyyy")#</strong></cfif></td>
				<td align="center">
					#sqlTemp.UserID#<br>
					<a href="http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=#sqlTemp.ebayitem#" target="_blank">#sqlTemp.ebayitem#</a>
					<cfif attributes.dsp EQ "management.apayment">
						<cfquery name="sqlRecord" datasource="#request.dsn#">
							SELECT COUNT(DISTINCT ebayitem) AS cnt FROM ebitems WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sqlTemp.item#">
						</cfquery>
						<br>Listed #sqlRecord.cnt# time<cfif sqlRecord.cnt NEQ 1>s</cfif>
					</cfif>
				</td>
				<td align="center">
				<cfif sqlTemp.status EQ "8"><!--- DID NOT SELL --->
					Reserve Not Met<br>
					$#sqlTemp.price# ($#sqlTemp.startprice#)<br>
					<cfif NOT isDefined("attributes.printable")>
						<!---<a href="index.cfm?act=admin.api.second_chance&ebayitem=#sqlTemp.ebayitem#"><img alt="Second Chance" src="#request.images_path#icon15.gif" border="0"></a>--->
						<cfif Find(sqlTemp.item, sqlTemp.galleryurl)>
							<a href="index.cfm?dsp=admin.auctions.relist_item&item=#sqlTemp.item#"><img alt="Relist Item" src="#request.images_path#icon8.gif" border="0"></a>
						</cfif>
						<!---<a href="index.cfm?act=management.just_called&item=#sqlTemp.item#"><img alt="Already Called (Did Not Accept Reserve)" src="#request.images_path#icon9.gif" border="0"></a>
						<a href="index.cfm?act=management.just_return&item=#sqlTemp.item#"><img alt="Not Called Yet (Will Not Accept Reserve)" src="#request.images_path#icon10.gif" border="0"></a>--->
					</cfif>
				<cfelse>
					AP: <b>#AP#</b> Days<br>
					#DollarFormat(val(sqlTemp.price))# ($#sqlTemp.startprice#)<br>
					<cfif NOT isDefined("attributes.printable")>
						<!---<a href="index.cfm?act=admin.api.second_chance&ebayitem=#sqlTemp.ebayitem#"><img alt="Second Chance" src="#request.images_path#icon15.gif" border="0"></a>--->
						<cfif Find(sqlTemp.item, sqlTemp.galleryurl)>
							<a href="index.cfm?dsp=admin.auctions.relist_item&item=#sqlTemp.item#"><img alt="Relist Item" src="#request.images_path#icon8.gif" border="0"></a>
						</cfif>
						<!---<a href="index.cfm?act=management.just_return&item=#sqlTemp.item#&dsp=#attributes.dsp#"><img alt="Not Called Yet (Not Going to Relist)" src="#request.images_path#icon10.gif" border="0"></a>--->
					</cfif>
				</cfif>
				</td>
				<td align="center"><input type="checkbox" name="chkRelist" value="#sqltemp.item#"></td>
			</tr>
			<cfif (attributes.dsp EQ "management.apayment") AND isDate(sqlTemp.PaidTime)>
			<tr bgcolor="red"><td colspan="6" align="center" style="color:white; font-weight:bold;">Please check item above (#sqlTemp.item#). It might be paid at #DateFormat(sqlTemp.PaidTime)#</td></tr>
			</cfif>

		<cfif attributes.dsp EQ "management.apayment">
			<cfif sqlAPayment.shipnote NEQ "">
				<tr bgcolor="##FFFFFF"><td colspan="6"><b>Note: </b>#sqlAPayment.shipnote#<br><br></td></tr>
			</cfif>
		<cfelseif sqlTemp.shipnote NEQ "">
			<tr bgcolor="##FFFFFF"><td colspan="6"><b>Note: </b>#sqlTemp.shipnote#<br><br></td></tr>
		<cfelse>
			<tr bgcolor="##FFFFFF"><td colspan="6">&nbsp;</td></tr>
		</cfif>
		</cfoutput>
		<cfif NOT isDefined("attributes.printable")>
			<cfoutput>
			<tr bgcolor="##FFFFFF"><td colspan="6" align="center">
				</cfoutput><cfinclude template="../../paging.cfm"><cfoutput>
			</td></tr>
			</cfoutput>
		</cfif>
		<cfoutput>
			<tr bgcolor="##FFFFFF"><td colspan="6" align="center">
				<input type="submit" name="RelistChecked" value="Relist Checked">
				<input type="hidden" name="submitted" value="1">
			</tr>		
		</table>
	</td></tr>
	</table>
</form>	
</td></tr>
</table>
<script src="layouts/default/jquery-1.4.3.min.js" language="javascript" type="text/javascript"></script> 
 <script type="text/javascript">

 
  	function imgLoaded(img){
 		//console.log(img)
 	}	
 </script>
</cfoutput>
