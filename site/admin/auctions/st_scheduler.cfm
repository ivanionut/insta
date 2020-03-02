
<!---
For some reason the scheduler is being caught by the login logic. specifically the get item
resolution: check that the scheduler is being run by server or add url var runme=1 to manually run it
TO GET IP OF SERVER:
<cfset serverIP = #createObject("java", "java.net.InetAddress").getLocalHost().getHostAddress()#>
TO GET THE IP OF CALLER
#cgi.remote_addr#

--->


<cfset serverIP = #createObject("java", "java.net.InetAddress").getLocalHost().getHostAddress()#>
<cfset theSchedCaller = cgi.remote_addr >

<cfoutput>
	<cfif isdefined("url.runme") or serverIP eq theSchedCaller >
		<cfquery name="sqlLogin1" datasource="#request.dsn#">
			SELECT id, email, first, last, usertype, rid, store
			FROM accounts
			WHERE email = 'redhot_vlady_23@yahoo.com'
				AND pass = '#Hash("solis")#'
		</cfquery>
		<cfscript>
			session.user = StructNew ();
			session.user.accountid	= sqlLogin1.id;
			session.user.email		= sqlLogin1.email;
			session.user.first		= sqlLogin1.first;
			session.user.last		= sqlLogin1.last;
			session.user.usertype	= sqlLogin1.usertype;
			session.user.rid		= sqlLogin1.rid;
			session.user.store		= sqlLogin1.store;
			session.user.site		= "ebay";
			//LogAction("logged in");
		</cfscript>

		<cfif isdefined("url.runme")>
			MANUALLY BY: #session.user.first# #session.user.last#<br>
		</cfif>
		<cfif serverIP eq theSchedCaller>
			CALL_BY_SERVER: #serverIP#<BR>
		</cfif>
	</cfif>
</cfoutput>



<cflock name="scheduler" timeout="30" throwontimeout="no" type="exclusive">
	<cfset nextRun = DateAdd("h", 1, Now())>
	<cfset minSecBetweenRuns = 20><!--- REDUCING THIS VALUE MAY CAUSE UNSTABLE WORK --->
	<cfif isDefined("attributes.ScheduleOnly")>
		<cfquery datasource="#request.dsn#" name="sqlQueue" maxrows="1">
			SELECT listAt
			FROM queue
			WHERE error IS NULL
			ORDER BY listAt
		</cfquery>
		<cfif sqlQueue.RecordCount GT 0>
			<cfset nextRun = sqlQueue.listAt>
		</cfif>
	<cfelse>
		<cfset attributes.sandbox = FALSE>
		<cfif attributes.sandbox>
			<cfoutput><h1 style="color:blue;">SANDBOX ENVIRONMENT</h1></cfoutput>
		<cfelse>
			<cfoutput><h1 style="color:green;">PRODUCTION ENVIRONMENT</h1></cfoutput>
		</cfif>
		<cfquery datasource="#request.dsn#" name="sqlQueue">
			SELECT q.itemid, q.listAt
			FROM queue q
				INNER JOIN items i ON q.itemid = i.item
			WHERE q.error IS NULL and
			(i.status != '11' and i.status != '16' and i.status != '10')<!--- don't launch auction which are paid and shipped and marked as fixed inventory items  --->
			ORDER BY q.listAt
		</cfquery>


		<cfloop query="sqlQueue">
			<cfif DateDiff("s", Now(), listAt) LTE minSecBetweenRuns>
				<cftry>
					<cfoutput><li>Launch auction for item #itemid#</li></cfoutput>
					<cfset attributes.CallName = "AddItem">
					<cfset attributes.item = sqlQueue.itemid>



					<cfsavecontent variable="cntDescription">
						<cfinclude template="layout/show.cfm">
					</cfsavecontent>

					<cfinclude template="get_item.cfm">

					<cfinclude template="act_build_item.cfm">
					<cfset _ebay.XMLRequest = toString(xmlDoc)>
					<cfset _ebay.SiteID = sqlAuction.SiteID>
					<cfinclude template="../../api/act_call.cfm">
					<cfset _ebay.SiteID = 0>
					<cfif NOT isDefined("_ebay.xmlResponse") OR (_ebay.Ack EQ "failure")>
						<cfsavecontent variable="errorHTML">
							<cfif StructKeyExists(_ebay, "xmlResponse")>
								<cfoutput><h1 style="color:red;">API call failed :(</h1></cfoutput>
								<cfloop index="i" from="1" to="#ArrayLen(_ebay.xmlResponse.xmlRoot.Errors)#">
									<cfoutput>
									<h2 style="color:red;">#_ebay.xmlResponse.xmlRoot.Errors[i].SeverityCode.xmlText#: #_ebay.xmlResponse.xmlRoot.Errors[i].ShortMessage.xmlText#</h2>
									<h3>#HTMLEditFormat(_ebay.xmlResponse.xmlRoot.Errors[i].LongMessage.xmlText)#</h3>
									</cfoutput>
									<cfif StructKeyExists(_ebay.xmlResponse.xmlRoot.Errors[i], "ErrorParameters")>
										<cfoutput><ul>Error Parameters:</cfoutput>
										<cfloop index="j" from="1" to="#ArrayLen(_ebay.xmlResponse.xmlRoot.Errors[i].ErrorParameters)#">
											<cfoutput><li>#HTMLEditFormat(_ebay.xmlResponse.xmlRoot.Errors[i].ErrorParameters[j].Value.xmlText)#</li></cfoutput>
										</cfloop>
										<cfoutput></ul></cfoutput>
									</cfif>
								</cfloop>
							<cfelse>
								<cfoutput>
								<h1 style="color:red;">API call failed: #err_message#</h1>
								<b>Error Details:</b><br>
								#err_detail#
								</cfoutput>
							</cfif>
						</cfsavecontent>
						<cfquery datasource="#request.dsn#">
							UPDATE queue
							SET error = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#errorHTML#">
							WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sqlQueue.itemid#">
						</cfquery>
						<cfoutput><li style="color:red;">Error while launching auction for item #itemid#:</li>#errorHTML#</cfoutput>
					<cfelse>
						<cfinclude template="act_just_listed.cfm">
						<cfoutput><li style="color:green;">Auction for item #itemid# launched to eBay #_ebay.xmlResponse.xmlRoot.ItemID.xmlText#</li></cfoutput>
					</cfif>
					<cfcatch type="any">
						<!--- do nothing --->
					</cfcatch>
				</cftry>
			<cfelse>
				<cfset nextRun = listAt>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
	<!--- SCHEDULE TASK --->
	<cfset sURL = "http://#CGI.HTTP_HOST##CGI.PATH_INFO#?dsp=admin.auctions.st_scheduler">
	<cfif DateDiff("s", Now(), nextRun) LTE minSecBetweenRuns>
		<cfset nextRun = DateAdd("s", minSecBetweenRuns, Now())>
	</cfif>
	<cfset runDate = CreateDate(Year(nextRun), Month(nextRun), Day(nextRun))>
	<cfset runTime = CreateTime(Hour(nextRun), Minute(nextRun), Second(nextRun))>
	<cfschedule action="update" task="ia_scheduler" operation="HTTPRequest"
		url="#sURL#" startdate="#runDate#" starttime="#runTime#"
		path="#request.basepath#" file="ia_scheduler.html.txt"
		resolveurl="yes" publish="yes" interval="3600" requesttimeout="900">
	<cfset attr = StructNew ()>
	<cfset attr.name = "system.st_scheduler_runat">
	<cfset attr.avalue = "#nextRun#">
	<cfmodule template="../act_updatesetting.cfm" attributecollection="#attr#">
	<cfoutput><h1>NEXT RUN SCHEDULED AT #nextRun#</h1></cfoutput>
</cflock>

<cfoutput>
	<!--- lets force logout if its manual run --->
	<cfif isdefined("url.runme")>
		CLEAR BY: #session.user.first# #session.user.last#<br>
		<cfset t = structclear(session) >
	</cfif>

	<!--- lets force logout EVEN SERVER RUN. advice by Roman. --->
	<cfif serverIP eq theSchedCaller>
		CLEAR BY SERVER: #theSchedCaller#<br>
		<cfset t = structclear(session) >
	</cfif>
</cfoutput>