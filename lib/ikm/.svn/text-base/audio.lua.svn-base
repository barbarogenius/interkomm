--- export audio tracks

module("ikm.audio", package.seeall)

--- wrapper to export the audio track to different formats
-- @param path string
-- @param format string
function export(path, format)


local path = ikm.core.escape_path(path)

local a = ikm.core.switch {

          ["native"] = function(x)
                       local cmd = [[ffmpeg -y -i ]]..path..[[ -vn -acodec copy -f mkv ]]..path..[[_audio.mka 2>/dev/null]]
                       os.execute(cmd)
                       end,

          ["flac"] = function(x)
                       local cmd = [[ffmpeg -y -i ]]..path..[[ -vn -acodec flac ]]..path..[[_audio.flac  2>/dev/null]]
                       os.execute(cmd)
                 end , 

          ["pcms16le"] = function(x)
                       local cmd = [[ffmpeg -y -i ]]..path..[[ -vn -acodec pcm_s16le ]]..path..[[_audio.wav 2>/dev/null]]
                       os.execute(cmd)
                 end ,

          ["vorbis"] = function(x)
                       local cmd = [[ffmpeg -y -i ]]..path..[[ -vn -acodec libvorbis -f ogg ]]..path..[[_audio.oga 2>/dev/null]]
                       os.execute(cmd)
                 end ,

          default = function(x)
                 -- DEBUG print("nothing")
                 -- we do not fo anything
                 end ,

          }

a:case(format)


end
