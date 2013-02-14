module(..., package.seeall)


function run(dis)

local page = {}


local values = { sitename="interkomm" }
local g = ikm.html.render("layouts/common/_header", values)
table.insert(page, g)


if dis.user.name ~= "admin" then

  table.insert(page, [[
  <div class="header">
  <a href="/">interkomm</a> / <b>admin</b>
  </div>
  ]])
  table.insert(page, "<div class='container'><h2>You have no access to admin.</h2></div>")

  return table.concat(page)
end


local values = { dis = dis }
local g = ikm.html.render("admin/index", values)
table.insert(page, g)


if dis.action then
table.insert(page,"<div class='admininfo'>")

table.insert(page, "<ul>")
   if dis.action == "jobs" then

       joblist = ikm.db.show_jobs()
       for _,job in pairs(joblist) do
         local task = json.decode(job.task)
         task.path = string.gsub(task.path, "/var/lib/interkomm/projects", "")
         table.insert(page, "<li>"..os.date("%d %b %H:%M", job.time).." | "..task.path.." : "..task.type.." | <b>"..ikm.spool.translate(tonumber(job.status)).."</b></li>")
       end       

   elseif dis.action == "log" then
       local l_t = ikm.task.readlog(20)
          for _,logline in pairs(l_t) do
              table.insert(page, "<li>"..logline.."</li>")
          end

   elseif  dis.action == "status" then
        local s_t = ikm.task.status()
           for _,statusline in pairs(s_t) do
              table.insert(page, "<li>"..statusline.."</li>")
          end
   elseif dis.action == "users" then

        --- this will all go into a view eventually
        local user_t = ikm.user.list()
        if user_t then
        for _, username in ipairs(user_t) do
           local membership_t = ikm.project.membership(username)
           local membership = table.concat(membership_t, ",")
           table.insert(page, [[<div style="margin: 10px; border-bottom: 1px solid #000;">
                     <b>]]..username..[[</b>: ]]..membership..[[

                     <br />
                     add this user to project: 
                     <form>
                     <select>
                     <option></option>
                     </select>
                     </form>

                     <br />
                     remove this user from project:
                      <form>
                     <select>
                     <option></option>
                     </select>
                     </form>



                     </div>]])
                                

        end
        end

   else
   table.insert(page, "<div>admin</div>")
   end
table.insert(page, "</ul>")
table.insert(page,"<div>")
end



local values = { }
local g = ikm.html.render("layouts/common/_footer", values)
table.insert(page, g)


return table.concat(page)

end
