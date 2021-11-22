local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ram_bar = wibox.widget({
  max_value = 100,
  value = 0,
  forced_height = dpi(3),
  margins = dpi(6),
  color = beautiful.xcolor3,
  background_color = beautiful.xcolor0,
  widget = wibox.widget.progressbar,
})

local ram_text = wibox.widget({
  text = "RAM",
  font = beautiful.font,
  color = beautiful.xforeground,
  align = "center",
  widget = wibox.widget.textbox,
})

awesome.connect_signal("signal::ram", function(used, total)
  local used_ram_percentage = (used / total) * 100
  ram_bar.value = used_ram_percentage
end)

return wibox.widget({
  {
    ram_bar,
    ram_text,
    layout = wibox.layout.stack,
  },
  margins = dpi(10),
  widget = wibox.container.margin,
})
