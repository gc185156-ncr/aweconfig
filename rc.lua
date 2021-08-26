-- rc.lua
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gfs = require("gears.filesystem")
local awful = require("awful")
local gears = require("gears")
-- Widget and layout library
local wibox = require("wibox")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

local switcher = require("module.awesome-switcher")

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
    {rule_any = {type = {"dialog"}}, properties = {titlebars_enabled = false}}
}

-- Add a titlebar if titlebars_enabled is set to true in the rules.

local close = gears.surface.load_uncached(
                  gfs.get_configuration_dir() .. "icons/titlebar/close.png")
--[[ client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(awful.button({}, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
    end))

    awful.titlebar(c):setup{
        { -- Left
            -- awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            -- awful.titlebar.widget.floatingbutton(c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton(c),
            -- awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end) ]]

--[[ awful.hooks.property.register(function(c, prop)
    -- Remove the titlebar if fullscreen
    if c.fullscreen then
        awful.titlebar.remove(c)
    elseif not c.fullscreen then
        -- Add title bar for floating apps
        if c.titlebar == nil and awful.client.floating.get(c) then
            awful.titlebar.add(c, {modkey = modkey})
            -- Remove title bar, if it's not floating
        elseif c.titlebar and not awful.client.floating.get(c) then
            awful.titlebar.remove(c)
        end
    end
end) ]]

-- Import Daemons and Widgets
require("ui")
require("signals")

awful.spawn.with_shell("~/.screenlayout/layout.sh")

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- EOF ------------------------------------------------------------------------
