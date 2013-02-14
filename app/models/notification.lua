module("models.notification", package.seeall)


function list_notifications()

local  notification_jobs_t = {}
local  joblist = ikm.db.show_jobs()
       for _,job in pairs(joblist) do
         if job.project == dis.project then
           local task = json.decode(job.task)
           table.insert(notification_jobs_t, "<li>"..os.date("%d %b %H:%M", job.time).." | "..ikm.media.get_filename(task.path).." | "..task.type.." | <b>"..ikm.spool.translate(tonumber(job.status)).."</b></li>")
         end
       end
local  notification_jobs_html = table.concat(notification_jobs_t) or ""


return notification_jobs_html

end
