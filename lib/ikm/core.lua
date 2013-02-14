--- some functions to extenbd the standard lua api
--
module("ikm.core", package.seeall)


--- simple wrapper to pipe from stdout
-- @param command
-- @return l stdin
function stdout(command)

  local f = io.popen(command)
  local l = f:read("*a")
  f:close()

return l
end --end stdout

------
-- simple trim function
-- @param s string
-- @return s
function trim(s)
 return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end -- end trim


------
--- simple try/catch
function try(f, catch)

local status,err = pcall(f)

  if status then
     return true
  else
     catch()
  end

end


--- this might be replaced by lfs
function fsize (path)
      local file = io.open(path, "r")
        local current = file:seek()
        local size = file:seek("end")
        file:seek("set", current)
        file:close()
      return size
end

--- a simplified switch
function switch(t)
      t.case = function (self,x)
        local f=self[x] or self.default
        if f then
          if type(f)=="function" then
            f(x,self)
          else
            error("case "..tostring(x).." not a function")
          end
        end
      end
      return t
end -- 


------
-- 
--
function round(value, precision)
     return math.floor(value*math.pow(10,precision)+0.5) / math.pow(10,precision)
end


------
---
--
function split(str, pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end 

--- this is used to execute command line utilities
function prepare(cmd)

return string.gsub(cmd, "\n", "")

end

--- load the boot and the config file
function load_config(boot_path)

local config_yml = io.open(boot_path, "r")
local con = config_yml:read("*a")
config_yml:close()

local config = yaml.load(con)

return config

end

--- this is used to escape external commans thrown by os.execute()
function escape_path(path)
  local path = string.gsub(path, "(%s)", "\\ ")
return path
end


---
function table_indexOf(t, value)
  for k, v in pairs(t) do
    if type(value) == "function" then
      if value(v) then return k end
    else
      if v == value then return k end
    end
  end

  return nil
end

---
function table_includes(t, value)
  return table_indexOf(t, value)
end

---
function table_unique(t)
  local seen = {}
  for i, v in ipairs(t) do
    if not table_includes(seen, v) then table.insert(seen, v) end
  end

  return seen
end


---
function toboolean(v)

if not v then
   return false
elseif tonumber(v) == 0 then
   return false
else
  return true
end

end
