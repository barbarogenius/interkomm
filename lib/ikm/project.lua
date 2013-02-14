--- project management related tasks 

module("ikm.project", package.seeall)

log = logging.file("/var/log/interkomm/production.log", "%Y-%m-%d", os.date("%b %d %H:%M:%S").." %level %message\n" )

--- simple check if a project does exist
function project_exists(project)
   local check, err = pcall(function()
                            lfs.dir(CONFIG[IKM_ENV].project_dir..project.."/") 
                            end
                           )
return check
end



--- create the files database for a new project, should use ikm.db rather
function create_filesdb(project)
     local cmd = [[sqlite3 /var/lib/interkomm/projects/]]..project..[[/db/files.db "CREATE TABLE items ( time integer, path varchar, 
                   size integer default 0, duration integer default 0 , hash integer default 0, uid varchar default '0', 
                   title varchar default 'no title', tags varchar default ' ', description text default 'no description',
                   cmml text default '', locked integer default 0, export integer default 0, claimed varchar default '', 
                   author varchar default '', comment text default '', date integer default 0 );" ]]

     local cmd = ikm.core.prepare(cmd)
     os.execute(cmd)

return true
end


function create_settingsdb(project)

     local cmd = [[sqlite3 /var/lib/interkomm/projects/]]..project..[[/db/settings.db "CREATE TABLE settings ( option varchar, value varchar default '');"]] 
     local cmd = ikm.core.prepare(cmd)
     os.execute(cmd)

return true

end

--- create a project skeleton for a new project
function skeleton(project)
  local basedir = CONFIG[IKM_ENV].project_dir..project
  local skeldir = {
      basedir, basedir.."/db/", basedir.."/share/",  
      basedir.."/share/work/", basedir.."/share/production/", 
      basedir.."/share/cuts/", basedir.."/share/ignore/", basedir.."/share/xml/" }

  for _, newdir in pairs(skeldir) do
     -- DEBUG ONLY print(newdir)
     posix.mkdir(newdir)
  end

return true
end


--- create a new project
function create(project)
  skeleton(project)
  create_filesdb(project)
  create_settingsdb(project)
  -- this again is a bit dirty ;)
    local basedir = CONFIG[IKM_ENV].project_dir..project
    os.execute([[echo "open" > ]]..basedir..[[/status]])
    os.execute("chown -R ikm.ikm "..basedir)
    os.execute("chmod -R go+w "..basedir.."/db/")
    os.execute("chmod -R 777 "..basedir.."/share/")

return true
end


--- get a project name from a path
function get_project_from_path(path)
  local project = string.match(path, "/var/lib/interkomm/projects/(.-)/share/")

return project
end

--- find projects and parse their status file
function find_projects(path)
local projects_t = {}

    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then

            local f = path..file
            local attr = lfs.attributes (f)
            if attr.mode == "directory" then
                local statusfile = io.open(f.."/status", "r")
                local status
                if statusfile then
                   status = ikm.core.trim(statusfile:read("*a"))
                   statusfile:close()
                else
                   status = "invalid"
                end       
                table.insert(projects_t , {  name = file, status = status } )
            end
        end
    end

return projects_t
end

--- parse a work/ folder recursively
function get_folders(project, type)
  local folders_t = {}
  local path = "/var/lib/interkomm/projects/"..project.."/share/"..type.."/"
    table.insert(folders_t, "/"..type.."/")
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then

            local f = path..file
            local attr = lfs.attributes (f)
            if attr.mode == "directory" then
                folder = "/"..type.."/"..string.gsub(f, path, "")
                table.insert(folders_t, folder)
            end
        end
    end

return folders_t
end

--- get project creation time
function created(project)
  local attr = lfs.attributes ("/var/lib/interkomm/projects/"..project.."/")
  local created_at = attr.change

return created_at
end


---
function statistics(project)
  local project_stat = {}
  project_stat.project_size = ikm.core.stdout("du -h /var/lib/interkomm/projects/"..project.."/share/")
 
return project_stat
end


--- check of which projects a user is a member
function membership(username)
  local memberships
  local sql = [[select projects from user where username="]]..username..[[";]]
  local data = ikm.db.abstract_fetch("/var/lib/interkomm/db/user.db", sql)

  if data[1] then
    if data[1].projects then
       memberships = ikm.core.split(data[1].projects, ":")
    end
  end

return memberships
end

--- check if a user is member of a project
function is_member(project, username)
  local memberships = membership(username)

  for _,m in pairs(memberships) do
      if m == project then
         return true
      end
  end

return false
end


--- add a user from a project
function adduser(project, username)
  local memberships = {}
 
  memberships = ikm.project.membership("startx")
    if not memberships then
       memberships = {}
    end
      table.insert(memberships, project)
      local memberships_new = ikm.core.table_unique(memberships)
      local ms = table.concat(memberships_new, ':')

  local sql = [[update user set projects="]]..ms..[[" where username="]]..username..[[";]]
  local dbfile = [[/var/lib/interkomm/db/user.db]]
    ikm.db.transaction(dbfile, sql)

return true
end


--- remove a user from a project
function deluser(project, username)
  local memberships = ikm.project.membership("startx")
     for i,p in ipairs(memberships) do
      if p == project then
         memberships[i] = nil
      end
     end

      local memberships_new = ikm.core.table_unique(memberships)
      local ms = table.concat(memberships_new, ':')
      local sql = [[update user set projects="]]..ms..[[" where username="]]..username..[[";]]
      local dbfile = [[/var/lib/interkomm/db/user.db]]
        ikm.db.transaction(dbfile, sql)

return true
end


--- list members of a project
function list_members(project)
  local members_of = {}
  local dbfile = [[/var/lib/interkomm/db/user.db]]
  local sql = [[select username from user;]]
  local data = ikm.db.abstract_fetch(dbfile, sql)

  for _, set in ipairs(data) do
     if ikm.project.is_member(project, set.username) then
        table.insert(members_of, set.username)
     end
  end

return members_of
end

---
function videostats(project)
  local dbfile = [[/var/lib/interkomm/projects/]]..project..[[/db/files.db]]
  local sql = [[select size from items;]]
     local data = ikm.db.abstract_fetch(dbfile, sql)
     local count, size_all
     if data then
       count = table.getn(data)
       size_all = 0
         for i, v in ipairs(data) do
          size_all = size_all + v.size
        end      
     end
   local stats = { count = count, size_all = size_all }

return stats
end


function rename_dir(oldpath, newpath)

  local project = ikm.media.get_project_from_path(oldpath)
  local dbfile = "/var/lib/interkomm/projects/"..project.."/db/files.db"
  local sql = [[select rowid, path from items where path like '%]]..oldpath..[[%';]]
  local data = ikm.db.abstract_fetch(dbfile,sql)

  -- ikm.debug.showtable(data)

  local new_data = {}
  for i, set in ipairs(data) do
    local new_path = string.gsub(set.path, oldpath, newpath)
    local new_sql = [[update items set path=']]..new_path..[[' where rowid=]]..set.rowid..[[;]]
    log:info("PROJECT: "..new_sql)
    ikm.db.transaction(dbfile, new_sql)
  end

return true
end


--- will replace the old function later
function new_get_folders(project, ftype)

local folders_t = {}
local base_path = "/var/lib/interkomm/projects/"..project.."/share/"..ftype.."/"

function attrdir (path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path.."/"..file
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
            if attr.mode == "directory" then
                local path_relative = "/"..ftype..string.gsub(f, base_path, "") 
                table.insert(folders_t, path_relative ) --print(f)
                attrdir (f)
            else
               --
            end
        end
    end
end

  attrdir(base_path)
  table.insert(folders_t, "/"..ftype.."/" )
return folders_t
end




--- get a list of all tags in a project
function tags(project)
  local dbfile = [[/var/lib/interkomm/projects/]]..project..[[/db/files.db]]
  local sql = [[select tags from items]]
  local data = ikm.db.abstract_fetch(dbfile, sql)
  local tags_t = {}

    for _, set in ipairs(data) do

      local taglist = ikm.core.split(ikm.core.trim(set.tags), " ") 
        if taglist then
         for _, tag in ipairs(taglist) do
           table.insert(tags_t, tag)
         end
        end 
    end

  local tags_u = ikm.core.table_unique(tags_t)

return tags_u
end

---
function project_details(project)

local dbfile = [[/var/lib/interkomm/projects/]]..project..[[/db/settings.db]]
local sql = [[select * from settings]]
local data = ikm.db.abstract_fetch(dbfile, sql)

local details = {}

for i,v in ipairs(data) do
  details[data[i].option] = data[i].v
end

return details

end

----
function list_xml(project)
  local path  = [[/var/lib/interkomm/projects/]]..project..[[/share/xml/]]
  local xml_t = {}

  if posix.access(path, "r") then
  for file in lfs.dir(path) do
     if string.match(file, ".xml") or string.match(file, ".mlt") then
       table.insert(xml_t, file)
     end
  end
  end

return xml_t
end
