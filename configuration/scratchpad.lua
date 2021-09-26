local awful = require("awful")
local bling = require("module.bling")

local function check_if_alive(cmd)
    awful.spawn.easy_async_with_shell("pgrep -u $USER -x " .. cmd,
                                      function(stdout, stderr, reason, exit_code)
        if exit_code == 1 then awful.spawn(cmd) end
    end)
end

local music_control = bling.module.scratchpad:new{
    command = "alacritty --title music --class ncmpcpp,Scratchpad --command ncmpcpp",
    rule = {instance = "ncmpcpp"},
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = {x = 500, y = 915, height = 500, width = 1600},
    reapply = true,
    dont_focus_before_close = false,
}

awesome.connect_signal("scratch::music", function() music_control:toggle() end)

local drop_term = bling.module.scratchpad:new{
    command = "alacritty --title term --class drop_term,Scratchpad",
    rule = {instance = "drop_term"},
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = {x = 20, y = 50, height = 600, width = 2520},
    reapply = true,
    dont_focus_before_close = false,
}

awesome.connect_signal("scratch::term", function() drop_term:toggle() end)


local launcher = bling.module.scratchpad:new{
    command = "alacritty --title launcher --class launcher,Scratchpad -e /home/gcc/.config/awesome/scripts/launcher.sh",
    rule = {instance = "launcher"},
    sticky = true,
    autoclose = false,
    floating = true,
    geometry = {x = 880, y = 420, height = 600, width = 800},
    reapply = true,
    dont_focus_before_close = true,
}

awesome.connect_signal("scratch::launcher", function() launcher:toggle() end)


local games = bling.module.scratchpad:new{
    command = "alacritty --title games --class games,Scratchpad -e /home/gcc/.config/awesome/scripts/games-launcher.sh",
    rule = {instance = "games"},
    sticky = true,
    autoclose = false,
    floating = true,
    geometry = {x = 880, y = 420, height = 600, width = 800},
    reapply = true,
    dont_focus_before_close = true,
}

awesome.connect_signal("scratch::games", function() games:toggle() end)


