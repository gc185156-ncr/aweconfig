local beautiful = require("beautiful")
local awful = require("awful")

local update_interval = 300
local package_script = [[
  sh -c "
    paru -Q | wc -l
  "]]

return awful.widget.watch(package_script, update_interval, function(widget, stdout)
  widget.markup ="<span foreground='" .. beautiful.xcolor8 .. "'>Packages - " .. stdout .. "</span>"
  widget.font = beautiful.font_name .. "14"
end)
