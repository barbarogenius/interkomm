<link rel="stylesheet" href="/stylesheets/slider.css" />
<style>
.clearfix {
        clear:both;
        display:block;
}
</style>


<script type="text/javascript" src="/js/slider.js"></script>
<script type="text/javascript">
window.addEvent('load', function() {
        var t_in = document.id('t_in');
        var t_out = document.id('t_out');
        var mySlideA = new Slider(document.id('slider_minmax_gutter_m'), document.id('slider_minmax_minKnobA'),document.id('slider_bkg_img'), {
                start: 0 ,
                end: $item|sec ,
                offset:0,
                snap:false,
                onChange: function(pos){
                          t_in.innerHTML = pos.minpos ;
                          document.id('cutform').elements["t_in"].value = pos.minpos;
                          document.id('slider_minmax_minKnobA').innerHTML = pos.minpos;
                          t_out.innerHTML = pos.maxpos ;
                          document.id('cutform').elements["t_out"].value = pos.maxpos;
                          document.id('slider_minmax_maxKnobA').innerHTML = pos.maxpos;
                          }
        }, document.id('slider_minmax_maxKnobA')).setMin(0).setMax($item|sec);
        document.id('slider_current_val_2').setHTML(30 + ' inches');

});
</script>

<div class="modulebox">
<b>Cutter</b>
<div id="toggleicon" onclick="javascript: toggle('module_cut');" style="float:right;"><img src="/img/toggle.png"/></div>

<div id="module_cut">

    <div class="slider_outer" style="border: 0px; width: 360px;" >
        <div class="slide_container" >
                  <div id="slider_minmax_min"> </div>
              <div class="slider_gutter" id="minmax_slider" >
                  <div id="slider_minmax_gutter_l" class="slider_gutter_item iconsprite_controls"></div>
                      <div id="slider_minmax_gutter_m" class="slider_gutter_item gutter iconsprite_controls">
                        <div id="slider_minmax_minKnobA" class="knob"></div>
                        <div id="slider_minmax_maxKnobA" class="knob"></div>
                      </div>
                      <div id="slider_minmax_gutter_r" class="slider_gutter_item iconsprite_controls"> </div>
                 </div>
              <div id="slider_minmax_max"> </div>
              <div class="clearfix"></div>

       <div style="float: right";>
       <form id="cutform" action="/api2/dispatch.lua" method="post">
       <input type="hidden" name="t_in"/>
       <input type="hidden" name="t_out"/>
       <input type="hidden" name="uid" value="$item|uid">
       <input type="hidden" name="project" value="$project">
       <input type="hidden" name="api" value="cut">
       <span id="t_in" style="display:none;"></span> <span id="t_out" style="display:none;"></span>
       <input type="button" onclick="javascript: sendAPIMessage('cutform', 'cut_result')" value="add to job queue">
      </form>
       </div>

    </div>
      
   </div> <!-- end: slider outer -->

          <div id='cut_result' style="margin: 10px;" >
          </div>

</div>
</div> <!-- end: modulebox -->

