--- common debugging functions, e.g. dumping tables to stdout 

module("ikm.debug", package.seeall)

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
end -- end showtable

