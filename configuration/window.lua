local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")
require("awful.autofocus")

-- Bling Module
local bling = require("module.bling")

-- This is to slave windows' positions in floating layout
-- Not Mine
-- https://github.com/larkery/awesome/blob/master/savefloats.lua
require("module.savefloats")

-- Better mouse resizing on tiled
-- Nodt mine
-- https://github.com/larkery/awesome/blob/master/better-resize.lua
require("module.better-resize")

client.connect_signal("request::manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  -- Custom icons --------------------------------------------------------------
  if c.class == "Alacritty" then
    local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/term.png")
    c.icon = new_icon._native  c.icon = new_icon._native
  elseif c.class == "Scratchpad" then
    local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/term.png")
    c.icon = new_icon._native  c.icon = new_icon._native
  elseif c.class == "slack" or c.instance == "slack" then
    local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/slack.png")
    c.icon = new_icon._native
  elseif c.class == "mumble" or c.instance == "mumble" then
    local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/mumble.png")
    c.icon = new_icon._native
  elseif c.class == "firefox" then
    local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/firefox.png")
    c.icon = new_icon._native
  -- elseif c.class == "discord" then
    -- local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/discord.png")
    -- c.icon = new_icon._native
  elseif c.class == "Steam" or c.instance == "steam" then
    local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/steam.png")
    c.icon = new_icon._native
  end
end)

-- Enable sloppy focus ------------------------------------------------------
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- Custom Layouts -------------------------------------------------------------
local deck = bling.layout.deck

-- Set the layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  deck,
}

-- Layout List Widget ---------------------------------------------------------

-- List
local ll = awful.widget.layoutlist({
  source = awful.widget.layoutlist.source.default_layouts, -- DOC_HIDE
  spacing = dpi(24),
  base_layout = wibox.widget({
    spacing = dpi(24),
    forced_num_cols = 5,
    layout = wibox.layout.grid.vertical,
  }),
  widget_template = {
    {
      {
        id = "icon_role",
        forced_height = dpi(68),
        forced_width = dpi(68),
        widget = wibox.widget.imagebox,
      },
      margins = dpi(24),

      widget = wibox.container.margin,
    },
    id = "background_role",
    forced_width = dpi(68),
    forced_height = dpi(68),
    widget = wibox.container.background,
  },
})

-- Popup
local layout_popup = awful.popup({
  widget = wibox.widget({
    { ll, margins = dpi(24), widget = wibox.container.margin },
    bg = beautiful.xbackground .. "cc",
    shape = helpers.rrect(beautiful.border_radius),
    border_color = beautiful.widget_border_color,
    border_width = beautiful.widget_border_width,
    widget = wibox.container.background,
  }),
  placement = awful.placement.centered,
  ontop = true,
  visible = false,
  bg = beautiful.bg_normal .. "00",
})

-- Key Bindings for Widget ----------------------------------------------------

-- Make sure you remove the default `Mod4+Space` and `Mod4+Shift+Space`
-- keybindings before adding this.
function gears.table.iterate_value(t, value, step_size, filter, start_at)
  local k = gears.table.hasitem(t, value, true, start_at)
  if not k then
    return
  end

  step_size = step_size or 1
  local new_key = gears.math.cycle(#t, k + step_size)

  if filter and not filter(t[new_key]) then
    for i = 1, #t do
      local k2 = gears.math.cycle(#t, new_key + i)
      if filter(t[k2]) then
        return t[k2], k2
      end
    end
    return
  end

  return t[new_key], new_key
end

awful.keygrabber({
  start_callback = function()
    layout_popup.visible = true
  end,
  stop_callback = function()
    layout_popup.visible = false
  end,
  export_keybindings = true,
  stop_event = "release",
  stop_key = { "Escape", "Super_L", "Super_R", "Mod4" },
  keybindings = {
    {
      { modkey, "Shift" },
      " ",
      function()
        awful.layout.set(gears.table.iterate_value(ll.layouts, ll.current_layout, -1), nil)
      end,
    },
    {
      { modkey },
      " ",
      function()
        awful.layout.set(gears.table.iterate_value(ll.layouts, ll.current_layout, 1), nil)
      end,
    },
  },
})

-- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
  local t = screen.primary.selected_tag
  if vis then
    for idx, c in ipairs(t:clients()) do
      c.hidden = true
    end
  else
    for idx, c in ipairs(t:clients()) do
      c.hidden = false
    end
  end
end)

-- EOF ------------------------------------------------------------------------
