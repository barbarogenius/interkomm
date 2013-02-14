--- function used by the tcpd daemon

module("ikm.tcpd", package.seeall)

log = logging.file("/var/log/interkomm/production.log", "%Y-%m-%d", os.date("%b %d %H:%M:%S").." %level %message\n" )


--- decode the received message
local function parse_msg(msg)
  local msg_t 
  local status, err = pcall(
                    function()
                    msg_t = json.decode(msg)
                    end
                    )
  if not status then
    return false
  end

return msg_t
end


-- encode a task for the job scheduler
local function encode_job(task)
  local task_json = json.encode(task)

return task_json
end


--- handler for requests/messages  
function handler(connection, host, port)
  local msg = connection:receive("*l")
  local status = 0
  local response

  if msg then
     local msg_t = parse_msg(msg)
     if not msg_t then
        msg_t = { message_type = "invalid" }         
     end

    local a = ikm.core.switch {

      ["event"] = function(x)   
          
           -- message_type: event | event : CREATED
           if msg_t.event == "CREATED" then
             log:info(host..":"..msg_t.project..":"..msg_t.path..":"..msg_t.event)
             local uid = ikm.media.generate_uid()
             -- TODO we should outsource that to the event daemon
             local duration = ikm.media.get_apx_duration(msg_t.path) or 0

             ikm.db.add_item(msg_t.project, msg_t, duration, uid)
             -- this is currently a dummy for the preview
             
                       local task = { type = "preview", path = msg_t.path }
                       local task_json = encode_job(task) 
                       ikm.db.add_job(msg_t.project, task_json , uid)

             log:debug("added preview job to queue uid:"..uid)
             
           end

           -- message_type: event | event : CREATED
           if msg_t.event == "DELETED" then
             ikm.db.remove_item(msg_t.project, msg_t)
           end

           if msg_t.event == "DIR_MOVED" then
             log:info("received moving message, moving "..msg_t.moved_from.." to "..msg_t.moved_to )
             ikm.project.rename_dir(msg_t.moved_from.."/", msg_t.moved_to.."/")
             log:info("done renaming")
           end


           response = "200"
      end,

      ["request"] =  function(x)

                -- do nothing for now
                response = "400"

                end,

      ["wantjob"] = function(x)
               
                -- do nothing for now
                response = "400"

                end,
    
      ["invalid"] =  function(x)

                -- do nothing for now
                response = "500"
                log:error("received invalid json")
                end,

      default = function(x)

                -- do nothing for now
                response = "500"
                log:error("returnd 500")
                end,

      }   


   a:case(msg_t.message_type)

   end -- end if msg

   --- we need to sort out proper responses ( response codes : 200 = OK, invalid, error, refused,)
   connection:send(response.."\n")

return true
end -- handler


--- we add a server thread
function run()
   copas.addserver(
     assert(
      socket.bind(CONFIG[IKM_ENV].tcpd.bind, CONFIG[IKM_ENV].tcpd.port)),
         function(connection)
             return handler(copas.wrap(connection), connection:getpeername()) 
         end
     )

   local startmessage = [[starting interkomm tcp 0.4 tcpd@]]..CONFIG[IKM_ENV].tcpd.bind..[[:]]..CONFIG[IKM_ENV].tcpd.port
   log:info(startmessage)
   copas.loop()

end 
