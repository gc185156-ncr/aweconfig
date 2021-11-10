-- autostart.lua
-- Autostart Stuff Here
local awful = require("awful")

local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.easy_async_with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

-- Add apps to autostart here
autostart_apps = {

  -- Set Resolution
  "xrandr --output DisplayPort-1 --mode 2560x1440 --rate 143.86 --output DisplayPort-0 --mode 2560x1440 --rate 143.86 --right-of DisplayPort-1 --primary",
  -- Redshift
  "redshift",
  -- Netowrk Tray Icon
  "nm-applet",
  -- Remap Capslock
  "setxkbmap -option caps:escape",
  -- Compositor
  -- "pgrep -x picom && killall picom || picom -b --experimental-backends --config ~/.config/picom/picom.conf",
  -- MPD
  "[ ! -s ~/.config/mpd/pid ] && mpd ~/.config/mpd/mpd.conf",
  -- MPDAS
  "[[ -z $(pgrep -xU $UID mpdas) ]] && mpdas",
}

for app = 1, #autostart_apps do
  run_once(autostart_apps[app])
end

-- EOF ------------------------------------------------------------------------
