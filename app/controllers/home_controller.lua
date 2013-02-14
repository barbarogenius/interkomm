module(..., package.seeall)


function run(dis)

local page = {}

local BOOT_PATH = "/etc/interkomm/interkomm.yml"
local IKM_ENV = "production"
local CONFIG = ikm.core.load_config(BOOT_PATH)


local values = { sitename="interkomm" }
local g = ikm.html.render("layouts/common/_header", values)
table.insert(page, g)


local values = { dis = dis }
local g = ikm.html.render("layouts/common/_topbar", values)
table.insert(page, g)


local projectlist_t = {}
local p = ikm.project.find_projects("/var/lib/interkomm/projects/")

  for _,project in pairs(p) do
    if ikm.project.is_member(project.name, dis.user.name) or dis.user.name == "admin" then
    table.insert(projectlist_t, [[<li><a href="/project/]]..project.name..[[/">]]..project.name..[[</a> 
                                  (]]..project.status..[[) created: ]]..os.date("%x %H:%M", ikm.project.created(project.name))..[[</li>]])
    end

  end

local projectlist = table.concat(projectlist_t)

local values = { dis = dis, projectlist = projectlist }
local g = ikm.html.render("index", values)
table.insert(page, g)



local values = { }
local g = ikm.html.render("layouts/common/_footer", values)
table.insert(page, g)


return table.concat(page)

end
