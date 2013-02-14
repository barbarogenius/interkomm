--- function used by the spool/job daemon

module("ikm.spool", package.seeall)


local log = logging.file("/var/log/interkomm/production.log", "%Y-%m-%d", os.date("%b %d %H:%M:%S").." %level %message\n" )


--- translate the job status in something human readable
function translate(status)
  local translate = { [0] = "pending" , [1] = "processing", [2] = "done", [3] = "failed" }
  local status_human = translate[status]

return status_human 
end


--- decode the task json string
local function decode_task(task_json)
  local task = json.decode(task)

return task
end



--- the main loop for reading the job queue and executing the tasks
-- as this might be run in parralel
function run(level)
   local startmessage = [[starting interkomm job spool 0.4 ]]
   log:info(startmessage)

   local level = level or 1
   log:info("starting worker level "..level)

while true do

  --- we request a new job, this can be simplyfied as 
  -- we now only request one job
  local pending_jobs = ikm.db.collect_jobs(level)

if pending_jobs then
  log:info("worker level "..level.." got "..pending_jobs.uid)

  local start_time = os.time()
  local task = json.decode(pending_jobs.task)
  local jobtype = task.type
  
  


local a = ikm.core.switch {

      ["preview"] = function (x) 
                    --- we create a preview
                    log:info("preview job for "..task.path)
                    ikm.db.set_jobstatus(pending_jobs.rowid, 1)

                    log:info("job "..pending_jobs.rowid.." was set to status: in_progress")
                    ikm.core.try (
                                  function()
                                    ikm.util.create_storyboard(task.path,  pending_jobs.uid)
                                    ikm.lcoder.tasks(task.path, { 240 }, "_240p", pending_jobs.uid)
                                    ikm.db.set_jobstatus(pending_jobs.rowid, 2)
                                  end,
                                    -- if saomething went wrong when executing the task:
                                  function()
                                    log:debug("spool: "..pending_jobs.rowid.." failed.")
                                    ikm.db.set_jobstatus(pending_jobs.rowid, 3)
                                  end
                                 )
                  
                    end,

      ["production"] = function (x) 
                    --- we execute a production rule file
                     log:info("production job for "..task.path)
                     log:info("looking for rule file in "..ikm.media.get_directory(task.path))
                     ikm.db.set_jobstatus(pending_jobs.rowid, 2)
                     end,

      ["cut"]       = function (x)
                    --- we cut a video
                     
                     log:info("cut job for "..task.path.." "..task.t_in.."-"..task.t_out)             
                     ikm.db.set_jobstatus(pending_jobs.rowid, 1)
                     ikm.util.cut(task.path, task.t_in, task.t_out)
                     ikm.db.set_jobstatus(pending_jobs.rowid, 2)
                    end,

      ["audioexport"] = function (x)
                    --- this does nothing so far
                     ikm.db.set_jobstatus(pending_jobs.rowid, 1)
                     log:info("audioexport format:"..task.format.." for "..task.path)
                     ikm.audio.export(task.path, task.format)
                     ikm.db.set_jobstatus(pending_jobs.rowid, 2)       
                    end,

      ["writemd"] = function (x)

                     ikm.db.set_jobstatus(pending_jobs.rowid, 1)
                     log:info("writing metadata (sim) for "..task.uid)
                     ikm.db.set_jobstatus(pending_jobs.rowid, 2)
                    end,

      default = function (x) 
                    --- job could not be defined
                    log:debug("could not find out what to do for "..task.path)
                    ikm.db.set_jobstatus(pending_jobs.rowid, 3)
                end,


    }

    -- we execute the actual switch
    a:case(jobtype)   

    log:debug("job "..pending_jobs.rowid.." done. job took "..os.time() - start_time.."sec.")  

end

-- TODO: this needs to be taken from config
posix.sleep(10)

end

end

