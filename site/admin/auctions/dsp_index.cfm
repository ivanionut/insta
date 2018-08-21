<cfinclude template="layout/app_local.cfm">

<cfif ListLen(_machine.dsp, ".") EQ 1>
	<cfswitch expression="#_machine.dsp#">
		<cfcase value="st_scheduler">
			<cfset _machine.layout = "none">
			<cfinclude template="st_scheduler.cfm">
		</cfcase>
		<cfcase value="step1">
			<cfinclude template="dsp_step1.cfm">
		</cfcase>
		<cfcase value="step2">
			<cfinclude template="dsp_step2.cfm">
		</cfcase>
		<cfcase value="item_specific">
			<cfinclude template="dsp_item_specific.cfm">
		</cfcase>
		<cfcase value="item_specific_popup">
			<cfset _machine.layout = "packing">
			<cfinclude template="dsp_item_specific.cfm">
		</cfcase>
		<!---<cfcase value="step3">
			<cfset _machine.layout = "no">
			<cfinclude template="dsp_step3_frameset.cfm">
		</cfcase>--->
		<cfcase value="step3">
			<!---<cfif NOT isDefined("attributes.use_pictures")>
				<cfset _machine.layout = "packing">
			</cfif>--->
			<cfinclude template="dsp_step3.cfm">
		</cfcase>		
		<cfcase value="step3_left,new_image" delimiters=",">
			<cfset _machine.layout = "packing">
			<cfinclude template="dsp_applet.cfm">
		</cfcase>

		<cfcase value="edit_image" delimiters=",">
			<cfset _machine.layout = "imageEditor">
			<cfinclude template="dsp_edit_image.cfm">
		</cfcase>
		
		<cfcase value="upload_pictures">
			<cfinclude template="dsp_upload_pictures.cfm">
		</cfcase>
		<cfcase value="manage_images">
			<cfinclude template="dsp_manage_images.cfm">
		</cfcase>
		<cfcase value="save_pictures">
			<cfset _machine.layout = "no">
			<cfinclude template="dsp_save_pictures.cfm">
		</cfcase>
		<cfcase value="preview">
			<cfset _machine.layout = "no">
			<cfinclude template="dsp_preview.cfm">
		</cfcase>
		<cfcase value="list2sandbox">
			<cfinclude template="dsp_list2sandbox.cfm">
		</cfcase>
		<cfcase value="launch">
			<cfset attributes.sandbox = false>
			<cfinclude template="dsp_list2sandbox.cfm">
		</cfcase>
		<cfcase value="relist_item">
			<cfinclude template="dsp_relist_item.cfm">
		</cfcase>
		<cfcase value="relistItems">
			<cfinclude template="dsp_relistItems.cfm">
		</cfcase>		
		<cfcase value="end_item">
			<cfinclude template="dsp_end_item.cfm">
		</cfcase>
		
		<!--- 20160206 added --->
		<cfcase value="upload_pictures2">
			<cfinclude template="dsp_upload_pictures2.cfm">
		</cfcase>

		<cfcase value="save_image">
			<cfinclude template="dsp_save_image.cfm">
		</cfcase>		
		
		<cfdefaultcase>
			<cfthrow type="machine" message="Unknown display (#_machine.dsp#)">
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cfset _machine.module = ListFirst(_machine.dsp, ".")>
	<cfset _machine.dsp = ListRest(_machine.dsp, ".")>
	<cfinclude template="#_machine.module#\dsp_index.cfm">
</cfif>
