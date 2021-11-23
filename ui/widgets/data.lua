local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local disk_bar = wibox.widget({
  max_value = 100,
  margins = dpi(8),
  forced_height = dpi(3),
  color = beautiful.xcolor12,
  background_color = beautiful.xcolor0,
  widget = wibox.widget.progressbar,
})

local disk_text = wibox.widget({
  text = "DATA",
  font = beautiful.font_name .. "14",
  color = beautiful.xforeground,
  align = "center",
  widget = wibox.widget.textbox,
})

awesome.connect_signal("signal::data_disk", function(used, total)
  disk_bar.value = tonumber(100 * used / total)
end)

return wibox.widget({
  {
    disk_bar,
    disk_text,
    layout = wibox.layout.stack,
  },
  margins = dpi(10),
  widget = wibox.container.margin,
})
