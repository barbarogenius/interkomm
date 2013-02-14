module("ikm.ffwrap", package.seeall)

--- attempts to evaluate the output of ffmpeg for errors
local function evaluate(out)
  local ERR = { "Unable", "Invalid", "Missing", "No such file or directory" }
  for _,e in ipairs(ERR) do
    if string.match(out, "("..e..".-)$") then
      return false
   end
  end

return true
end

--- executes the actual ffmpeg process
-- returns true if no error was found
function spawn(ffargs)
  local cmd = [[ffmpeg -y -threads 2 ]]..ffargs..[[ 2>/dev/stdout]]
  local f = io.popen(cmd)
  local l = f:read("*a")
  f:close()

  return(evaluate(l))
   -- valid = video:6704kB audio:180kB global headers:0kB muxing overhead 8.845344%   
end

