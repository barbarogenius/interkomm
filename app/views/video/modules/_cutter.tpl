<div class="modulebox">

<b>MODULE cutter</b> 
<div id="toggleicon" onclick="javascript: toggle('module_cut');" style="float:right;"><img src="/img/toggle.png"/></div>

  <div id="module_cut" style="padding: 10px; display: none">
    <form id="cutter" action="/api2/dispatch.lua" method="post">
      in <input type="text" size="4" name="t_in"/>
      out <input type="text" size="4" name="t_out"/>
      <input type="hidden" name="uid" value="$item|uid">
      <input type="hidden" name="project" value="$project">
      <input type="hidden" name="api" value="cut">
      <input type="button" onclick="javascript: sendAPIMessage('cutter', 'module_cut')" value="save">
    </form>
  </div>
  <div id='cut_result'>
  </div>

</div>

