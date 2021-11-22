
-- Provides:
-- signal::cpu
--      used percentage (integer)
local awful = require("awful")

local update_interval = 5
local kernal_script = [[
  sh -c "
    uname -a | awk '{printf $3}'
  "]]

-- Periodically get cpu info
awful.widget.watch(kernal_script, update_interval, function(widget, stdout)
    local kernal = stdout
    kernal = string.gsub(kernal, '^%s*(.-)%s*$', '%1')
    awesome.emit_signal("signal::", 100 - tonumber(kernal))
end)
