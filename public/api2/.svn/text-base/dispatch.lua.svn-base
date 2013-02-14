module(..., package.seeall)

package.path = package.path..";../../app/controllers/?.lua"
require 'ikm'
require 'cosmo'
require 'wsapi.request'
require 'wsapi.util'

function run(wsapi_env)

  local req = wsapi.request.new(wsapi_env)
  local dis = {}  
  dis.user = { name = wsapi_env.REMOTE_USER }
  dis.api = req.POST.api
  dis.format = req.POST.format or "nothing"
  dis.t_in = req.POST.t_in
  dis.t_out = req.POST.t_out
  dis.api = req.POST.api
  dis.uid = req.POST.uid
  dis.project =  req.POST.project
  dis.referer = wsapi_env.HTTP_REFERER
  dis.fileupload = req.POST.fileupload
  dis.title = req.POST.title
  dis.description = req.POST.description
  dis.author = req.POST.author
  dis.tags = req.POST.tags
  dis.cmml_plain = req.POST.cmml_plain
  req = nil


  if dis.api then
     dis.api = ikm.html.sanitize(dis.api, "strict")
  end
  if dis.uid then
     dis.uid = ikm.html.sanitize(dis.uid, "strict")
  end
  if dis.t_in then
     dis.t_in = tonumber(dis.t_in)
  end
  if dis.t_out then
     dis.t_out = tonumber(dis.t_out)
  end
  if dis.project then
     dis.project =  ikm.html.sanitize(dis.project, "strict")
  end
  if dis.format then
     dis.format = ikm.html.sanitize(dis.format, "strict")
  end

  --log:debug(req.POST.t_in)
  --log:debug(req.POST.t_out)
  controller = require "api2_controller"

  local function out()
     local exec = controller.run(dis)
     local response = [[{"message":"task has been added to the job queue.","code":200}]]
        coroutine.yield(response)
     end
  
  local headers = { ["Content-type"] = "text/json" }

  return 200, headers, coroutine.wrap(out)

end

