-- panel.lua
-- Panel Widget
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local cpu = require("ui.widgets.cpu")
local ram = require("ui.widgets.ram")
local disk = require("ui.widgets.disk")
local disk2 = require("ui.widgets.disk2")
-- Seperator -----------------------------------------------------------------

local sep = wibox.widget {
    {color = beautiful.xcolor8, text = "::", widget = wibox.widget.textbox},
    bottom = dpi(3),
    widget = wibox.container.margin
}

local dashboard = wibox({
    visible = false,
    height = 60,
    width = 630,
    ontop = true,
    bg = beautiful.xbackground,
    fg = beautiful.xforeground,
    border_width = dpi(1),
    border_color = beautiful.xcolor0,
    type = "dock",
    screen = screen.primary
})

function dashboard:toggle(screen)
    self.screen = screen
    self.visible = not self.visible
    awful.placement.top_left(self, {offset = {x = 10, y = 40}})
end

dashboard:setup{
    layout = wibox.layout.align.vertical,
    nil,
    {
        cpu,
        sep,
        ram,
        sep,
        disk,
        -- sep,
        -- disk2,
        layout = wibox.layout.fixed.horizontal
    }
}

return dashboard

-- EOF -------------------------------------------------------------------------
