local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local cpu_bar = wibox.widget({
  max_value = 100,
  value = 0,
  margins = dpi(8),
  forced_height = dpi(3),
  forced_width = w,
  color = beautiful.xcolor5,
  background_color = beautiful.xcolor0,
  widget = wibox.widget.progressbar,
})

local cpu_text = wibox.widget({
  text = "CPU",
  font = beautiful.font_name .. "14",
  color = beautiful.xforeground,
  align = "center",
  widget = wibox.widget.textbox,
})

awesome.connect_signal("signal::cpu", function(value)
  cpu_bar.value = value
end)

return wibox.widget({
  {
    cpu_bar,
    cpu_text,
    layout = wibox.layout.stack,
  },
  margins = dpi(10),
  widget = wibox.container.margin
})
