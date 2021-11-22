-- Provides:
-- signal::temperature
--      temperature (integer - in Celcius)
local awful = require("awful")

local update_interval = 3
local temp_script = [[
  sh -c "
  sensors | grep Tctl | awk '{print $2}' | cut -c 2-3
  "]]

-- Periodically get temperature info
awful.widget.watch(temp_script, update_interval, function(widget, stdout)
    awesome.emit_signal("signal::temp", tonumber(stdout))
end)
