--- tiny wrapper around imagemagick command line utility

module("ikm.minimagick", package.seeall)



--- this is a  simple wrapper around some imagemagick command line tools
-- this needs to be sorted out in a reasonable way somehow

function resize(path, x, y)

local err = ikm.core.stdout("mogrify -resize "..x.."x"..y.."! "..path)
  if err then 
     return false
  end

return true

end

