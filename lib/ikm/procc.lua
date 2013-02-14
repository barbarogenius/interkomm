module("ikm.procc", package.seeall)

require 'lfs'

--- throws a process and returns the process id
function start(prepared)
  local cmd = io.popen(prepared.." | echo $! &")
  local pid = tonumber(cmd:read("*a"))
  ptime(pid)
  return pid
end


--- returns the time a process of id pid is running
function ptime(pid) 
  local attr = lfs.attributes("/proc/"..pid)
  local process_t = os.time() - attr.modification
  return process_t
end


--- returns the start time of a process
function stime(pid)
  local attr = lfs.attributes("/proc/"..pid)
  local process_s = attr.modification
  return process_s
end


