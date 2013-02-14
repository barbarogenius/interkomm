<div class="modulebox">

<b>Audioexport</b> 
<div id="toggleicon" onclick="javascript: toggle('module_audioexport');" style="float:right;"><img src="/img/toggle.png"/></div>

  <div id="module_audioexport" style="padding: 10px; display: none">
  
  <form id="audioexport" action="/api2/dispatch.lua" method="post">
    <select name="format">
     <option name="native">native</option>
     <option name="flac">flac</option>
     <option name="vorbis">vorbis</option>
     <option name="pcms16le">pcms16le</option>
    </select>
    <input type="hidden" name="api" value="audioexport"/>
    <input type="hidden" name="project" value="$project"/>
    <input type="hidden" name="uid" value="$item|uid"/>
    <input type="button" onclick="javascript: sendAPIMessage('audioexport', 'module_audioexport');" value="export audio" />
  <form>

  <div class="module_help">
  native: same audio codec and container as in the original video is used, flac: lossless audio in flac container,
  vorbis: vorbis ausio in ogg container, pmc16le: pcm as used in dv, exported in wav container.
  
  </div>

  </div>

</div>

