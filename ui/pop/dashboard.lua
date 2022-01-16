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
local kernal = require("ui.widgets.kernal")
local shodan = require("ui.widgets.shodan")
local pkgs = require("ui.widgets.packages")
local pkg_updates = require("ui.widgets.updates")

local w = dpi(300)

local dashboard = wibox({
  visible = false,
  height = screen_height - beautiful.wibar_height,
  width = w,
  ontop = true,
  bg = beautiful.xbackground,
  fg = beautiful.xforeground,
  border_width = dpi(1),
  border_color = beautiful.xcolor0,
  type = "dock",
  screen = screen.primary,
})

local header = function(text, bar_color, text_color)
  local header_bar = wibox.widget({
    max_value = 100,
    value = 100,
    margins = dpi(12),
    forced_height = dpi(3),
    color = beautiful.xcolor8,
    background_color = beautiful.xcolor0,
    widget = wibox.widget.progressbar,
  })

  local header_text = wibox.widget({
    markup = "<span foreground='" .. beautiful.xforeground .. "'>" .. text .. "</span>",
    font = beautiful.font_name .. "18",
    align = "center",
    widget = wibox.widget.textbox,
  })

  return wibox.widget({
    {
      header_text,
      header_bar,
      layout = wibox.layout.align.vertical,
    },
    margins = dpi(20),
    widget = wibox.container.margin,
  })
end

function dashboard:toggle(screen)
  self.screen = screen
  self.visible = not self.visible
  awful.placement.top_left(self, { offset = { x = 0, y = 30 } })
end

dashboard:setup({
  shodan,
  -- header("USER", beautiful.xcolor8),
  {
    {
      {
        text = "gcc",
        markup = "<span foreground='" .. beautiful.xcolor8 .. "'>gcc</span>",
        font = beautiful.font_name .. "14",
        widget = wibox.widget.textbox,
      },
      kernal,
      pkgs,
      pkg_updates,
      layout = wibox.layout.fixed.vertical
    },
    left = dpi(30),
    widget = wibox.container.margin,
  },
  -- header("SYSTEM", beautiful.xcolor8),
  cpu,
  ram,
  temp,
  root,
  data,
  -- header("AUDIO", beautiful.xcolor8),
  -- header("WEATHER", beautiful.xcolor8),
  layout = wibox.layout.fixed.vertical,
})

return dashboard

-- EOF -------------------------------------------------------------------------
