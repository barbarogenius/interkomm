--- this should completely move to ikm.ui

module("ikm.html", package.seeall)

--- load a template from file
function load_template(templatename)
  local templatefile = io.open("/var/lib/interkomm/app/views/"..templatename..".tpl")
  local template = templatefile:read("*all")
  templatefile:close()

return template
end


--- a simple dispatcher, might be moved elsewhere later
function dispatch(dis)

if dis.project then
   if dis.project == "admin" then
     path = "admin" 
   else
     path = "project"
   end

end
if dis.project and dis.video then
   path = "video"
end


if not dis.project and not dis.video then
   path = "home"   
end

local b = path.."_controller"

return b

end

--- TODO this should go in its own module 
function sanitize(s, mode)

  if mode == "strict" then
     s = string.gsub(s, "%W", "")
  elseif mode == "path" then
     s = string.gsub(s, "[%W/]", "/")
     s = string.gsub(s, "/+","/")
  end

return s

end

--- TODO: move this to ikm.ui too
function render(templatename, values)
      local h = load_template(templatename)
      local g = cosmo.fill(h, values)

return g
end
