#!/usr/bin/lua

--[[

interkommd.lua

Copyright (C) 2009 startx <startx@plentyfact.org>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 3
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
http://www.gnu.org/copyleft/gpl.html

version 0.0.5

--]]


-- loading modules
require 'socket'
require 'copas'
require 'lanes'

-- loading config
dofile '/etc/interkomm/interkommd.conf'

-- switch
-- @param  t  table
--
local function switch(t)
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
    end -- switch

-- slit
-- @param str string
-- @param pat pattern
-- @return t table
function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
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
end -- split


---
-- this is the actual handler for connection, called everytime a client connects
-- @param connection 
-- @param host  host/ip to bind to
-- @param port  port to listen at
function handler(connection, host, port)
 
  -- get infornmation about remote client
  if IKOMM_CONF.debug then
     print("connection from" ..host..":"..port)
  end
  
  connection:send("IKOMMHELLO\n")

  -- while the connection continous
  while true do

    local data = connection:receive()
    -- performing handshake
      if data == "IKOMMGOODBYE" then
      connection:send("IKOMMGOODBYE\n")
      break
    end

    -- test, we would go to the actual switch statement here
    if data == "purge" then
      connection:send(data.." ACK\n")
    end

    --
    if data == nil then
      data = " "
    else
      connection:send(data.." ACK\n")
    end
   
  end

end -- handler

---
-- prints out a message to stdout when daemon is started
-- 
local function startmessage()

   local startmessage = [[
   interkomm daemon 0.1 (c) startx <startx@plentyfact.org> 2009 GPL v3
   Binding daemon to  ]]..IKOMM_CONF.host..[[:]]..IKOMM_CONF.port..[[ ]]

   print(startmessage)

end -- startmessage

-- interkommd
--
--
function interkommd()

  copas.addserver(
    assert(
     socket.bind(IKOMM_CONF.host, IKOMM_CONF.port)),
        function(connection) 
            return handler(copas.wrap(connection), connection:getpeername()) 
        end
  )
  startmessage()
  copas.loop()

end -- interkommd

-- we start the actual daemon

interkommd()

dofile '/home/startx/workspace/interkomm/mezzodistrutto/ikommd.lua'



