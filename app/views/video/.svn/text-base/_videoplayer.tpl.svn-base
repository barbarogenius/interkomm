<!--begin: /video/_videoplayer.tpl -->
 <script type="text/javascript">

    VideoJS.setupAllWhenReady({
      controlsBelow: true, // Display control bar below video instead of in front of
      controlsHiding: false, // Hide controls when mouse is not over the video
      defaultVolume: 0.85, // Will be overridden by user's last volume if available
      flashVersion: 9, // Required flash version for fallback
      linksHiding: true // Hide download links when video is supported
    });

  function showPlayer() {
  document.id('videoplayer').style.display = 'block';
  document.id('downloads').style.display = 'none';
  document.id('player_tab').style.color = '#fff';
  document.id('downloads_tab').style.color = '#bbb';
  }

  function showDownloads() {
  document.id('videoplayer').style.display = 'none';
  document.id('downloads').style.display = 'block';
  document.id('player_tab').style.color = '#bbb';
  document.id('downloads_tab').style.color = '#fff';
  }


  </script>

<div class="videoplayer"> 
<span id="player_tab" onclick="javascript:showPlayer();" style="padding-right: 20px; font-weight: bold; font-size: 0.8em; color: #fff;">Preview</span>
<span id="downloads_tab" onclick="javascript:showDownloads();" style="padding-right: 20px; font-weight: bold; font-size: 0.8em; color: #bbb;">Downloads</span>

  <div  id="videoplayer" style="background-color:black; width:500px">
    <div align="center"> 
       <div class="video-js-box">
      <video id="example_video_1" class="video-js"  height="240px" width="500px" poster="$poster.png" controls="controls">
        <source src="$video" type='video/webm'></source>
        <!-- <track kind="subtitles" src="/img/test.srt" />-->
      </video>
      </div>
    </div>
  </div>

   <div  id="downloads" style="padding: 10px; background-color:black; width:500px; height: 260px; display: none;">
     <a href="$video">Download preview</a>
   </div>

</div>

<!--end: /video/_videoplayer.tpl -->



