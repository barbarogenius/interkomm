<script>

function updateProgress() {

 var xmlhttp = HTMLRequest()
 xmlhttp.open("GET", "/api/progress?X-Progress-ID=$random_id", true);
 xmlhttp.onreadystatechange=function() {
  if (xmlhttp.readyState==4) {

   var json_data_object = eval("(" + xmlhttp.responseText + ")");
   document.getElementById('upp').innerHTML = Math.floor(json_data_object.received * 100 / json_data_object.size) + "% <img src='/img/bar.png' style='width:" + Math.floor(json_data_object.received * 100 / json_data_object.size) + "px; height: 10px;'>" ;
  }
 }
 xmlhttp.send(null)
}

</script>


<b>Add Video</b>
<div id="toggleicon" onclick="javascript: toggle('module_http_upload');" style="float:right;"><img src="/img/toggle.png"/></div>

 <div id="module_http_upload" style="padding: 10px; display: none">
 <form  name="test" action="/api/dispatch.lua?api=upload&project=$project&X-Progress-ID=$random_id" 
  enctype="multipart/form-data" method="post" onsubmit="setInterval('updateProgress()',1000);">

 <input type="file" name="fileupload" />
 <input id="X-Progress-ID" name="X-Progress-ID" type="hidden" value="$random_id" />
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" value="upload" ?>                      
 </form>
 <div id="upp" style="margin-top: 20px;">
   </div>
 </div>


