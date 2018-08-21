


<cfoutput>
	
<cfinclude template="get_item.cfm">
<cfif attributes.imgnum GT ListLast(sqlAuction.imagesLayout, '_')>
	<cfset attributes.imgnum = 1>
</cfif>
<cfparam name="attributes.from" default="N/A">
<cfparam name="attributes.doNotResize" default="1">


<cfif FileExists('#ExpandPath("images")#\#attributes.item#\#attributes.imgnum#.jpg')>
  <!---<param name="load" value="#_layout.images_path##attributes.item#\#attributes.imgnum#.jpg">--->
  <cfset load = "#_layout.images_path##attributes.item#/#attributes.imgnum#.jpg" >	  	
<cfelse>
 <h3>Image not available</h3>
   	<cfset load = "#_layout.images_path##attributes.item#/#attributes.imgnum#.jpg" >
</cfif>	
	

	
	<canvas id="imaging" width="900" height="600" style="border:1px solid black;outline:none"></canvas>
	
	<form id="save_form" name="save_form" method="POST" 
	action="index.cfm?dsp=admin.auctions.save_image&item=#attributes.item#&imgnum=#attributes.imgnum#&from=#attributes.from#&doNotResize=#attributes.doNotResize#">
	    <input type="hidden" id="file_ext" name="file_ext" />
	    <input type="hidden" id="base64data" name="base64data" />
	    <input type="hidden" id="imageLoad" name="imageLoad" value="#load#" >
	</form>
	
	<a href="index.cfm?dsp=admin.auctions.step3&item=#attributes.item#">Back to Auction Management</a>
	|
	<a href="index.cfm?dsp=admin.auctions.upload_pictures&items=#attributes.item#">
		Back to Upload Images
	</a>
	
	<script type="text/javascript" >
			
		    var params = {
				resources : RESOURCES // resource text messages (defined in resources.js),
				,save : saveImage
				
		    };
	    	

			var imaging = new Imaging( document.getElementById('imaging'), params );	 
			var image_url = $('##imageLoad').val();  
			imaging.loadImage( image_url ? image_url : (image_url = 'images/imageNotFound.jpg' ) );
			imaging.loadImage(image_url);
	    	
	    	 //http://instantonlineconsignment.com/images/201.13227.167/1.jpg
	

imaging.setStyle({
    //color : colorNameToRGB('silver'),
    background : '##E0E0E0',
    handle_width : 16,
    handle_padding : 4,
    handle_color : 'rgba(0,0,0,0.1)',
    handle_color_over : 'rgba(0,0,0,0.35)',
    image_border : 1,
    image_border_color : '##888888',
    status : 'true'
});


			
			// Saves the processed image
			function saveImage() {
			    // if crop selector is drawn apply it
			    if (imaging.getSelector()) imaging.doAction('crop');
			
			    // You can check the output image size and if it is not satisfactory refuse saving
			    // var size = imaginggetImageSize();
			    // ...
			
			    // Get Image Data, extract image type (jpeg,png) and the data itself (base64 encoded),
			    // and submit them to save.php
			    var imageData = imaging.getImageData({ format: getMimeFromFileExt(image_url) });
			    
			    var matches = imageData.substring(0,imageData.indexOf('base64,')+7).match(/^data:.+\/(.+);base64,(.*)$/);
			    if (matches) {
				document.getElementById('file_ext').value = matches[1];
				document.getElementById('base64data').value = imageData.substring(imageData.indexOf('base64,')+7);
				document.getElementById('save_form').submit();
			    }
			    else window.alert('Wrong data format');
			}
					
	
			// A utility function to choose the appropriate mime type basing on the file extension
			function getMimeFromFileExt(filename) {
			    if (filename) {
				var re = /(?:\.([^.]+))?$/;
				var ext = re.exec(filename)[1];
				if (ext) {
				    switch(ext.toLowerCase()) {
					case 'jpeg': return 'image/jpeg';
					case 'jpg' : return 'image/jpeg';
				    }
				}
				return 'image/png'; // use png by default
			    }
			    return 'image/jpeg'; // if !filename assume jpeg
			}
			
			// A utility function to read URL parameters
			function urlParam(name){ // returns URL parameter
			    var results = new RegExp('[\?&]'+name+'=([^&##]*)').exec(window.location.href);
			    return results != null ? decodeURIComponent(results[1] || 0) : null;
			}
			
		</script>
</cfoutput>