--- media detection and and analysis functions
--

module("ikm.media", package.seeall)

--- checks if ffmpeg recognizes the file as a video
function is_video(path)
  local c = ikm.core.stdout("ffmpeg -i "..ikm.core.escape_path(filename).." 2>&1 | grep Invalid")
    if string.len(c) > 10 then
      return false
    end

return true
end


--- extract the file extension from a path
function get_extension(path)
  local extension = string.match(path, ".(%w+)$")
  return extension 
end


--- returns size of a file in bytes
function get_filesize(path)
  s = lfs.attributes (path , size)
  return s.size
end


--- get the approximate duration of the video as ffmpeg sees it in seconds
function get_apx_duration(path)
  local c = ikm.core.stdout("ffmpeg -i "..ikm.core.escape_path(path).." 2>&1 | grep Duration")
  local h,m,s,n = string.match(c, "Duration:%s(%d+)%:(%d+)%:(%d+)%.(%d+),")
  local duration = (tonumber(h) * 3600) + (tonumber(m) * 60) + tonumber(s) + tonumber(n/100)

return duration
end

--- pre-checks if the file extension indicates a video file
function considered(path)
  local extension = get_extension(path)
  -- TODO: we move this to config later
  local ext_t = { "mov" , "avi", "mkv", "webm", "ogg", "ogv", 
  "wmv" , "dv", "mp4", "flv", "mpg", "mpeg" }

  for _, ext in pairs(ext_t) do
    if string.lower(extension) == ext then
       return true
    end 
  end
    
return false
end

--- returns the mimetype of the file 
function get_mimetype(path)
  local cmd = "file --mime "..ikm.core.escape_path(path).." | awk \'{ print $2 }\' "
  local mimetype = ikm.core.stdout(cmd)

return mimetype
end


--- extracts the filename from the path
function get_filename(path)
  local parts =  ikm.core.split(path, "/")
  local filename = parts[table.getn(parts)]

return filename
end

--- get the path to the directory a file is in
function get_directory(path)

local dir = string.gsub(s, get_filename(path), "")

return dir
end

-- check if the video is in a production folder
function in_production(path)

if string.match(path, "/share/production") then
   return true
end

return false
end


-- check if the video is in a production folder
function get_directory(path)
local dir = string.gsub(path, get_filename(path), "")

return dir
end


--- generates a unique identifier
function generate_uid()
  local set, char, uid
  local set = [[1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]]
  local uid=""

  math.randomseed(urandom())
  for c=1,12 do
     i = math.random(1,string.len(set))
     uid = uid..string.sub(set,i,i)
  end

return uid
end

--- collects 24 byte of urandom data, used by generate_uid
function urandom()
  local devr = io.open("/dev/urandom", "r")
  local r = devr:read(24)
  devr:close()

local seed = socket.gettime()
for i = 1, #r do
  seed = seed + string.byte(string.sub(r,i,i))
end

return seed
end


--- get the project from a path to a file
function get_project_from_path(path)
local project = string.match(path, "/var/lib/interkomm/projects/(%w+)/share/")

return project
end

--- update metadata in the db, currently a stub
function update_db_metadata(project, uid, metadata_json)

local metadata = json.decode(metadata_json)
local dbfile = [[/var/lib/interkomm/projects/]]..project..[[/db/files.db]]
local sql = [[ update items set title=']]..metadata.title..[[', description =']]..metadata.description..[[', author=']]..metadata.author..[[' , tags=']]..metadata.tags..[[' where uid=']]..uid..[[';]] 

ikm.db.transaction(dbfile, sql)

return true

end

function ikm.media.update_cmml(project, uid, cmml_plain)

local dbfile = [[/var/lib/interkomm/projects/]]..project..[[/db/files.db]]
local sql = [[update items set cmml = ']]..cmml_plain..[[';]]

ikm.db.transaction(dbfile, sql)

return true

end
