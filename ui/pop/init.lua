local awful = require("awful")
local gears = require("gears")
local wibox = require "wibox"
local exit_manager = require(... .. ".exitscreen")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local awestore = require("awestore")
local dash_manager = require(... .. ".dash")

awesome.connect_signal("widgets::exit_screen::toggle",
                       function() exit_manager.exit_screen_show() end)

awesome.connect_signal("widgets::dashboard::show",
                       function() dash_manager.dash_show() end)

