file = io.open("/home/startx/projects/interkomm-project/interkomm/trunk/config/interkomm.yml", "r")
con = file:read("*a")
file:close()

require 'yaml'

------
-- display a table structure
-- only for debugging purposes and will be removed later
function showtable(t, indent)
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']')
    if type(value)=="table" then io.write(':\n') showtable(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end




content = yaml.load(con)

showtable(content)
