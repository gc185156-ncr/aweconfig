local awful = require("awful")
local bling = require("module.bling")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local awestore = require("awestore")
local helpers = require("helpers")

local function check_if_alive(cmd)
    awful.spawn.easy_async_with_shell("pgrep -u $USER -x " .. cmd,
                                      function(stdout, stderr, reason, exit_code)
        if exit_code == 1 then awful.spawn(cmd) end
    end)
end

local anim_x = awestore.tweened (-1010, {
    duration = 200,
    easing = awestore.easing.cubic_in_out

})-- Dropdown term
local top_drawer = awestore.tweened(-700, {
    duration = 200,
    easing = awestore.easing.cubic_in_out
})

local bottom_drawer = awestore.tweened(2140), {
    duration = 200,
    easing = awestore.easing.cubic_in_out
}

local music_control = bling.module.scratchpad:new {
    command = "alacritty --class=ncmpcpp --command ncmpcpp",
    rule = { instance = "ncmpcpp" },
    sticky = true,
    autoclose = true,
    titlebars_enabled = false,
    floating = true,
    geometry = {x=12, y=730, height=700, width=2536},
    reapply = true,
    dont_focus_before_close = false,
    awestore = {y = bottom_drawer}
}

awesome.connect_signal("scratch::music", function()
    music_control:toggle()
end)

local quake_term = bling.module.scratchpad:new {
    command = "alacritty --class=quake",
    rule = { instance = "quake" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = {x=12, y=38, height=700, width=2536},
    reapply = true,
    dont_focus_before_close  = false,
    awestore = {y = top_drawer}
}

awesome.connect_signal("scratch::term", function()
    quake_term:toggle()
end)