--- very basic module to parse cmml 

module("ikm.cmml", package.seeall)


function parse(cmml_raw)

local clips_raw = {}
local clips = {}

  --- 1) we get the clips
  for c in string.gmatch(cmml_raw, "<clip(.-)</clip>") do
   table.insert(clips_raw, c)
  end

  --- 2) we parse the ids, description, start and end time
  for i, c in ipairs(clips_raw) do
     table.insert(clips , 
                  { id = string.match(c, "id%=\"(.-)\""), 

                 
                    clip_start = string.match(c, "start%=\"(.-)\""), 


                    clip_end = string.match(c, "end%=\"(.-)\""),


                    desc = string.match(c, "<desc>(.-)</desc>"),
                  })
  end

return clips

end
