module("ikm.db", package.seeall)

log = logging.file("/var/log/interkomm/production.log", "%Y-%m-%d", os.date("%b %d %H:%M:%S").." %level %message\n" )

--- 
function escape_sqlite3(s)
  local s = string.gsub(s, "\'","\'\'")

return s
end

--- make a backup (dump) of a database
-- this is currently a bit dirty but does th trick
function backup_filesdb(project)
  local dump = [[/var/lib/interkomm/projects/]]..project..[[/db/backup_]]..os.time()..[[.sql]]
  local cmd = [[sqlite3 /var/lib/interkomm/projects/]]..project..[[/db/files.db .dump > ]]..dump
  os.execute(cmd)

return dump
end

---
function item_exists(project, uid)
  local hit = abstract_fetch([[/var/lib/interkomm/projects/]]..project..[[/db/files.db]],[[select rowid from items where uid=']]..uid..[[']])
  return ikm.core.toboolean(#hit)
end


---
-- @param project string
-- @param sql string
function fetch(project, sql)

local dbfile = CONFIG[IKM_ENV].project_dir..project.."/db/files.db"
local result = {}
  env = assert (luasql.sqlite3())
    con = assert (env:connect(dbfile, 4000))
      cur = assert (con:execute (sql))

         local data = cur:fetch({}, "a")

         while data do
           table.insert(result, data)
           data = cur:fetch({}, "a")
         end

      cur:close()
    con:close()
  env:close()

return result

end

--- wrapper for all read-only operations
-- @param project string
-- @param sql string
function abstract_fetch(dbfile, sql)
  local result = {}
  local env = assert (luasql.sqlite3())
  local con = assert (env:connect(dbfile, 4000))
  local cur = assert (con:execute(sql))
         local data = cur:fetch({}, "a")

         while data do
           table.insert(result, data)
           data = cur:fetch({}, "a")
         end

   cur:close()
   con:close()
   env:close()

return result
end


--- TODO: can go to ikm.project
function get_item_details(project, uid)
  local item
  local sql = [[select * from items where uid=']]..uid..[[';]]
  local dbfile = "/var/lib/interkomm/projects/"..project.."/db/files.db"
  local result = abstract_fetch(dbfile, sql)

    if result[1] then
     item  = result[1]
    end

return item
end


---
-- @param project
-- @param item
function transaction(dbfile, sql)
  local env = assert (luasql.sqlite3())
  local con = assert (env:connect(dbfile, 4000))
   
    con:setautocommit(false)
    con:execute(sql)
    local status = con:commit()
    if not status then
         con:rollback()
    end
 
  con:close()
  env:close()

return true
end -- 



---
-- @param project
-- @param item
function add_item(project, item, duration, uid)

local dbfile = CONFIG[IKM_ENV].project_dir..project.."/db/files.db"
local sql = [[INSERT into items (time, path, duration, uid, size) values ( ']]..os.time()..[[', ']]..item.path..[[', 
              ]]..duration..[[, ']]..uid..[[', ]]..item.size..[[); ]]
transaction(dbfile, sql)

return true

end -- 


------
--
--
function remove_item(project, item)

local dbfile = CONFIG[IKM_ENV].project_dir..project.."/db/files.db"
local sql = [[DELETE from items where path="]]..item.path..[["; ]]
transaction(dbfile, sql)

return true
end


--- collect pending tasks
-- TODO: move to jobs 
-- @param p priority/task level
function collect_jobs(p)
  local p = p or 1
  local dbfile = "/var/lib/interkomm/db/scheduler.db"
  local sql = [[select rowid, * from jobs where status=0 and priority=]]..p..[[ order by time asc limit 1]]
  local data = abstract_fetch(dbfile, sql)
  local job 
    if data then
     job = data[1]
   end
 
return job
end



--- get jobs filtered by status
-- @param status int
function show_jobs(status, limit )
  local status_limit
    if status then
       status_limit = "where status="..status
    else
       status_limit = ""
    end

  local limit = limit or 30

    local dbfile = "/var/lib/interkomm/db/scheduler.db"
    local sql = [[select rowid, * from jobs ]]..status_limit..[[ order by time desc limit ]]..limit..[[;]]
    local result = abstract_fetch(dbfile, sql)

return result
end



---
-- 
function list_files(project, pathfilter, filter)
  local sql
  if  pathfilter then
      sql = [[select rowid, * from items where path like "%]]..pathfilter..[[%" 
                              order by time desc;]]
  elseif filter then
      sql = [[select rowid, * from items where title like "%]]..filter..[[%" or 
                              description like "%]]..filter..[[%" or 
                              tags  like "%]]..filter..[[%" 
                              order by time desc;]]
  else
      sql = [[select rowid, * from items order by time desc;]]
  end

  local filter = filter or ""
  local dbfile = "/var/lib/interkomm/projects/"..project.."/db/files.db"
  local result = abstract_fetch(dbfile, sql)

return result
end


--- MOVE TO JOBS
function add_job(project, task, uid, p)
  local p = p or 1
  local dbfile = "/var/lib/interkomm/db/scheduler.db"
  local sql = [[INSERT into jobs (time, project, task, status, uid, priority) 
                values ( ']]..os.time()..[[', ']]..project..[[', 
                         ']]..task..[[', 0, ']]..uid..[[', ]]..p..[[); ]]
  transaction(dbfile, sql)

return true
end


--- MOVE TO JOBS
function set_jobstatus(id, status)
  local dbfile = "/var/lib/interkomm/db/scheduler.db"
  local sql = [[UPDATE jobs set status=]]..status..[[ where rowid=]]..id..[[; ]]
  transaction(dbfile, sql)

return true
end


--- MOVE TO JOBS
function clear_joblist(force)
local sql

if force then
 sql = [[DELETE from jobs;]]
else
 sql = [[DELETE from jobs where status > 0;]]
end

local dbfile = "/var/lib/interkomm/db/scheduler.db"
transaction(dbfile, sql)

return true
end


--- MOVE TO USER
function set_user_passwd(project, user, passwd)

local dbfile = "/var/lib/interkomm/db/userdb.db"
local sql = [[update user set password="]]..password..[[" where username="]]..user..[[";]]
transaction(dbfile, sql)

return true
end


---
function set_flag(project, uid , flag, value)
  local dbfile = "/var/lib/interkomm/projects/"..project.."/db/files.db"

  if flag == "claimed" then
     value= [[']]..value..[[']]
  end
  local sql = [[update items set ]]..flag..[[=]]..value..[[ where uid="]]..uid..[[";]]
  transaction(dbfile, sql)

return true
end
