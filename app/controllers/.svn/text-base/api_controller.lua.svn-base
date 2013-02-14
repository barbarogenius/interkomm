module(..., package.seeall)


function run(dis)

local page = {}

if dis.api == "cut" or dis.api == "audioexport" then
local sql = [[select * from items where uid="]]..dis.uid..[[";]] 
local data = ikm.db.abstract_fetch("/var/lib/interkomm/projects/"..dis.project.."/db/files.db", sql)
if data then
   path = data[1].path
end
end

local values = { sitename="interkomm" }
local g = ikm.html.render("layouts/common/_header", values)
table.insert(page, g)


local values = { dis = dis }
local g = ikm.html.render("layouts/common/_topbar", values)
table.insert(page, g)




table.insert(page, [[<div class="container">]])

local task

local a = ikm.core.switch {

   ["cut"] = function(x)
              task = { type = "cut" ,
                        t_in = dis.t_in,
                        t_out = dis.t_out,
                        path = path }
              local task_json = json.encode(task)
              table.insert(page, task_json )
              ikm.db.add_job(dis.project, task_json , dis.uid, 2)
             end,

   ["audioexport"] = function(x)
              task = { type = "audioexport",
                       format = dis.format,
                       path = path }
              local task_json = json.encode(task)
              table.insert(page, task_json )
              ikm.db.add_job(dis.project, task_json , dis.uid, 2)
             end,
   
   ["metadata"] = function(x)
             -- nothing for now
             local msg = { title = dis.title, 
                           description = dis.description,
                           author = dis.author,
                           tags = dis.tags,
                           project = dis.project,
                           uid = dis.uid,
                          }
            
             local msg_json = json.encode(msg)
             ikm.media.update_db_metadata(dis.project, dis.uid, msg_json)
             table.insert(page, msg_json )
             table.insert(page, "<br />received metadata update") 
             end,

   ["getjob"] = function(x)
              local response_msg = {
                    
 
                    }

              end,



   ["upload"]  = function(x)
               -- nothing for now
              if dis.fileupload then
                 local name = dis.fileupload.name
                 if name then
                   local newfile = "/var/lib/interkomm/projects/"..dis.project.."/share/work/"..name
                   local file = io.open(newfile , "wb" )
                   file:write(dis.fileupload.contents)
                   file:close()
                   table.insert(page, newfile)
                   dis.fileupload.contents = nil
                   posix.sleep(2) -- this is a dirty workaround to avoid some race condition, removed later
                 end
              end


             end,

    ["uploadxml"]  = function(x)
              if dis.fileupload then
                 local name = dis.fileupload.name
                 if name then
                   local newfile = "/var/lib/interkomm/projects/"..dis.project.."/share/xml/"..name
                   local file = io.open(newfile , "wb" )
                   file:write(dis.fileupload.contents)
                   file:close()
                   table.insert(page, newfile)
                   dis.fileupload.contents = nil
                   posix.sleep(2) -- this is a dirty workaround to avoid some race condition, removed later
                 end
              end


             end,
  

}

a:case(dis.api)

table.insert(page, [[<div><a href="]]..dis.referer..[[">go back</a></div>]])
dis = nil
collectgarbage("collect")
table.insert(page, collectgarbage("count"))
table.insert(page, [[</div>]])


local values = { }
local g = ikm.html.render("layouts/common/_footer", values)
table.insert(page, g)

return table.concat(page)

end
