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

-- LuaFormatter off
-- Add apps to autostart here
autostart_apps = {
    -- Xbinds for mouse
    "xbindkeys",

    -- Set Resolution
    "xrandr --output DisplayPort-1 --mode 2560x1440 --rate 143.86 --output DisplayPort-0 --mode 2560x1440 --rate 143.86 --right-of DisplayPort-1 --primary",

    -- Network Manager Applet
    "nm-applet",

    -- Redshift
    "redshift",

    -- Compositor
    "picom --experimental-backends --config " ..
        gears.filesystem.get_configuration_dir() .. "configuration/picom.conf",

    -- Lua Language Server
    "/home/gcc/.config/nvim/lua-language-server/bin/Linux/lua-language-server -E ./main.lua",

    -- Media controller daemon
    -- "playerctld daemon"
}

-- LuaFormatter on
for app = 1, #autostart_apps do run_once(autostart_apps[app]) end

-- EOF ------------------------------------------------------------------------
