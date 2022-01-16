-- rc.lua
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome libraries
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local naughty = require("naughty")

require("awful.autofocus")
require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title = "Oops, an error happened" ..
            (startup and " during startup!" or "!"),
        message = message
    }
end)

beautiful.init(gfs.get_configuration_dir() .. "theme.lua")

-- Import Configuration
require("configuration")

-- Import Daemons and Widgets
require("ui")
require("signals")

client = client 
screen = screen
awesome = awesome
mouse = mouse

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- EOF ------------------------------------------------------------------------
