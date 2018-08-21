<cfinclude template="layout/app_local.cfm">

<cfif ListLen(_machine.act, ".") EQ 1>
	<cfswitch expression="#_machine.act#">
		<cfcase value="step1,step2,step3" delimiters=",">
			<cfinclude template="act_#_machine.act#.cfm">
		</cfcase>
		<cfcase value="delete_image">
			<cfinclude template="act_delete_image.cfm">
		</cfcase>
		<cfcase value="upload_images">
			<cfinclude template="act_upload_images.cfm">
		</cfcase>
		<cfcase value="schedule">
			<cfinclude template="act_schedule.cfm">
		</cfcase>
		<cfcase value="cancel_schedule">
			<cfinclude template="act_cancel_schedule.cfm">
		</cfcase>
		<cfcase value="update_title">
			<cfinclude template="act_update_title.cfm">
		</cfcase>
		<cfcase value="delete">
			<cfinclude template="act_delete.cfm">
		</cfcase>
		<cfcase value="use_pictures">
			<cfinclude template="act_use_pictures.cfm">
		</cfcase>
		<cfcase value="duplicate">
			<cfinclude template="act_duplicate.cfm">
		</cfcase>
		<cfcase value="duplicate_lister_description">
			<cfinclude template="act_duplicate_lister_description.cfm">
		</cfcase>
		
		<cfcase value="end_item">
			<cfinclude template="act_end_item.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfthrow type="machine" message="Unknown action (#_machine.act#)">
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cfset _machine.module = ListFirst(_machine.act, ".")>
	<cfset _machine.act = ListRest(_machine.act, ".")>
	<cfinclude template="#_machine.module#\act_index.cfm">
</cfif>
