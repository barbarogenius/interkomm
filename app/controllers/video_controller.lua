module(..., package.seeall)


function run(dis)

local page = {}


local values = { sitename = "interkomm / "..dis.project.." / video / "..dis.video }
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




table.insert(page, [[

<div class="header">
<a href="/">interkomm</a> / <a href="/project/]]..dis.project..[[/">]]..dis.project..[[</a> / video / ]]..dis.video..[[ 
</div>

<div class="topbar">
Logged in as ]]..dis.user.name..[[
</div>

<div class="container">

]])

local item = ikm.db.get_item_details(dis.project, dis.video)

--- TODO remove the dependency on lcoder
local videoinfo, audioinfo = ikm.lcoder.newinfo(item.path)
local video_i = {}
local audio_i = {}

for k,v in pairs(videoinfo) do
    table.insert(video_i, k.." : "..v.."<br />\n")
end
local video_i_html = table.concat(video_i)

for k,v in pairs(audioinfo) do
    table.insert(audio_i, k.." : "..v.."<br />\n")
end
local audio_i_html = table.concat(audio_i)
local mediainfo_html = "<p class='module'><b>Video</b><br />"..video_i_html.."<br /><br /><b>Audio</b><br /> "..audio_i_html.."\n</p>"


-- CMML and chapters
local cmml_t = ikm.cmml.parse(item.cmml)
if type(cmml_t) == "table" then
    local cmml_p = {} 
    for i, clip in pairs(cmml_t) do
        table.insert(cmml_p, [[<li>]]..i..[[ : ]]..clip.desc..[[</li>]])
    end
  cmml_parsed = table.concat(cmml_p)
else
  cmml_parsed = "no chapters found."
end


item.time = os.date("%d %b %H:%M", item.time)
item.sec = math.floor(item.duration)
local values = { project = dis.project, item = item,  mediainfo_html = mediainfo_html , cmml_parsed = cmml_parsed }
local g = ikm.html.render("video/_videoinfo", values)
table.insert(page, g)


--table.insert(page,"<div class='modules_left'>")


local values = { video = "/system/pool/"..dis.video.."_240p.webm", project = dis.project, item = item , poster = item.uid}
local g = ikm.html.render("video/_videoplayer", values)
table.insert(page, g)



table.insert(page,"<div class='modules'>")

--- new_cutter
local values = { project = dis.project, item = item }
local g = ikm.html.render("video/modules/_new_cutter", values)
table.insert(page, g)

--- module_cutter
--local values = { project = dis.project, item = item }
--local g = ikm.html.render("video/modules/_cutter", values)
--table.insert(page, g)

--- module_produce
local values = { project = dis.project, item = item }
local g = ikm.html.render("video/modules/_produce", values)
table.insert(page, g)

--- module_audioexport
local values = { project = dis.project, item = item }
local g = ikm.html.render("video/modules/_audioexport", values)
table.insert(page, g)

table.insert(page,"</div>")



local values = { }
local g = ikm.html.render("layouts/common/_footer", values)
table.insert(page, g)


return table.concat(page)

end
