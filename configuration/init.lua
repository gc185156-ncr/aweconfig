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

-- Enable Bling Modules
bling.widget.tag_preview.enable({
  show_client_content = true,
  x = dpi(10),
  y = dpi(10) + beautiful.wibar_height,
  scale = 0.25,
  honor_padding = true,
  honor_workarea = false,
})

bling.widget.window_switcher.enable {
    type = "none", -- set to anything other than "thumbnail" to disable client previews
    vim_previous_key = "j",              -- Alternative key on which to select the previous client
    vim_next_key = "k",                  -- Alternative key on which to select the next client
}

-- bling.widget.app_launcher.enable 

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
