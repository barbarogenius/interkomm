module("model.items", package.seeall)


function list_items()

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

end

else

  if dis.pathfilter then
  files = "<div>there are currenly no files in this folder.</div>"
  elseif dis.filter then
  files = "<div>no files in this project match the filter.</div>"
  else
  files = "<div>there are currenly no files in this project.</div>"
  end

end


end -- end list_items
