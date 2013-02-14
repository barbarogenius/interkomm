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
  dis.api = req.GET.api 
  dis.uid = req.GET.uid
  dis.format = req.GET.format 
  dis.t_in = req.GET.t_in or 0 
  dis.t_out = req.GET.t_out or 0
  dis.project =  req.GET.project
  dis.referer = wsapi_env.HTTP_REFERER
  dis.fileupload = req.POST.fileupload
  dis.title = req.POST.title
  dis.description = req.POST.description
  dis.author = req.POST.author
  dis.tags = req.POST.tags
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

  controller = require "api_controller"

  local function out()

  local html = controller.run(dis)
        coroutine.yield(html)

  end
  
  local headers = { ["Content-type"] = "text/html" }

  return 200, headers, coroutine.wrap(out)

end

