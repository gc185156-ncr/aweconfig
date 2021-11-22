-- panel.lua
-- Panel Widget
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local cpu = require("ui.widgets.cpu")
local ram = require("ui.widgets.ram")
local root = require("ui.widgets.root")
local data = require("ui.widgets.data")
local temp = require("ui.widgets.temp")

local w = dpi(300)

local dashboard = wibox({
  visible = false,
  height = screen_height - beautiful.wibar_height - 20,
  width = w,
  ontop = true,
  bg = beautiful.wibar_bg,
  fg = beautiful.xforeground,
  border_width = dpi(1),
  border_color = beautiful.xcolor0,
  type = "dock",
  screen = screen.primary,
})

function dashboard:toggle(screen)
  self.screen = screen
  self.visible = not self.visible
  awful.placement.top_left(self, { offset = { x = 10, y = 40 } })
end

dashboard:setup({
  layout = wibox.layout.align.vertical,
  nil,
  {
    {
      nil,
      {
        {
          image = gears.surface(gears.filesystem.get_configuration_dir() .. "images/me.png"),
          resize = true,
          widget = wibox.widget.imagebox,
        },
        height = w / 2,
        width = w / 2,
        widget = wibox.container.constraint,
      },
    shape = gears.shape.squircle,
    layout = wibox.layout.align.horizonal,
    widget = wibox.container.background,
    },

    cpu,
    ram,
    temp,
    root,
    data,
    layout = wibox.layout.fixed.vertical,
  },
})

return dashboard

-- EOF -------------------------------------------------------------------------
