module(..., package.seeall)

package.path = package.path..";../app/controllers/?.lua"
--require 'ikm'
--require 'cosmo'

require 'lfs'
require 'yaml'
require 'cosmo'
require 'posix'
require 'logging.file'    
require 'json'
require 'luasql.sqlite3' 
require 'ikm.core'
require 'ikm.html'    --- TODO: merge that with ikm.ui in the future ( using memcache too for templates )
require 'ikm.project'
require 'ikm.user'
require 'ikm.spool'   --- TODO: move the translate function out of this
require 'ikm.lcoder'  --- TODO: remove the denpendency from that ( in video_controller )
require 'ikm.media'
require 'ikm.task'    --- TODO: this could be removed when moving task / lastlog to ui
require 'ikm.db'        
require 'ikm.cmml'
require 'ikm.authdigest'
require 'ikm.user'

require 'wsapi.request'
require 'wsapi.util'

function run(wsapi_env)

  local req = wsapi.request.new(wsapi_env)
  
  local dis = {}
  dis.user = { name = wsapi_env.REMOTE_USER }
  dis.project = req.GET.project 
  dis.action = req.GET.action 
  dis.video = req.GET.video 
  dis.pathfilter = req.POST.pathfilter
  dis.filter = req.POST.filter
  dis.referer = wsapi_env.HTTP_REFERER

  if dis.project then
     dis.project = ikm.html.sanitize(dis.project, "strict")
  end
  if dis.video then
     dis.video = ikm.html.sanitize(dis.video, "strict")
  end
  if dis.action then
     dis.action = ikm.html.sanitize(dis.action, "strict")
  end
  if dis.filter then 
     dis.filter = ikm.html.sanitize(dis.filter, "strict")
  end
  if dis.pathfilter then
     dis.pathfilter = ikm.html.sanitize(dis.pathfilter, "path")
  end


  controller = require (ikm.html.dispatch(dis))
  -- local project = string.match(p, "^/(%w+)/")

  local function out()
  local html
         status, err = pcall(function ()
                    html = controller.run(dis)
                    end )

                  if not status then
                    html = [[ <div><h3>drokk! something went utterly wrong.</h3></div>
                               <br />return to <a href="/">interkomm</a>
                               <hr /><div>debug output follows</div>
                              <pre>]]..err..[[</pre>
                               ]]
                  end

        coroutine.yield(html)

  end
  
  local headers = { ["Content-type"] = "text/html" }

  return 200, headers, coroutine.wrap(out)

end

