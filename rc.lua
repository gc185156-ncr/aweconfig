-- rc.lua
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gfs = require("gears.filesystem")
local awful = require("awful")
local gears = require("gears")
-- Widget and layout library
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")


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

beautiful.init(gfs.get_configuration_dir() .. "theme/" .. "/theme.lua")

-- Import Configuration
require("configuration")

screen.connect_signal("request::desktop_decoration", function(s)
    -- Screen padding
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}

    -- Each screen has its own tag table.
    awful.tag({"i", "ii", "iii", "iv", "v"}, s, awful.layout.layouts[1])
end)

awful.rules.rules = {
    {rule_any = {type = {"dialog"}}, properties = {titlebars_enabled = true}}
}

-- Add a titlebar if titlebars_enabled is set to true in the rules.

local close = gears.surface.load_uncached(
                  gfs.get_configuration_dir() .. "icons/titlebar/close.png")

-- Import Daemons and Widgets
require("ui")
require("signals")

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- EOF ------------------------------------------------------------------------
