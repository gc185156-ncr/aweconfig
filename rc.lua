-- rc.lua
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gfs = require("gears.filesystem")
local awful = require("awful")
local gears = require("gears")
local bling = require("module.bling")
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

-- Add a titlebar if titlebars_enabled is set to true in the rules.

local close = gears.surface.load_uncached(
                  gfs.get_configuration_dir() .. "icons/titlebar/close.png")

-- Import Daemons and Widgets
require("ui")
require("signals")

bling.widget.window_switcher.enable {
    type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews
    -- keybindings (the examples provided are also the default if kept unset)
    hide_window_switcher_key = "Escape", -- The key on which to close the popup
    minimize_key = "n",     -- The key on which to minimize the selected client
    unminimize_key = "N",   -- The key on which to unminimize all clients
    kill_client_key = "q",  -- The key on which to close the selected client
    cycle_key = "Tab",      -- The key on which to cycle through all clients
    previous_key = "Left",  -- The key on which to select the previous client
    next_key = "Right",     -- The key on which to select the next client
    vim_previous_key = "h", -- Alternative key on which to select the previous client
    vim_next_key = "l",     -- Alternative key on which to select the next client
}

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- EOF ------------------------------------------------------------------------
