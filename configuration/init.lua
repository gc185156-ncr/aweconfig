local awful = require("awful")
local gears = require('gears')
local gfs = gears.filesystem
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local bling = require('module.bling')

-- Set Autostart Applications
require("configuration.autostart")

-- Default Applications
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " start " .. editor
browser = "firefox"
filemanager = "alacritty -e ranger"
discord = "discord"
music = terminal .. ' start --class music ncmpcpp'

-- Global Vars
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"
shift = "Shift"
ctrl = "Control"

local yy = 10 + beautiful.wibar_height

-- Bling Tab Preview
bling.widget.tag_preview.enable {
    show_client_content = true,
    x = dpi(10),
    y = dpi(10) + beautiful.wibar_height,
    scale = 0.25,
    honor_padding = true,
    honor_workarea = false
}

-- Set Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s, false, nil)
end)

-- Get Keybinds
require("configuration.keys")

-- Get Rules
--
require("configuration.ruled")

-- Layouts and Window Stuff
require("configuration.window")

-- Scratchpad
require("configuration.scratchpad")
