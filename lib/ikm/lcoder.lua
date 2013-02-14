--- more intelligent encoding ( ratio detection, adjusting quality per resolution )

module("ikm.lcoder", package.seeall)

OPTION_QUIET = true
DO_PASS = 1

--- this is largely from the older ikmencoder standalone utility

--- display a table structure
-- only for debugging purposes and will be removed later
function showtable(t, indent)
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']')
    if type(value)=="table" then io.write(':\n') showtable(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end -- end showtable


--- TODO: replace by method from core.lua
function string.trim(str)
        -- Function by Colandus
        return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end


---
function explode(str, sep)
        -- Function by Colandus
        local pos, t = 1, {}
        if #sep == 0 or #str == 0 then return end
        for s, e in function() return string.find(str, sep, pos) end do
                table.insert(t, string.trim(string.sub(str, pos, s-1)))
                pos = e+1
        end
        table.insert(t, string.trim(string.sub(str, pos)))
        return t
end


------
---
-- @param arg table
-- @return opt_filename, opt_target string
function getopt(arg)
  local opt_filename, opt_target
  local opt_extension = ""

    for i=1, #arg do
      if arg[i] == "-i" then
         local p = i + 1
         opt_filename = arg[p]
      end

      if  arg[i] == "-t" then
         local p = i + 1
             opt_target = explode(arg[p],",")
      end

    end

    for i=1, #arg do
        if arg[i] == "-e" then
           opt_extension = "_"..opt_target.."p"
        end
        if arg[i] == "-q" then
           OPTION_QUIET = true
        end
    end

   
return opt_filename, opt_target, opt_extension

end

------
---
--
--
function round(num, idp)
  local mult = 10^(idp or 0)

  return math.floor(num * mult + 0.5) / mult
end



---
function size_per_min(path)

local videoinfo, audioinfo = newinfo(path)
local avsize

local size = stdout("stat -c%s "..path)
avsize = ( size / 1048576 ) / ( videoinfo.duration / 60 )

return round(avsize, 2)

end


---
function set_targetsize(target, mode)

local targetsize 

  local targets = { 
        ["four"]   = { [480] = "640x480" , [360] = "480x360",  [240]  = "320x240" }, -- 4:3
        ["sixteen"]= { [480] = "854x480" , [360] = "640x360" , [240]  = "428x240" }, -- 16:9
        ["eleven"] = { [480] = "586x480" , [360] = "430x360" , [240]  = "292x240" }, -- 11:9
        ["five"]   = { [480] = "800x480" , [360] = "600x360" , [240]  = "400x240" }, -- 5:3
  }

  if targets[mode] then
     targetsize = targets[mode][target]
  end

return targetsize

end


---
function set_mode(videoinfo)

local aspect = round((videoinfo.width / videoinfo.height ), 2)


    local modes = {
          [1.33] = "four" ,
          [1.78] = "sixteen",
          [1.22] = "eleven" ,
          [1.5]  = "four",
          [1.67] = "five",
          }

    local mode = modes[aspect]

return mode

end


------
---
-- wrapper to fetch output from stdout
-- @param command
function stdout(command)

  local f = io.popen(command)
  local l = f:read("*a")
  f:close()

  return l
end


---
function newinfo(path)

local videoinfo = {}
local audioinfo = {}

local out = stdout("ffprobe -show_streams "..ikm.core.escape_path(path).." 2>/dev/null")
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

-- workaround for ffprobe bug
if videoinfo.codec_name == "vp8" then
   local otherinfo = stdout("mkvinfo "..ikm.core.escape_path(path).." | grep Duration")
   videoinfo.duration = string.match(otherinfo, "Duration%: (.-)%.")
end


if DEBUG then
   -- DEBUG
   print("VIDEO:")
   showtable(videoinfo)
   print("AUDIO:")
   showtable(audioinfo)
end

return videoinfo, audioinfo

end

------
--
--
--
function check_target(videoinfo, audioinfo, target)

local checktarget

if videoinfo.codec_name == "vp8" and audioinfo.codec_name == "vorbis" then
   checktarget = true
end

return checktarget

end


------
--
--
function tasks(filename, targets, opt_extension , uid)

    for _,target in ipairs(targets) do
       local opt_extension = "_"..target.."p" 
       encode(filename, target, opt_extension, uid)
    end

end



------
---
--
--
function encode(filename, target, opt_extension, uid)

local  new_filename

if uid then
  new_filename = uid..opt_extension..[[.webm]]
else
  new_filename = ikm.media.get_filename(filename)..opt_extension..[[.webm]]
end

local targetsize, err , mode

  local videoinfo, audioinfo = newinfo(filename)
    local checktarget = check_target(videoinfo, audioinfo, target)
    if checktarget then
       io.write("file already suitable, nothing to do.\n")
       os.exit()
    end

    if not videoinfo then
       err = "could not get info from video"
    end


    if tonumber(videoinfo.height) <= tonumber(target) then
       mode = "custom"
       targetsize = videoinfo.width.."x"..videoinfo.height
    else
       mode = set_mode(videoinfo)
         if not mode then
            err = "could not determine aspect ratio"
         end

         targetsize = set_targetsize(tonumber(target), mode)
           if not targetsize then
              err = "invalid targetsize"
           end
    end

  -- this should go into a real logfile
  -- DEBUGGING: print("LOG: mode: " ..mode.." target: ".. targetsize)
  if tonumber(target) == 360 then 
     qmin = 10 
     qmax = 53
  elseif tonumber(target) == 240 then 
     qmin = 50
     qmax = 53
  elseif tonumber(target) == 480 then
     qmin = 2
     qmax = 41
  end

  -- dirty
  OPTION_QUIET = true    

  -- TODO: this is obsolete if used inside interkomm
  local arg_quiet 
  if OPTION_QUIET then
     arg_quiet =  "2>/dev/null"
  else
     arg_quiet =  ""
  end


      if DO_PASS == 1 then

      local cmd = [[ffmpeg -y -i ]]..ikm.core.escape_path(filename)..[[
                   -threads 2 -vcodec libvpx -g 120 -qmin ]]..qmin..[[ -qmax ]]..qmax..[[ -level 0
                   -r 25 -s ]]..targetsize..[[
                   -acodec libvorbis -aq 3
                   -f webm /var/lib/interkomm/public/system/pool/]]..new_filename..[[ ]]..arg_quiet
      os.execute(string.gsub(cmd,"\n"," "))


      else

        local tempfile = "/tmp/"..uid..".tmp"
        for pass = 1, 2 do
        local cmd = [[ffmpeg -y -i ]]..ikm.core.escape_path(filename)..[[ -pass ]]..pass..[[
                     -passlogfile ]]..tempfile..[[.log
                     -threads 2 -vcodec libvpx -g 120 -qmin ]]..qmin..[[ -qmax ]]..qmax..[[ -level 0 
                     -r 25 -s ]]..targetsize..[[ 
                     -acodec libvorbis -aq 3  
                     -f webm /var/lib/interkomm/public/system/pool/]]..new_filename..[[ ]]..arg_quiet
        os.execute(string.gsub(cmd,"\n"," "))
        end

      end

return true, err

end


