-- autostart.lua
-- Autostart Stuff Here
local awful = require("awful")
local gears = require("gears")

local function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(' ')
    if firstspace then findme = cmd:sub(0, firstspace - 1) end
    awful.spawn.easy_async_with_shell(string.format(
                                          'pgrep -u $USER -x %s > /dev/null || (%s)',
                                          findme, cmd))
end

-- Add apps to autostart here
autostart_apps = {

    "xrandr --output DisplayPort-1 --mode 2560x1440 --rate 143.86 --output DisplayPort-0 --mode 2560x1440 --rate 143.86 --right-of DisplayPort-1 --primary",
    "redshift", "setxkbmap -option caps:escape",
    "[ ! -s ~/.config/mpd/pid ] && mpd ~/.config/mpd/mpd.conf",
    "[[ -z $(pgrep -xU $UID mpdas) ]] && mpdas"
}

for app = 1, #autostart_apps do run_once(autostart_apps[app]) end

-- EOF ------------------------------------------------------------------------
