--- functions to perform regular tasks like recovering/updating the index
-- executing "external" tasks

module("ikm.task", package.seeall)

local log = logging.file("/var/log/interkomm/production.log", "%Y-%m-%d")


--- analyze and (possibly) repair a project repository by
-- comaparing database and fs 
function discover(project, run_mode)
  local run_mode = run_mode or "report"

  --- first round, check filesystem against database
  local function browse(path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then

            local f = path..'/'..file
            local attr = lfs.attributes (f)

            if attr.mode == "directory" then
                browse(f)
            else
                if ikm.media.considered(f) and not string.match(f, "/cuts/") then

                --print(f)
                local data = ikm.db.abstract_fetch("/var/lib/interkomm/projects/"..project.."/db/files.db", 
                                                    [[SELECT rowid from items where path="]]..f..[[";]])
                local status_info
                if data[1] then
                   status_info = "OK"
                else
                   if run_mode == "repair" then
                      -- TODO send message
                      status_info = [[sent notice about ]]..f..[[ to ikmd]]
                      local msg = ikm.event.prepare_msg(project, f, "CLOSE_WRITE,CLOSE")
                      ikm.event.send_msg(msg)
                   else
                      status_info = "File exists in filesystem, but not in the database."
                   end                   
                end
                   print(f, status_info)

                end
            end
        end
    end
  end

  -- second round, check database against filesystem
  local function check(project)
       local filelist = ikm.db.list_files(project)
       for _,item in ipairs(filelist) do
          local status_info
          local status, errstr, errno = posix.access(item.path, "r")
             if not errstr then
                status_info = "OK"
             else
                if run_mode == "repair" then
                   local msg = ikm.event.prepare_msg(project, item.path, "DELETE")
                   ikm.event.send_msg(msg)
                else
                status_info = "File is in the database, but not in filesystem."
                end
             end
            print(item.path, status_info)
       end
  end

local path = CONFIG[IKM_ENV].project_dir..project.."/share"
  io.write("Checking filesystem against database: \n")
  browse(path)
  io.write("Checking database against filesyetem: \n")
  check(project)

end



--- create the files database for a new project
-- @param project
function create_filesdb(project)
   local cmd = [[sqlite3 ]]..CONFIG[IKM_ENV].project_dir..project..[[/db/files.db "CREATE TABLE items ( time integer, path varchar);"]]
         os.execute(cmd)

return true
end

--- create scheduler.db
function create_schedulerdb()
  local cmd = [[sqlite3 /var/lib/interkomm/db/scheduler.db "CREATE TABLE jobs ( time integer, project varchar, task varchar, status integer , uid varchar, priority integer default 1);"]]
  os.execute(cmd)
  
return true
end


---
function create_userdb()
   local cmd = [[sqlite3 /var/lib/interkomm/db/user.db "CREATE TABLE user (password varchar(30), username varchar(30), realm varchar(30), projects varchar);"]]
   os.execute(cmd)

return true
end


--- create a project skeleton for a new project
function skeleton(project)

local skeldir = { 

CONFIG[IKM_ENV].project_dir..project, CONFIG[IKM_ENV].project_dir..project.."/share/", 
CONFIG[IKM_ENV].project_dir..project.."/db", CONFIG[IKM_ENV].project_dir..project.."/public/" }

for _, newdir in pairs(skeldir) do
   posix.mkdir(newdir)
end

create_filesdb(project)

return true

end


--- simple check if a project does exist
function project_exists(project)

        local check, err = pcall(function() 
                            lfs.dir(CONFIG[IKM_ENV].project_dir..project.."/") end 
                           )
        return check

end


--- run a project rule file on item
-- is to be replaced by the sandbox ( see below )
function run_rule(project, item)
   ikm.core.try (function()
                   local chunk, cError = loadfile(CONFIG[IKM_ENV].project_dir..project.."/rules/rules.lua")
                   chunk()
                   rules(item) 
                 end,
                 function()
                   log:error("can't find rules.lua for project "..project)
                 end 
                 )

end


--- get the first 256 Byte of a file and return crc32 hash
-- this is used by compare()
local function get_chunk(path)
  local chunk = io.open(path, "rb")
  local b = chunk:read(256)
  chunk:close()
return ikm.crc32.hash(b)
end


---
--
function sandbox(rulefile, path)

local env = { ikm = ikm , item = path, string = string }
local loadedFunction, cError = loadfile(rulefile)
setfenv(loadedFunction, env)

--loadedFunction()
ikm.core.try(loadedFunction,
             function()
                print("err")
             end)

end



--- compare two files
function compare(file1, file2)

local attr1 = lfs.attributes (file1)
local attr2 = lfs.attributes (file2)

 if attr1.size == attr2.size and attr1.modification == attr2.modification then

   if ikm.media.get_extension(file1) == ikm.media.get_extension(file2) and ikm.task.get_chunk(file1) == ikm.task.get_chunk(file2) then
      return true
   else
      return false
   end

 else

 return false

 end

end


--- this is just a mockup for now to test some stuff 
function rendertest(path, preset)

cmd = CONFIG[IKM_ENV].utils.."ikmencoder -i "..path.." -t "..preset.." &"
os.execute(cmd)

end

--- return the status of the three interkomm daemons
function status()
  local stat = {}
        stat.ikmeventd = ikm.core.trim(ikm.core.stdout("ps -A | grep ikmeventd"))
        stat.ikmd =  ikm.core.trim(ikm.core.stdout("ps -A | grep ikmd"))
        stat.ikmspd = ikm.core.trim(ikm.core.stdout("ps -A | grep ikm-worker"))

return stat

end


--- read the latest log entries
function readlog(lenght)
  local lines = {}
  local log_t = {}

for line in io.lines("/var/log/interkomm/production.log") do
      table.insert(lines, line)
end

for i=#lines, #lines-lenght, -1 do
    if lines[i] then
      table.insert(log_t, lines[i])
    end
end

return log_t

end


---
function dev_setup()
  local function get_password()
    os.execute("stty -echo")
    local secpass = io.stdin:read()
    os.execute("stty echo")

  return secpass
  end

io.write("interkomm development setup:\n")
io.write("please  choose a name for the project you want to set up >")
local projectname = io.stdin:read()

io.write("setting up project "..projectname.."...\n")
ikm.project.create(projectname)

io.write("please set a password for user 'admin'>")
local passwd = get_password()

ikm.user.create("admin", passwd)
ikm.project.adduser("admin", "admin")

io.write("dev setup finished.\n")

return true
end


---
--
function verify_mlt(project, filename)
  local file= io.open(filename, "r")
  local xml = file:read("*a")
   file:close()
  local resources = {}

  for resource in string.gmatch(xml, "<property name=\"resource\">(.-)</property>") do
      local uid = string.sub(ikm.media.get_filename(resource), 1, 12)
      print(uid, ikm.db.item_exists(project, uid))
  end

return true
end

