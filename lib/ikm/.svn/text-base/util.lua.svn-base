--- utilities which perform common rendering tasks

module("ikm.util", package.seeall)


--- creates images for a storyboard 
-- @param path
-- @param uid
function create_storyboard(path, uid)

local d = math.floor(ikm.media.get_apx_duration(path)) 
local s = math.floor(d / 5)
local timer = 1

for i=1, 5 do
   local cmd = [[ffmpeg -i ]]..ikm.core.escape_path(path)..[[ -vframes 1 -s 160x90 -ss ]]..timer..[[ /tmp/]]..uid..[[_]]..i..[[.png 2>/dev/null]]
   ikm.core.stdout(cmd)
   --ikm.minimagick.resize([[/tmp/]]..uid..[[_]]..i..[[.png]], 160, 90)
   os.execute([[mv /tmp/]]..uid..[[_]]..i..[[.png /var/lib/interkomm/public/system/pool/]])
   timer = timer + s
end

return true
end



------
--- cut a chunk from a video file ( remuxing only ) 
--
function cut(path, start_t, end_t)
  local lenght_t = end_t - start_t
  local new_path = [[/var/lib/interkomm/projects/]]..ikm.media.get_project_from_path(ikm.core.escape_path(path))..[[/share/cuts/]]..ikm.media.get_filename(ikm.core.escape_path(path))..[[_cut]]..start_t..[[-]]..end_t..[[.mkv]]
  local cmd = [[ffmpeg -y -i ]]..ikm.core.escape_path(path)..[[ -acodec copy -vcodec copy -ss ]]..start_t..[[ -t ]]..lenght_t..[[ ]]..new_path..[[ 2>/dev/null]]
ikm.core.stdout(cmd)

end


--- write the metadata saved in the db back to the original file
function write_metadata(path, item)
local m = item
local filename = ikm.media.get_filename(path)

local cmd = [[ffmpeg -y -i ]]..path..[[ -acodec copy -vcodec copy
              -metadata title="]]..m.title..[["
              -metadata comment="]]..m.description..[[" /tmp/]]..filename..[[ 2>/dev/null]]

local cmd = string.gsub(cmd, "\n", "")

os.execute(cmd)
os.execute("cp -p /tmp/"..filename.." "..path)
os.remove("/tmp/"..filename)

return true

end


--- this is identical with lcoder.newinfo and will eventually replace it
-- @param project
-- @param uid
function inspect_video(project, uid)

local item  = ikm.db.get_item_details(project, uid)

local videoinfo = {}
local audioinfo = {}

local out = ikm.core.stdout("ffprobe -show_streams "..ikm.core.escape_path(path).." 2>/dev/null")
        for stream in string.gmatch(out, "%[STREAM%](.-)%[%/STREAM%]") do
           streaminfo = {}
           for a,b in string.gmatch(stream,"(.-)%=(.-)\n") do
               streaminfo[string.gsub(a, "\n", "")] = string.gsub(b, "\n", "")
           end

           if streaminfo.codec_type == "video" then
              videoinfo = streaminfo
           end
           if streaminfo.codec_type == "audio" then
              audioinfo = streaminfo
           end

        end

-- TODO: parse tags from ffprobe -show_format
local taginfo = {}
local out = ikm.core.stdout("ffprobe -show_formats "..ikm.core.escape_path(path).." 2>/dev/null")
--- tbc

-- workaround for ffprobe bug
if videoinfo.codec_name == "vp8" then
   local otherinfo = ikm.core.stdout("mkvinfo "..ikm.core.escape_path(path).." | grep Duration")
   videoinfo.duration = string.match(otherinfo, "Duration%: (.-)%.")
end


return videoinfo, audioinfo

end
