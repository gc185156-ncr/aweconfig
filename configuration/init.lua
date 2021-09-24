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

-- Toggle titlebar on or off depending on s. Creates titlebar if it doesn't exist
local function setTitlebar(client, s)
    if s then
        if client.titlebar == nil then
            client:emit_signal('request::titlebars', 'rules', {})
        end
        awful.titlebar.show(client)
    else
        awful.titlebar.hide(client)
    end

    -- These clients should never have titlebars
    if client.maximized or (client.class == "Scratchpad" or client.class == "Steam") then
      awful.titlebar.hide(client)
    end
end

-- Toggle titlebar on floating status change
client.connect_signal('property::floating', function(c)
    setTitlebar(c, c.floating)

    -- if c.class == "Scratchpad" or c.class == "Steam" then
    --    setTitlebar(c, false)
    -- end
end)

client.connect_signal('manage', function(c)
    setTitlebar(c, c.floating or c.first_tag.layout == awful.layout.suit.floating)
end)

-- Show titlebars on tags with the floating layout
tag.connect_signal('property::layout', function(t)
-- New to Lua ?
-- pairs iterates on the table and return a key value pair
-- I don't need the key here, so I put _ to ignore it
    for _, c in pairs(t:clients()) do
        if t.layout == awful.layout.suit.floating then
            setTitlebar(c, true)
        else
            setTitlebar(c, false)
        end
    end
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
