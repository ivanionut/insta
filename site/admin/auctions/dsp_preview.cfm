<cfif NOT isAllowed("Lister_ListAuction")>
	<cflocation url="index.cfm?dsp=slim_login" addtoken="no">
</cfif>

<cfoutput>
<style type="text/css">
h1{
	background-color:##CCCCCC;
	text-align:center;
}
</style>
<h1>Listing Preview</h1>
</cfoutput>

<cfif isDefined("attributes.back2lister")>
	<cfoutput>
	<center>
		<button style="width:100px;" onClick="window.location.href = 'index.cfm?dsp=admin.auctions.step3&item=#attributes.item#'">Back</button>
		&nbsp;&nbsp;&nbsp;
		<button style="width:100px;" onClick="window.location.href = 'index.cfm?act=admin.auctions.step3&item=#attributes.item#&finish=1'">Finish</button>
	</center>
	</cfoutput>
</cfif>

<cfinclude template="layout/show.cfm">
<cfoutput>#sqlAuction.layout#</cfoutput>
<cfoutput><h1>Listing Preview</h1></cfoutput>
