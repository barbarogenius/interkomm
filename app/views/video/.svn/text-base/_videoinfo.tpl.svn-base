<div class="videobox"> 

<link rel="stylesheet" type="text/css" media="all" href="/stylesheets/jsDatePick.css" />

<script type="text/javascript" src="/js/jsDatePick.js"></script>


<script type="text/javascript">
	window.onload = function(){
		new JsDatePick({
			useMode:2,
			target:"dateField",
			dateFormat:"%d-%M-%Y"
			});
	};


function editMetadata() {
  document.id('metadata_display').style.display = 'none' ;
  document.id('metadata_editor').style.display = 'block' ;
  document.id('metadata_write').style.display = 'none' ;
  document.id('meta_button').style.color = '#666';
  document.id('edit_meta_button').style.color = '#000';
  document.id('write_meta_button').style.color = '#666';
}

function cancelMetadata() {
  document.id('metadata_display').style.display = 'block';
  document.id('metadata_editor').style.display = 'none';
  document.id('metadata_write').style.display = 'none';
  document.id('meta_button').style.color = '#000';
  document.id('edit_meta_button').style.color = '#666';
  document.id('write_meta_button').style.color = '#666';
}

function writeMetadata() {
  document.id('metadata_display').style.display = 'none';
  document.id('metadata_editor').style.display = 'none';
  document.id('metadata_write').style.display = 'block';
  document.id('meta_button').style.color = '#666';
  document.id('edit_meta_button').style.color = '#666';
  document.id('write_meta_button').style.color = '#000';
}


function switchVideoinfoTab(tab) {

 switch(tab)
 {
  case "metadata":
    cancelMetadata();
    break;
  case "edit":
    editMetadata();
    break;
  case "write":
    writeMetadata();
    break;
 }

}

</script>

<span id="meta_button" onclick="javascript:switchVideoinfoTab('metadata');" style="padding-right: 20px; font-weight: bold; font-size: 1em; color: #000;">Metadata</span>
<span id="edit_meta_button" onclick="javascript:switchVideoinfoTab('edit');" style="padding-right: 20px; font-weight: bold; font-size: 1em; color: #666;">Edit</span>
<span id="write_meta_button" onclick="javascript:switchVideoinfoTab('write');" style="padding-right: 20px; font-weight: bold; font-size: 1em; color: #666;">Write</span>

<div id="toggleicon" onclick="javascript: toggle('metadata');" style="float:right;"><img src="/img/toggle.png"/></div>

<div id="metadata">



<div id="metadata_editor" style="display:none;">
  <form name="metadata" action="/api/dispatch.lua?api=metadata&project=$project&uid=$item|uid" method="post">
   <p>Title:<input type="text" name="title" title="this is a help tooltip" value="$item|title"  style="width: 260px;" onfocus="this.style.background = '#c1c3c8'" onBlur="this.style.background = '#fff'"></p>
   <p>Description:<br /> <textarea name="description" style="width: 300px; height: 100px;">$item|description</textarea></p>
   <p>Author: <input type="text" name="author" title="this is a help tooltip" value="$item|author"  style="width: 70px;">
   Date: <input type="text" style="width: 50px;" id="dateField" name="date" />(doesn't save yet)</p>
   <p>Tags: <input type="text" name="tags" title="tags seperated by whitespace" value="$item|tags" style="width: 260px;"></p>
   <p><input type="submit" value="save"> 
  </form>
</div>


    <div id="metadata_display"  style="padding-top: 20px; padding-bottom: 20px;">
      <b>Title</b>: $item|title 
      <br /><b>Description</b>: $item|description
      <br /><b>Tags</b>: $item|tags
      <br /><b>Author</b>: $item|author
      <br /><b>Date</b>: (not supported yet)
  </div>

    <div id="metadata_write" style="padding-top: 40px; padding-bottom: 40px; display:none;">
     This has not been implemented yet.
    </div>

</div>

<hr />

<b>Fileinfo</b> 
<div id="toggleicon" onclick="javascript: toggle('fileinfo');" style="float:right;"><img src="/img/toggle.png"/></div>
<div id="fileinfo">
 <p>
  Added: $item|time
 </p>

 <p>
  Duration: $item|duration sec
 </p>

 <p>
  Path: $item|path
 </p>

 <p>
  Size: $item|size
 </p>
</div>

<hr />

<b>Mediainfo</b> 
<div id="toggleicon" onclick="javascript: toggle('module_mediainfo');" style="float:right;"><img src="/img/toggle.png"/></div>

  <div id="module_mediainfo" style="padding: 10px; display: none">
  $mediainfo_html
  </div>


<hr />
<div id="toggleicon" onclick="javascript: toggle('module_chapters');" style="float:right;"><img src="/img/toggle.png"/></div>

<span id="meta_button" onclick="javascript:switchChaptersTab('chapters');" style="padding-right: 20px; font-weight: bold; font-size: 1em; color: #000;">Chapters</span>
<span id="edit_meta_button" onclick="javascript:switchChaptersTab('upload_chapters');" style="padding-right: 20px; font-weight: bold; font-size: 1em; color: #666;">Upload CMML</span>


  <div id="module_chapters" style="padding: 10px; display: none">
  $cmml_parsed
  </div>


</div> 
<!-- end: videobox -->

