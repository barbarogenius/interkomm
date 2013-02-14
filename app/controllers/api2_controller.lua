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

local task

local a = ikm.core.switch {

   ["cut"] = function(x)
              task = { type = "cut" ,
                        t_in = dis.t_in,
                        t_out = dis.t_out,
                        path = path }
              local task_json = json.encode(task)
              ikm.db.add_job(dis.project, task_json , dis.uid, 2)
             end,

   ["audioexport"] = function(x)
              task = { type = "audioexport",
                       format = dis.format,
                       path = path }
              local task_json = json.encode(task)
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
             end,

   ["getjob"] = function(x)
              local response_msg = {
                    
 
                    }

              end,

   ["cmml"] = function(x)
              ikm.media.update_cmml(dis.project, dis.uid, dis.cmml_plain)
                          
              end,

   ["processxml"] = function(x)
               local task = { type = "processxml" ,
                              xml = dis.xml ,
                              format = dis.format, }
                              local task_json = json.encode(task)
                              ikm.db.add_job(dis.project, task_json , "000000", 1)               
               end,

}

a:case(dis.api)

dis = nil
collectgarbage("collect")

return response

end
