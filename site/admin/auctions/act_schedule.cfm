<cfset _machine.cflocation = "index.cfm?dsp=management.items.ready2launch">
<cfif isDefined("attributes.update")>
	<cfloop index="i" list="#attributes.fieldnames#">
		<cfif (ListLen(i, "_") EQ 2) AND (ListFirst(i, "_") EQ "item")>
			<cfset _iRow = ListLast(i, "_")>
			<cfset _itemid = attributes[i]>
			<cfset _title = attributes["title_#_iRow#"]>
			<cfset _subtitle = attributes["subtitle_#_iRow#"]>
			<cfset _startingprice = attributes["startingprice_#_iRow#"]>
			<cfset _duration = attributes["duration_#_iRow#"]>
			<cfset _itemCondition = attributes["itemCondition_#_iRow#"]>
			<cfset _BuyItNowPrice = attributes["buynowPrice_#_iRow#"]>
			<cfquery datasource="#request.dsn#">
				UPDATE auctions
				SET Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_title#" maxlength="80">,
					SubTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_subtitle#" maxlength="55">,
					StartingPrice = <cfqueryparam cfsqltype="cf_sql_real" value="#_startingprice#">,
					Duration = <cfqueryparam cfsqltype="cf_sql_smallint" value="#_duration#">,
					conditionID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#_itemCondition#">,
					BuyItNowPrice = <cfqueryparam cfsqltype="cf_sql_real" value="#_BuyItNowPrice#">
				WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_itemid#">
			</cfquery>


		</cfif>
	</cfloop>
<cfelse>
	<!---
		20110609
		Vlad updated this code to include 15 minutes
	 --->
	<cfif Left(attributes.startTime, 1) NEQ "+" and Left(attributes.startTime, 1) NEQ "-">
		<cfset _listAt = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), attributes.startTime, 0, 0)>
	<cfelseif Left(attributes.startTime, 1) EQ "-" >
		<cfset attributes.startTime = #RemoveChars(attributes.startTime,1,1)#>
		<cfset attributes.startTime = Val(attributes.startTime)>
		<cfset _listAt = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), attributes.startTime, 15, 0)>
	<cfelse>
		<cfset attributes.startTime = Val(attributes.startTime)>
		<cfset _listAt = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), attributes.startTime, 30, 0)>
	</cfif>
	<cfparam name="attributes.startDay" default="0">
	<cfif attributes.startDay GT 0>
		<cfset _listAt = DateAdd("d", attributes.startDay, _listAt)>
	<cfelseif _listAt LTE Now()>
		<cfset _listAt = DateAdd("d", 1, _listAt)>
	</cfif>
	<cfloop index="i" from="#attributes.iBegin#" to="#attributes.iEnd#">
		<cfif isDefined("attributes.cb#i#")>
			<cfset _itemid = attributes["cb#i#"]>
			<cfset _title = attributes["title_#i#"]>
			<cfset _subtitle = attributes["subtitle_#i#"]>
			<cfset _startingprice = attributes["startingprice_#i#"]>
			<cfset _duration = attributes["duration_#i#"]>
			<cftransaction>
				<cfquery datasource="#request.dsn#" name="sqlCurrent">
					SELECT Title, SubTitle, StartingPrice
					FROM auctions
					WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_itemid#">
				</cfquery>
				<cfquery datasource="#request.dsn#">
					UPDATE auctions
					SET Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_title#" maxlength="80">,
						SubTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_subtitle#" maxlength="55">,
						StartingPrice = <cfqueryparam cfsqltype="cf_sql_real" value="#_startingprice#">,
						Duration = <cfqueryparam cfsqltype="cf_sql_smallint" value="#_duration#">
					<cfif (sqlCurrent.Title NEQ _title) OR (sqlCurrent.SubTitle NEQ _subtitle) OR (Val("#sqlCurrent.StartingPrice#") NEQ Val("#_startingprice#"))>
						, scheduledBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(session.user.first, 1)##Left(session.user.last, 1)#">
					</cfif>
					WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_itemid#">
				</cfquery>
				<cfquery datasource="#request.dsn#">
					DELETE FROM queue
					WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_itemid#">
				</cfquery>
				<cfquery datasource="#request.dsn#">
					INSERT INTO queue
					(itemid, listAt)
					VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#_itemid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#_listAt#">
					)
				</cfquery>
			</cftransaction>
			<cfset _listAt = DateAdd(attributes.period, attributes.interval, _listAt)>
		</cfif>
	</cfloop>
	<cfset attributes.ScheduleOnly = TRUE>
	<cfinclude template="st_scheduler.cfm">
</cfif>
