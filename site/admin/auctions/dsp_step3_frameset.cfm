<cfparam name="attributes.imgnum" default="1">
<cfparam name="attributes.from" default="N/A">
<cfparam name="attributes.doNotResize" default="0">
<cfparam name="attributes.item">

<cfquery datasource="#request.dsn#" name="sqlItem">
	SELECT use_pictures
	FROM auctions
	WHERE itemid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.item#">
</cfquery>
<cfif sqlItem.RecordCount EQ 0><!--- INVALID OR NOT EXISTED ITEM --->
	<cflocation url="index.cfm?dsp=management.items.invalid&item=#attributes.item#">
<cfelseif sqlItem.use_pictures NEQ "">
	<cflocation url="index.cfm?dsp=admin.auctions.step3_right&item=#attributes.item#&from=#attributes.from#&use_pictures=#sqlItem.use_pictures#">
</cfif>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>#_vars.site.title#</title>
</head>

<frameset cols="700,*" frameborder="no" border="0" framespacing="0">
  <frame src="index.cfm?dsp=admin.auctions.step3_left&item=#attributes.item#&from=#attributes.from#&doNotResize=#attributes.doNotResize#&imgnum=#attributes.imgnum#" name="leftFrame" scrolling="NO" noresize>
  <frame src="index.cfm?dsp=admin.auctions.step3_right&item=#attributes.item#&from=#attributes.from#&doNotResize=#attributes.doNotResize#" name="rightFrame" marginheight="0" marginwidth="0">
</frameset>

<noframes>
	<body>SORRY, YOUR BROWSER DOES NOT SUPPORT &gt;FRAMESET&lt;</body>
</noframes>

</html>
</cfoutput>
