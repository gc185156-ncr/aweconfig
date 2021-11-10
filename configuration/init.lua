local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local bling = require("module.bling")

-- Set Autostart Applications
require("configuration.autostart")

-- Default Applications
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " start " .. editor
browser = "firefox"
filemanager = terminal .. "-e ranger"
music = terminal .. " start --class music ncmpcpp"

-- Global Vars
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"
shift = "Shift"
ctrl = "Control"

-- Bling Tab Preview
bling.widget.tag_preview.enable({
  show_client_content = true,
  x = dpi(10),
  y = dpi(10) + beautiful.wibar_height,
  scale = 0.25,
  honor_padding = true,
  honor_workarea = false,
})

-- Bling Task Preview
-- bling.widget.task_preview.enable {
--     x = 20,                    -- The x-coord of the popup
--     y = 20,                    -- The y-coord of the popup
--     height = 200,              -- The height of the popup
--     width = 200,               -- The width of the popup
--     placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
--         awful.placement.top(c, {
--             margins = {
--                 top = 30
--             }
--         })
--     end
-- }

-- Bling Winow Switcher
bling.widget.window_switcher.enable({
  type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews
  -- keybindings (the examples provided are also the default if kept unset)
  hide_window_switcher_key = "Escape", -- The key on which to close the popup
  minimize_key = "n", -- The key on which to minimize the selected client
  unminimize_key = "N", -- The key on which to unminimize all clients
  kill_client_key = "q", -- The key on which to close the selected client
  cycle_key = "Tab", -- The key on which to cycle through all clients
  previous_key = "Left", -- The key on which to select the previous client
  next_key = "Right", -- The key on which to select the next client
  vim_previous_key = "h", -- Alternative key on which to select the previous client
  vim_next_key = "l", -- Alternative key on which to select the next client
})

screen.connect_signal("request::desktop_decoration", function(s)
  -- Screen padding
  screen[s].padding = { left = 0, right = 0, top = 0, bottom = 0 }

  -- Each screen has its own tag table.
  awful.tag({ "i", "ii", "iii", "iv", "v" }, s, awful.layout.layouts[1])
end)

-- Set Wallpaper
screen.connect_signal("request::wallpaper", function(s)
  gears.wallpaper.maximized(beautiful.wallpaper, s, false, nil)
end)

-- Get Keybinds
require("configuration.keys")

-- Get Rules
require("configuration.ruled")

-- Layouts, Titlebars, and other Window configs
require("configuration.window")

-- Scratchpad
require("configuration.scratchpad")
