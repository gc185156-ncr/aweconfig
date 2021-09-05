local awful = require("awful")
local bling = require("module.bling")

local function check_if_alive(cmd)
    awful.spawn.easy_async_with_shell("pgrep -u $USER -x " .. cmd,
                                      function(stdout, stderr, reason, exit_code)
        if exit_code == 1 then awful.spawn(cmd) end
    end)
end

local music_control = bling.module.scratchpad:new{
    command = "alacritty --class=ncmpcpp --command ncmpcpp",
    rule = {instance = "ncmpcpp"},
    sticky = true,
    autoclose = true,
    titlebars_enabled = false,
    floating = true,
    geometry = {x = 500, y = 920, height = 500, width = 1600},
    reapply = true,
    dont_focus_before_close = false,
}

awesome.connect_signal("scratch::music", function() music_control:toggle() end)

local quake_term = bling.module.scratchpad:new{
    command = "alacritty --class=quake",
    rule = {instance = "quake"},
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = {x = 20, y = 50, height = 600, width = 2520},
    reapply = true,
    dont_focus_before_close = false,
}

awesome.connect_signal("scratch::term", function() quake_term:toggle() end)
