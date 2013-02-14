--- job , scheduler related functions

module("ikm.job", package.seeall)

STATUS = { [0] = "pending" , [1] = "processing", [2] = "done" , [3] = "failed" , [4] = "cancelled" , }

--- 
function add(project, task, uid, p)
  local p = p or 1
  local dbfile = "/var/lib/interkomm/db/scheduler.db"
  local sql = [[INSERT into jobs (time, project, task, status, uid, priority)
                values ( ']]..os.time()..[[', ']]..project..[[',
                         ']]..task..[[', 0, ']]..uid..[[', ]]..p..[[); ]]
  ikm.db.transaction(dbfile, sql)

return true
end



--- 
function set(id, status)
  local dbfile = "/var/lib/interkomm/db/scheduler.db"
  local sql = [[UPDATE jobs set status=]]..status..[[ where rowid=]]..id..[[; ]]
  ikm.db.transaction(dbfile, sql)

return true
end


--- get jobs filtered by status
-- @param status int
-- @param limit int optional
function show(status, limit )
  local status_limit
    if status then
       status_limit = "where status="..status
    else
       status_limit = ""
    end

  local limit = limit or 30
    local dbfile = "/var/lib/interkomm/db/scheduler.db"
    local sql = [[select rowid, * from jobs ]]..status_limit..[[ order by time desc limit ]]..limit..[[;]]
    local result = ikm.db.abstract_fetch(dbfile, sql)

return result
end


--- 
function cleanall(force)
local sql

if force then
 sql = [[DELETE from jobs;]]
else
 sql = [[DELETE from jobs where status > 0;]]
end

local dbfile = "/var/lib/interkomm/db/scheduler.db"
ikm.db.transaction(dbfile, sql)

return true
end


