module(..., package.seeall)

function run(dis)

--local models = { items = require 'items' , 
--                 notifications = require 'notification' }

local page = {}


local values = { sitename = "interkomm / "..dis.project }
local g = ikm.html.render("layouts/common/_header", values)
table.insert(page, g)

if not ikm.project.is_member(dis.project, dis.user.name) and dis.user.name ~= "admin" then
  table.insert(page, [[
  <div class="header">
  <a href="/">interkomm</a> 
  </div>
  ]])
  table.insert(page, "<div class='container'><h2>You are not a member of this project.</h2></div>")
  return table.concat(page)
end

------- from here we will have this over to /app/models/models/items
local folders = ikm.project.new_get_folders(dis.project, "work")
local folders_html_t = {}
if dis.pathfilter then
     table.insert(folders_html_t, [[<option value="]]..dis.pathfilter..[[" selected>]]..dis.pathfilter..[[</option>]])
end
for _,f in pairs(folders) do
    table.insert(folders_html_t, [[<option value="]]..f..[[">]]..f..[[</option>]])  
end
local folders_html = table.concat(folders_html_t)


--- TODO add search and folder filter here
local file_t = ikm.db.list_files(dis.project, dis.pathfilter, dis.filter)
local files
files_html_t = { } 

if file_t[1] then
  for _,file in pairs(file_t) do
    
    table.insert(files_html_t, [[<div class="itemlist">]])
    table.insert(files_html_t, file.uid.." | "..ikm.media.get_filename(file.path).." | "..file.duration.."sec | added: "..os.date("%x %H:%M", file.time).."\n")

    --- display the correct flags
    table.insert(files_html_t, [[<span style="margin-left: 30px;">]])
    if ikm.core.toboolean(file.export) then
       table.insert(files_html_t, [[<img src="/img/export_flag.png" style="width: 10px; height: 10px;" />]])
    end
    if ikm.core.toboolean(file.locked) then
       table.insert(files_html_t, [[<img src="/img/lock_flag.png" style="width: 10px; height: 10px;" />]])
    end
       table.insert(files_html_t, " "..file.claimed)

    table.insert(files_html_t, [[</span>]])

    table.insert(files_html_t, "<div><table><tr><td>")
          for b = 1,5 do
                table.insert(files_html_t, [[<img src="/system/pool/]]..file.uid..[[_]]..b..[[.png" class="zoom"/>]])
          end   
    table.insert(files_html_t, [[</td><td><a href="/?project=]]..dis.project..[[&video=]]..file.uid..[[">open</a></td>]])
    table.insert(files_html_t, "</tr></table></div>")
    table.insert(files_html_t, "</div>")

  end
files = table.concat(files_html_t)
else

  if dis.pathfilter then
  files = "<div>there are currenly no files in this folder.</div>"
  elseif dis.filter then
  files = "<div>no files in this project match the filter.</div>"
  else
  files = "<div>there are currenly no files in this project.</div>"
  end

end

local  pathfilter = dis.pathfilter or ""
local  filter = dis.filter or ""



local  notification_jobs_t = {}
local  joblist = ikm.db.show_jobs()
       for _,job in pairs(joblist) do
         if job.project == dis.project then
           local task = json.decode(job.task) 
           table.insert(notification_jobs_t, "<li>"..os.date("%d %b %H:%M", job.time).." | "..ikm.media.get_filename(task.path).." | "..task.type.." | <b>"..ikm.spool.translate(tonumber(job.status)).."</b></li>")
         end
       end
local  notification_jobs_html = table.concat(notification_jobs_t) or ""



local memberslist_html = table.concat(ikm.project.list_members(dis.project), " ") 



--- http upload
local values = { dis = dis, project = dis.project , random_id = os.time() }
local mod_upload_html = ikm.html.render("projects/modules/_mod_http_upload", values )

--- xml upload (only for melt)
local values = { dis = dis, project = dis.project , random_id = os.time() }
local mod_xml_upload_html = ikm.html.render("projects/modules/_mod_xml_upload", values )


local stats_html
local stats = ikm.project.videostats(dis.project)
         if stats then
           local psize = ikm.core.round( stats.size_all / 1024 / 1024 , 2 )
            stats_html = stats.count.." videos , "..psize.."MB"
         end



local display_html 
if string.len(pathfilter) > 1 then
    display_html = "Folder: <i>"..pathfilter.."</i>"
elseif dis.filter then
    display_html = "Search: <i>"..dis.filter.."</i>"
end

local tags = ikm.project.tags(dis.project)
local tag_html = table.concat(tags, " ")
local xml_files_html
local xml_files = ikm.project.list_xml(dis.project)

if xml_files then
   
   local out = {}
   


   xml_files_html = table.concat(xml_files, "<br />")


else
   xml_files_html = "There are no XML files in this project."
end

local values = { dis = dis, 
                 project = dis.project , 
                 files = files , 
                 pathfilter = pathfilter, 
                 folders_html = folders_html, 
                 notification_jobs_html = notification_jobs_html, 
                 memberslist_html = memberslist_html,
                 stats_html = stats_html,
                 display_html = display_html,
                 tag_html = tag_html, 
                 mod_upload_html = mod_upload_html,
                 mod_xml_upload_html = mod_xml_upload_html,
                 xml_files_html = xml_files_html }
local g = ikm.html.render("projects/home", values)
table.insert(page, g)




local values = { }
local g = ikm.html.render("layouts/common/_footer", values)
table.insert(page, g)


return table.concat(page)

end
