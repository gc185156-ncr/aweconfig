local beautiful = require("beautiful")
local awful = require("awful")

local update_interval = 300
local kernal_script = [[
  sh -c "
    uname -r 
  "]]

return awful.widget.watch(kernal_script, update_interval, function(widget, stdout)
  widget.markup ="<span foreground='" .. beautiful.xcolor8 .. "'>" .. stdout .. "</span>"
  widget.font = beautiful.font_name .. "14"
end)
