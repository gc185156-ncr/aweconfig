local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local w = dpi(200)

local disk_bar = wibox.widget {
    max_value = 100,
    forced_height = dpi(10),
    margins = {top = dpi(8), bottom = dpi(8), left = dpi(8), right = dpi(8)},
    forced_width = w,
    color = beautiful.xcolor12,
    background_color = beautiful.xcolor0,
    widget = wibox.widget.progressbar
}

local disk_text = wibox.widget {
    text = "DATA",
    font = beautiful.font,
    color = beautiful.xforeground,
    forced_width = w,
    align = "center",
    widget = wibox.widget.textbox
}

awesome.connect_signal("signal::disk2", function(used, total)
    disk_bar.value = tonumber(100 * used / total)
end)

return wibox.widget {disk_bar, disk_text, layout = wibox.layout.stack}
