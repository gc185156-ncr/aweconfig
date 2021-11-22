local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local temp_bar = wibox.widget({
  max_value = 100,
  value = 0,
  forced_height = dpi(3),
  margins = dpi(6),
  color = beautiful.xcolor9,
  background_color = beautiful.xcolor0,
  widget = wibox.widget.progressbar,
})

local temp_text = wibox.widget({
  text = "TEMP",
  font = beautiful.font,
  color = beautiful.xforeground,
  align = "center",
  widget = wibox.widget.textbox,
})

awesome.connect_signal("signal::temp", function(value)
  temp_bar.value = value
end)

return wibox.widget({
  {
    temp_bar,
    temp_text,
    layout = wibox.layout.stack,
  },
  margins = dpi(10),
  widget = wibox.container.margin
})
