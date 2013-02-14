function HTMLRequest() {
  var xmlhttp
    if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
          try {
                  xmlhttp = new XMLHttpRequest();
          } catch (e) {
                  xmlhttp=false;
          }
  }
  if (!xmlhttp && window.createRequest) {
          try {
                  xmlhttp = window.createRequest();
          } catch (e) {
                  xmlhttp=false;
         }
  }

  return xmlhttp;
}


function updateProjectActivity(id, req) {
 var xmlhttp =  HTMLRequest();
 xmlhttp.open("GET", req ,true);
 xmlhttp.onreadystatechange=function() {
  if (xmlhttp.readyState==4) {
   document.getElementById(id).innerHTML = xmlhttp.responseText;
  }
 }
 xmlhttp.send(null)
}


function toggle(elementID){
var target1 = document.getElementById(elementID)
  if (target1.style.display == 'none') {
      target1.style.display = 'block'
  } else {
      target1.style.display = 'none'
  }
}




/* this is using mootools */
function sendAPIMessage(formID, resultID) {

var req = new Request.HTML({
        url: '/api2/dispatch.lua',
        method: 'post',
        evalScripts: true, /* this is the default */
        onSuccess: function(responseTree, responseElements, responseHTML) {
                     var res = JSON.decode(responseHTML);
                     var my = document.id(resultID);
                     my.set('text', res.message) ;
                   },
        onFailure: function(responseTree, responseElements, responseHTML) {
                     var my = document.id(resultID);
                     my.innerHTML = 'something went wrong.' ;

                   }
}).post($(formID));

}

