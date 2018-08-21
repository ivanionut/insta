<cfif NOT isAllowed("Items_UploadPictures")>
	<cflocation url="index.cfm?dsp=slim_login&next_dsp=#attributes.dsp#" addtoken="no">
</cfif>

<!---prepopulate the inputs with url item number --->
<cfif isdefined("url.items")>
	<cfset urlItem = url.items >
<cfelse>
	<cfset urlItem = "" >	
</cfif>


<cfparam name="attributes.items" default="">
<cfif attributes.items NEQ "">
	<cfquery name="sqlValidItems" datasource="#request.dsn#">
		SELECT item, title FROM items WHERE item IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.items#" list="yes">)
	</cfquery>
</cfif>

<cfparam name="attributes.simple" default="NO">
<cfparam name="attributes.doNotResize" default="0">
<cfoutput>
	
<!--- plupload files ------------------------ --->
<link rel="stylesheet" href="plupload/css/jquery-ui.min.css" type="text/css" />
<link rel="stylesheet" href="plupload/js/jquery.ui.plupload/css/jquery.ui.plupload.css" type="text/css" />
<!--- plupload files ------------------------ --->
	
<!--- THIS OVERIRDES THE DISPLAY TO HIDE ELEMENTS --->	
<style type="text/css">
	.plupload_header_content, .plupload_filelist_footer, 
	.plupload_filelist_header, .plupload_file_size, 
	.plupload_file_action, div.ui-resizable-handle, .plupload_file_status{
		display:none;
	}
	.plupload_dropbox .plupload_droptext{
		width:150px;
	}	
	.plupload_container{
		min-height: 100px;
		width: 150px;
		height: 100px;
	}
	.plupload_content{
		top: 0px;
		height: 100px;
		overflow-x: hidden;
	}
	div.plupload_file_name{
		margin-right: 0px !important;
	}
	.plupload_filelist_content li{
		
	}
	.plupload_wrapper {    
	    min-width: 0px;
	    width: 150px;
	    height:100px;
	}
	.ui-resizable-handle{
		display:none !important;
	}
	.uploader{
		display: inline-block;
		padding-left: 10px;
	}	
	
	.theContainer{
	    
	    display: inline-block;	    
	    margin-top: 5px;
	    text-align: center;
	    margin-left: 20px;
	    
	    /*
	    padding: 4px;
	    float: left;
	    
	    */
	}
	.itemName{
		font-weight:bold;
		font-size:12px;
		color:##333;
	}
	
</style>	


	
	
<table style="text-align: justify;">
<tr>
	<td align="left"><font size="4"><strong>Upload Images</strong></font></td>
	<td align="right"><a href="#_machine.self#&simple=#(NOT attributes.simple)#">Switch to <cfif attributes.simple>APPLET<cfelse>HTML</cfif> mode</a></td>
</tr>
<tr><td colspan="2">
	<hr size="1" style="color: Black;" noshade>
	<table width="100%"><tr><td align="left" width="50%"><strong>Administrator:</strong> #session.user.first# #session.user.last#</td><td align="right" width="50%">
		<b>Print Daily Report For: </b>
		<a href="index.cfm?dsp=admin.picturing_daily_report&repday=#DateFormat(DateAdd('d', -1, Now()))#" target="_blank">Yesterday</a>
		&nbsp;|&nbsp;
		<a href="index.cfm?dsp=admin.picturing_daily_report&repday=#DateFormat(Now())#" target="_blank">Today</a>
	</td></tr></table>
	<br><br>

	<cfif isDefined("attributes.noitem")>
		<h6 style="color:red;">Item "#attributes.noitem#" does not exist in database. Images were NOT uploaded.</h6>
	</cfif>
	<cfif (attributes.items NEQ "") AND (sqlValidItems.RecordCount  EQ 0)>
		<h6 style="color:red;">No one of {#attributes.items#} was found. Please enter at list one valid item.</h6>
	</cfif>
	<table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr><td>
		<table width="100%" border="0" cellpadding="4" cellspacing="1">
		<form action="index.cfm?dsp=admin.auctions.manage_images" method="post" style="margin:0px 0px 0px 0px;">
		<tr bgcolor="##F0F1F3">
			<td width="30%" align="right"><b>Item Number:</b></td>
			<td width="10%" align="center">
				
				<input type="text" name="itemid" size="20" value="#urlItem#"
				style="font-size:10px; font-family:Arial, Helvetica, sans-serif;">
				
			</td>
			<td width="1%">
				<input type="checkbox" name="doNotResize" value="1" id="dnr1" checked>
			</td>
			<td width="19%"><label for="dnr1">do NOT resize</label></td>
			<td width="40%" align="left">
				<input type="submit" name="submit" value="Manage Images">
			</td>
		</tr>
		</form>
		<tr><td colspan="5" bgcolor="##FFFFFF">&nbsp;</td></tr>
		<form action="index.cfm?dsp=admin.auctions.step3&from=upload_pictures" method="post" style="margin:0px 0px 0px 0px;">
		<tr bgcolor="##F0F1F3">
			<td align="right"><b>Item Number:</b></td>
			<td align="center">
				<input type="text" name="item" size="20" value="#urlItem#" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;"></td>
			<td><input type="checkbox" name="doNotResize" value="1" id="dnr2" checked></td>
			<td><label for="dnr2">do NOT resize</label></td>
			<td align="left"><input type="submit" name="submit" value="Edit Auction Pictures"></td>
		</tr>
		</form>
		<tr><td colspan="5" bgcolor="##FFFFFF">&nbsp;</td></tr>
		</table>
	</td></tr>
	<tr><td>
		<table width="100%" border="0" cellpadding="4" cellspacing="1">
		<cfif attributes.simple>
			<form action="index.cfm?act=admin.auctions.upload_images&maxImages=10&checkitem=1&maxWidth=640&maxHeight=480&back_dsp=#attributes.dsp#" method="post" enctype="multipart/form-data" style="margin:0px 0px 0px 0px;" target="_parent">
			<tr bgcolor="##F0F1F3">
				<td colspan="2" align="right"><b>Item Number:</b></td>
				<td colspan="2">
					<input type="text" name="item" size="20" 
				style="font-size:10px; font-family:Arial, Helvetica, sans-serif;"></td>
			</tr>
			<cfset imgList = "">
			<cfloop index="i" from="1" to="5">
			<tr bgcolor="##FFFFFF">
				<td width="70">Photo ###i#</td>
				<td width="180" align="right"><input type="file" accept="image/jpeg" name="img#i#" size="20" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;"></td>
				<td width="70">Photo ###(i+5)#</td>
				<td width="180"><input type="file" accept="image/jpeg" name="img#(i+5)#" size="20" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;"></td>
			</tr>
			</cfloop>
			<tr bgcolor="##F0F1F3">
				<td colspan="4" align="center"><input type="submit" name="submit" value="Upload Photos"></td>
			</tr>
			</form>
		<cfelse>
			<cfif NOT isDefined("sqlValidItems") OR (sqlValidItems.RecordCount  EQ 0)>
				<cfset variables.focusElement = "UNIQUE_NAME">
				<form action="#_machine.self#&simple=false" method="post" <!---onSubmit="return addITEM()"---> >
				<tr bgcolor="##F0F1F3"><td align="center"><b>Add sole item (<i>usally, scanned</i>) to items list:</b></td></tr>
				<tr bgcolor="##FFFFFF">
					<td align="center"><input type="text" id="items" name="items" value=""></td>
				</tr>
				</form>
				<form action="#_machine.self#&simple=false" method="post">
				<tr bgcolor="##F0F1F3"><td align="center"><b>OR, type in Item Numbers separated by comma (,)</b></td></tr>
				<tr bgcolor="##FFFFFF">
					<td><textarea name="items" cols="100" rows="13"></textarea></td>
				</tr>
				<tr bgcolor="##F0F1F3"><td align="center">
					<table>
					<tr>
						<td><input type="checkbox" name="doNotResize" value="1" id="dnr3" checked></td>
						<td><label for="dnr3">do NOT resize</label></td>
						<td align="center"><input type="submit" name="submit" value="Upload Photos To Items Above"></td>
					</tr>
					</table>
				</td></tr>
				</form>
			<cfelse>
				
				<cfset columnsCount = 5>
				
				<cfset loopCount = 1>
				
				<tr style="margin-bottom:5px;">					
				
					<td width="100" style="padding:4px 2px 4px 2px;">
						
						<cfloop query="sqlValidItems">
							<!---<div style="font-size:14px;background-color:##cacae7">#item#</div>--->
							<!--- we need a unique id here for plupload --->
							<div class="theContainer">
								<div id="up#loopCount#" class="uploader" data-itemid="#item#" >		
									<p>Loading</p>																	
								</div>
								<div class="itemName">#item#</div>
							</div>
								
							<cfset loopCount++>
						</cfloop>	
						</div>					
					</td>

				</tr>

			</cfif>
		</cfif>
		</table>
	</td></tr>
	</table>
</td></tr>
</table>
<br>

<!--- plupload --->
<script src="plupload/js/jquery/jquery.1.10.js"></script>
<script type="text/javascript" src="plupload/js/jquery/jquery-ui.min.js"></script>

<!-- production -->
<script type="text/javascript" src="plupload/js/plupload.full.min.js"></script>
<script type="text/javascript" src="plupload/js/jquery.ui.plupload/jquery.ui.plupload.min.js"></script>
<script type="text/javascript" src="plupload/js/enCustomized.js"></script>



<!--- translation and changing text --->
<script type="text/javascript">
	
// Initialize the widget when the DOM is ready
$(function() {
	
	
	var $uploader = $(".uploader").plupload({
		// General settings
		runtimes : 'html5,flash,silverlight,html4',
		url : 'http://#CGI.SERVER_NAME##CGI.PATH_INFO#?dsp=admin.auctions.save_pictures&doNotResize=#attributes.doNotResize#',

		// User can upload no more then 20 files in one go (sets multiple_queues to false)
		max_file_count: 20,
		max_file_size: '10mb',
		
		chunk_size: '3mb',

		// Resize images on clientside if we can
		resize : {width : 0, height : 0, quality : 100},	
		
		autostart: true,
		filters : {
			// Maximum file size
			max_file_size : '100mb',
			// Specify what files to browse for
			mime_types: [
				{title : "Image files", extensions : "jpg,jpeg"}
			]
		},
		multipart_params : {
			plupload:true
			//,item :  .data('itemid')
		},
		// Rename files by clicking on their titles
		rename: false,
		
		// Sort files
		sortable: false,

		// Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
		dragdrop: true,

		// Views to activate
		views: {
			list: true,
			thumbs: false, // Show thumbs
			active: 'list'
		},

		// Flash settings
		flash_swf_url : 'js/Moxie.swf',

		// Silverlight settings
		silverlight_xap_url : 'js/Moxie.xap',
		
		
		init : {
	        FilesAdded: function(uploader, file) {
	        	// WE WILL HAVE NAMING COUNT IN THE SERVER
	             //console.log(uploader)
	             //console.log(uploader.files.length)	             
	            //uploader.files.length;//this is the total images in the queue
	            //uploader.total; // same with uploader.files.length;
	            //uploader.settings.url = uploader.files.length;
	            //console.log(uploader.total.queued) 
 				
 				
 				/*
 				** - we need the itemid
 				**
 				*/ 
 				var uploaderId = uploader.settings.container.split('_');;
	         	var itemid = $('##' + uploaderId[0] ).data('itemid'); 
 				uploader.setOption('multipart_params', {
		            	plupload:true,
		            	itemid: itemid,
		            	item : itemid
	            })
	            //console.log(itemid,uploaderId)

	            	
	   	 	}
   	 	}
    
    
	});

//console.log( $uploader.data('itemid') )

});//doc ready
</script>


<cfif isDefined("variables.focusElement")>
	<script language="javascript" type="text/javascript">
	<!--//
		function addITEM(){
			document.getElementById("items").value += document.getElementById("#variables.focusElement#").value + ",";
			document.getElementById("#variables.focusElement#").value = "";
			document.getElementById("#variables.focusElement#").focus();
			return false;
		}
		document.getElementById("#variables.focusElement#").focus();
	//-->
	</script>
</cfif>


<!--- plupload ------------------ --->
<script src="plupload/js/jquery/jquery.1.10.js"></script>
<script type="text/javascript" src="plupload/js/jquery/jquery-ui.min.js"></script>

<!-- production -->
<script type="text/javascript" src="plupload/js/plupload.full.min.js"></script>
<script type="text/javascript" src="plupload/js/jquery.ui.plupload/jquery.ui.plupload.min.js"></script>
<script type="text/javascript" src="plupload/js/enCustomized.js"></script>
<!--- plupload ------------------ --->





</cfoutput>
