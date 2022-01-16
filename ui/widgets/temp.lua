local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local temp_bar = wibox.widget({
  max_value = 100,
  value = 0,
  forced_height = dpi(3),
  margins = dpi(8),
  color = beautiful.xcolor9,
  background_color = beautiful.xcolor0,
  widget = wibox.widget.progressbar,
})

local temp_text = wibox.widget({
  text = "TEMP",
  font = beautiful.font_name .. "14",
  color = beautiful.xforeground,
  align = "center",
  widget = wibox.widget.textbox,
})

awesome.connect_signal("signal::temp", function(value)
  temp_bar.value = value
  temp_text.text = "TEMP - " .. value .. "C°"
end)

return wibox.widget({
  {
    temp_text,
    temp_bar,
    layout = wibox.layout.align.vertical,
  },
  margins = dpi(10),
  widget = wibox.container.margin
})
