--- manage auth digest db/file ( still a stub )

module("ikm.authdigest", package.seeall)

require 'md5'

--- create a new auth digest db ( sqlite )
function create_authdb(dbname)
  local sql = [['CREATE TABLE user (password varchar(30), username varchar(30), realm varchar(30));']]
  os.execute("sqlite3 "..dbname.." "..sql)
end



--- get a md5 digest hash
-- @param realm
-- @param username
-- @param password
-- @return dhash string
function md5hash(realm, username , password)
  local combined = username..[[:]]..realm..[[:]]..password
  local dhash = md5.sumhexa(combined)

return dhash
end



--- create a digest line for a flat file
-- @param realm
-- @param username
-- @param password
--
function digest(realm, username, password)

local dhash = md5hash(realm, username, password)
local digest_line = username..[[:]]..realm..[[:]]..dhash

print(digest_line)

end


--- read authfile into a table
-- @param filename
-- 
function read_authfile(filename)

local file = assert(io.open(filename, "r"))
local dtable = {}

  for line in file:lines() do 
    table.insert(dtable, line)
  end

return dtable

end

