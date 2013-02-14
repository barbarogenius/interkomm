--- user interface functions

module("ikm.ui", package.seeall)


local mt = { __index = {} }

function new()
  local page = {}
  local f = setmetatable({ page = page }, mt)

return f
end


function mt.__index:add(html)
 table.insert(self.page, html )
 return true
end


--- this merges all parts and returns the full html
function mt.__index:render()
 local html = table.concat(self.page)
 return html
end



--- load a template from file
local function load_template(templatename)
  local templatefile = io.open("/var/lib/interkomm/app/views/"..templatename..".tpl")
  local template = templatefile:read("*all")
  templatefile:close()

return template
end


--- renders a template and adds the html to page
local mt.__index:subrender(templatename, values)
      local template = load_template(templatename)
      local g = cosmo.fill(template, values)
      table.insert(self.page, g )

return true
end

