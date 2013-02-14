<div class="header">
<a href="/">interkomm</a> / <b>$project</b>
</div>

<div class="topbar">
Logged in as $dis|user|name | <a href="#" onclick="javascript:toggle('notify')">notifications</a>

<div id="notify" class="notify" style="display:none">
<b>Latest notifications for $project</b>
<hr />
<b>joblist:</b>
<br />
$notification_jobs_html
<hr />
<b>notes</b>
</div>

</div>

<div class="container">

<script type="text/javascript">
function showFiles_listed() {
  var list = document.getElementById('files_listed');
  var pad = document.getElementById('scratchpad');
  var psettings = document.getElementById('project_settings');
  var files_button = document.getElementById('files_button');
  var pad_button = document.getElementById('pad_button');
  var project_button = document.getElementById('project_button');
  list.style.display = 'block';
  pad.style.display = 'none';
  psettings.style.display = 'none';
  project_button.style.color = '#222';
  files_button.style.color = '#fff';
  pad_button.style.color = '#222';
  document.id('project_xml_display').style.display = 'none';
  document.id('project_xml').style.color = '#222';
  
}

function showScratchpad() {
  var list = document.getElementById('files_listed');
  var pad = document.getElementById('scratchpad');
  var psettings = document.getElementById('project_settings');
  var files_button = document.getElementById('files_button');
  var pad_button = document.getElementById('pad_button');
  var project_button = document.getElementById('project_button');
  list.style.display = 'none';
  pad.style.display = 'block';
  psettings.style.display = 'none';
  project_button.style.color = '#222';
  files_button.style.color = '#222';
  pad_button.style.color = '#fff';
  document.id('project_xml_display').style.display = 'none';
  document.id('project_xml').style.color = '#222';

}

function showProjectSettings() {
  var list = document.getElementById('files_listed');
  var pad = document.getElementById('scratchpad');
  var psettings = document.getElementById('project_settings');
  var files_button = document.getElementById('files_button');
  var pad_button = document.getElementById('pad_button');
  var project_button = document.getElementById('project_button');
  list.style.display = 'none';
  pad.style.display = 'none';
  psettings.style.display = 'block';
  project_button.style.color = '#fff';
  files_button.style.color = '#222';
  pad_button.style.color = '#222';
  document.id('project_xml_display').style.display = 'none';
  document.id('project_xml').style.color = '#222';

}

function showProjectXML() {
  document.id('files_listed').style.display = 'none';
  document.id('scratchpad').style.display = 'none';
  document.id('project_settings').style.display = 'none';
  document.id('project_xml_display').style.display = 'block';
  document.id('files_button').style.color = '#222';
  document.id('pad_button').style.color = '#222';
  document.id('project_button').style.color = '#222';
  document.id('project_xml').style.color = '#fff';
}



</script>

  <div style="margin-left: 10px; width: 400px; padding-left: 10px; padding-right: 10px; background: url('/img/bg2.png');">
  <span id="files_button" onclick="javascript:showFiles_listed();" style="padding-right: 20px; font-weight: bold; font-size: 0.8em; color: #fff;">Videos</span>    
  <span id="pad_button" onclick="javascript:showScratchpad();" style="padding-right: 20px; font-weight: bold; font-size: 0.8em; color: #222;">Scratchpad</span>
  <span id="project_button" onclick="javascript:showProjectSettings();" style="padding-right: 20px; font-weight: bold; font-size: 0.8em; color: #222;">Settings</span>
  <span id="project_xml" onclick="javascript:showProjectXML();" style="font-weight: bold; font-size: 0.8em; color: #222;">XML Projects</span>
  </div>


  <div id="scratchpad" class="itembox" style="display:none; font-size: 0.8em;">
    <form name="pad">
      this is the personal scratchpad ( not implemented yet )
<textarea class="scratchpad">
</textarea>

<input type="button" value="save"/> 
( does not save anything right now !)
</form>
  </div>

  <div id="project_settings" class="itembox"  style="display:none; font-size: 0.8em; ">
  project settings ( not implemented yet )
   <form>
   <p>
    Project Description: 
    <br /><textarea></textarea>
    </p>

   <input type="button" value="save settings">
   </form>

  </div>


  <div id="project_xml_display" class="itembox"  style="display:none; font-size: 0.8em; ">
    <p>$xml_files_html</p>
  </div>




  <div id="files_listed" class="itembox">
    $files
  </div>


  <div class="projectdisplay">
  <b>$display_html</b>
  <div style="float:right;">
  <input type="image" src="/img/refresh.png" onclick="window.location.reload();" />
  </div>
  </div>

  <div class="projectfilter">


      <div style="padding: 5px;">
      <b>filter by folder</b>
      <form name="pathfilter" action="/project/$project/" method="post">
       <select name="pathfilter">
          <option value="">Latest</option>
          $folders_html
       </select>
       <input type="submit" value="filter" />
      </form>
      </div>

      <div style="padding: 5px;">
      <b>search this project</b>
       <form name="filter" action="/project/$project/" method="post">
       <input type="text" name="filter"/>
       <input type="submit" value="search" />
      </form>
      </div>
 
      <div style="padding: 5px;">
      <b>tags in this project</b> : $tag_html
      </div>

      <div style="margin-top: 100px">
       <hr />
       <b>About  this project:</b>
      <div id="toggleicon" onclick="javascript: toggle('aboutproject');" style="float:right;"><img src="/img/toggle.png"/></div>
       <div id="aboutproject" style="display: none;">
        <br /><b>Members</b>: $memberslist_html
        <br /><b>Statistics</b>: $stats_html
      </div>
     </div>  

  <hr />
    $mod_upload_html

  <hr/>
    $mod_xml_upload_html

  </div>



</div>
