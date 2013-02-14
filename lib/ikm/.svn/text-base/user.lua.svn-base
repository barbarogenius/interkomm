--- user account related functions

module("ikm.user", package.seeall)



--- create user account ( very dirty right now)
function create(username, password)

local dhash =  ikm.authdigest.md5hash("interkomm", username, password)
os.execute([[sqlite3 /var/lib/interkomm/db/user.db "INSERT into user (password, username, realm) values (']]..dhash..[[',']]..username..[[','interkomm');"]])

return true

end

---
function update_password(username, password)

local dhash =  ikm.authdigest.md5hash("interkomm", username, password)
os.execute([[sqlite3 /var/lib/interkomm/db/user.db "UPDATE user set password=']]..dhash..[[' where username=']]..username..[[';"]])

return true

end

--- remove user account ( very dirty right now)
function remove(username)
os.execute([[sqlite3 /var/lib/interkomm/db/user.db "DELETE from user where username=']]..username..[[';"]])

return true
end


function list()

local dbfile = "/var/lib/interkomm/db/user.db"
local sql = [[select username from user;]]

local data = ikm.db.abstract_fetch(dbfile, sql)

local user_t = {}

for _,set in ipairs(data) do
    table.insert(user_t, set.username)
end

return user_t

end
