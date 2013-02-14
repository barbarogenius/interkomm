--- filesystem event daemon

module("ikm.event", package.seeall)

local log = logging.file("/var/log/interkomm/production.log", "%Y-%m-%d", os.date("%b %d %H:%M:%S").." %level %message\n" )


--- TODO: prepare the message as json
function prepare_msg(project, path, event)


--- we translate the messages into a simplyfied form
-- TODO: this can go into a table
if event == "CLOSE_WRITE,CLOSE" then
   event_translated = "CREATED"

elseif event == "MODIFY" then
   event_translated = "MODIFIED"

elseif event == "MOVED_TO" then
   event_translated = "CREATED"

elseif  event == "DELETE" or  event == "MOVED_FROM" then
   event_translated = "DELETED"

elseif event == "MOVED_TO,ISDIR" then
  event_translated = "DIR_MOVED"

else event_translated = "UNKNOWN"
end



  -- format for create or delete
  local msg_t = {
    message_type = "event",
    type = "event",
    project = project,
    event = event_translated, 
    path = path,
 }


local attr, size

-- adding size when we have a new file
if event_translated == "CREATED" then
  attr = lfs.attributes(path)
  msg_t.size = attr.size
end

  local msg = json.encode(msg_t)
return msg

end


--- send a formatted notification to the tcpd
-- this needs to get a proper protocol again
function send_msg(msg)
 local conn = socket.tcp()
 conn:connect("127.0.0.1", 9999)
 conn:send(msg.."\n")
 local response = conn:receive()
 conn:close()

 --log:info("sent event message, RECEIVED: "..response)
 log:info("sent "..msg.." RECEIVED: "..response)
end



--- the main daemon (loop)
function run()
   local startmessage = [[starting interkomm eventd 0.4 ]]
   log:info(startmessage)

   if CONFIG[IKM_ENV].eventd.run_repair_on_startup then
      log:info("running autorepair.")
   else
      log:info("no autorepair configured.")
   end



  local cache

    -- setting up the watch
    local watch = CONFIG[IKM_ENV].project_dir
    local cmd = [[inotifywait -q -m --format '%w%f|%e' --exclude '(db/|cuts/|ignore/)' -e close_write -e delete -e move -e modify -r ]]..watch

    for li in io.popen(cmd):lines() do
      path, event = string.match(li, "(.-)|(.*)")

        if event == "MOVED_FROM,ISDIR" then -- or event == "MOVED_FROM" then
           cache = path
        end

        if event == "MOVED_TO,ISDIR" then -- or event == "MOVED_TO" then
           if cache then 
              log:debug(cache.." has moved to "..path)
              local project = string.match(path, "/var/lib/interkomm/projects/(.-)/share/")
              local msg_t = {
                     message_type = "event",
                     type = "event",
                     event = "DIR_MOVED",
                     project = project,
                     moved_from = cache ,
                     moved_to = path ,
              }
              local msg = json.encode(msg_t)  
              log:debug(msg)
              send_msg(msg)
              cache = nil
           end
        end


      if ikm.media.considered(path) then
         project = string.match(path, "/var/lib/interkomm/projects/(.-)/share/")
           -- TODO check if project is active
           local msg = prepare_msg(project, path, event)
           send_msg(msg)
      end

    end

end




