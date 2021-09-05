-- keys.lua
-- Contains Global Keys
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require("helpers")
-- Custom modules
local bling = require("module.bling")
local dashboard = require("ui.pop.dashboard")

-- Client and Tabs Bindings
awful.keyboard.append_global_keybindings({
    -- Change window focus
    awful.key({modkey}, "Down", function()
        awful.client.focus.bydirection("down")
        bling.module.flash_focus.flashfocus(client.focus)
    end, {description = "focus down", group = "client"}),

    awful.key({modkey}, "Up", function()
        awful.client.focus.bydirection("up")
        bling.module.flash_focus.flashfocus(client.focus)
    end, {description = "focus up", group = "client"}),

    awful.key({modkey}, "Left", function()
        awful.client.focus.bydirection("left")
        bling.module.flash_focus.flashfocus(client.focus)
    end, {description = "focus left", group = "client"}),

    awful.key({modkey}, "Right", function()
        awful.client.focus.bydirection("right")
        bling.module.flash_focus.flashfocus(client.focus)
    end, {description = "focus right", group = "client"}), -- Swap/move window
    awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({modkey, "Shift"}, "k",
              function() awful.client.swap.byidx(-1) end, {
        description = "swap with previous client by index",
        group = "client"
    }), -- Swap to urgent tag
    awful.key({modkey}, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"})
})

-- Awesomewm
awful.keyboard.append_global_keybindings({
    awful.key({}, "XF86AudioRaiseVolume",
              function() awful.spawn("pamixer -i 3") end,
              {description = "increase volume", group = "awesome"}),
    awful.key({}, "XF86AudioLowerVolume",
              function() awful.spawn("pamixer -d 3") end,
              {description = "decrease volume", group = "awesome"}),
    awful.key({}, "XF86AudioMute", function() awful.spawn("pamixer -t") end,
              {description = "mute volume", group = "awesome"}), -- Media Control
    awful.key({}, "XF86AudioPlay", function() awful.spawn("mpc toggle") end,
              {description = "toggle mpd play/pause", group = "awesome"}),
    awful.key({}, "XF86AudioPrev", function() awful.spawn("mpc prev") end,
              {description = "mpd previous track", group = "awesome"}),
    awful.key({}, "XF86AudioNext", function() awful.spawn("mpd next") end,
              {description = "mpd next track", group = "awesome"}),

    -- Screen Shots/Vids
    awful.key({}, "Print", function()
        awful.spawn.with_shell(gears.filesystem.get_configuration_dir() ..
                                   "scripts/shoot")
    end, {description = "take a screenshot", group = "awesome"}),
    awful.key({modkey}, "Print", function()
        awful.spawn.with_shell(gears.filesystem.get_configuration_dir() ..
                                   "scripts/shoot selnp")
    end, {description = "take a selection with no pads", group = "awesome"}),
    awful.key({modkey, "Shift"}, "Print", function()
        awful.spawn.with_shell(gears.filesystem.get_configuration_dir() ..
                                   "scripts/shoot sel")
    end, {description = "take a selection with pads", group = "awesome"}),

    -- Awesome stuff
    awful.key({modkey}, "F1", hotkeys_popup.show_help,
              {description = "show help", group = "awesome"}),

    awful.key({modkey}, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({modkey}, "x", function()
        awesome.emit_signal("widgets::exit_screen::toggle")
    end, {description = "show exit screen", group = "awesome"}),

    awful.key({modkey, "Control"}, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({modkey, "Shift"}, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({modkey, shift}, "d",
              function() dashboard:toggle(mouse.screen) end,
              {description = "show panel", group = "awesome"})
})

-- Launcher and screen
awful.keyboard.append_global_keybindings({

    -- Show Dropdown Term
    awful.key({modkey}, "`",
              function() awesome.emit_signal("scratch::term") end, {
        description = "Toggle terminal scratchpad",
        group = "Scratchpad"
    }), -- Show Music Controller
    awful.key({modkey}, "p",
              function() awesome.emit_signal("scratch::music") end, {}),

    -- Show Launcher
    awful.key({modkey}, "d", function() awful.spawn(launcher) end,
              {description = "show rofi ", group = "launcher"}),

    -- Show Game Launcher
    awful.key({modkey}, "g", function() awful.spawn(games) end,
              {description = "show rofi ", group = "launcher"}),

    -- Change Monitor Focus
    awful.key({modkey, "Shift"}, "Tab",
              function() awful.screen.focus_relative(1) end,
              {description = "focus the next screen", group = "screen"}),

    -- Alt Tab
--     awful.key({"Mod1"}, "Tab", function()
--         switcher.switch(1, "Mod1", "Alt_L", "Shift", "Tab")
--         bling.module.flash_focus.flashfocus(client.focus)
--     end), awful.key({"Mod1", "Shift"}, "Tab", function()
--         switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
--         bling.module.flash_focus.flashfocus(client.focus)
--     end), -- Switch Layout
--
    awful.key({modkey}, "Tab", function() awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),

    -- Open Terminal
    awful.key({modkey}, "t", function() awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({modkey, shift}, "t", function()
        awful.spawn.easy_async_with_shell(
            "slop -b 2 -c '0.61,0.9,0.75,1' -p -2", function(out)
                local mywidth, myheight, myx, myy = string.match(out,
                                                                 "(.*)x(.*)+(.*)+(.*)")

                awful.spawn(terminal, {
                    geometry = {
                        x = myx,
                        y = myy,
                        height = myheight,
                        width = mywidth
                    },
                    floating = true
                })

            end)
    end, {description = "open a terminal", group = "launcher"}),

    -- Open File Manager
    awful.key({modkey}, "r", function() awful.spawn(filemanager) end,
              {description = "open file browser", group = "launcher"}),

    -- Open Firefox
    awful.key({modkey}, "w", function() awful.spawn.with_shell(browser) end,
              {description = "open firefox", group = "launcher"}),

    -- Resize Windows
    awful.key({modkey}, "l", function() awful.tag.incmwfact(0.05) end,
              {description = "increase master width factor", group = "layout"}),

    awful.key({modkey}, "h", function() awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),

    awful.key({modkey, "Shift"}, "h",
              function() awful.tag.incnmaster(1, nil, true) end, {
        description = "increase the number of master clients",
        group = "layout"
    }), awful.key({modkey, "Shift"}, "l",
                  function() awful.tag.incnmaster(-1, nil, true) end, {
        description = "decrease the number of master clients",
        group = "layout"
    }), awful.key({modkey, "Control"}, "h",
                  function() awful.tag.incncol(1, nil, true) end, {
        description = "increase the number of columns",
        group = "layout"
    }), awful.key({modkey, "Control"}, "l",
                  function() awful.tag.incncol(-1, nil, true) end, {
        description = "decrease the number of columns",
        group = "layout"
    }), awful.key({modkey, "Shift"}, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
    end, {description = "restore minimized", group = "client"})
})

-- Client management keybinds
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({

        -- Fullscreen Window
        awful.key({modkey}, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, {description = "toggle fullscreen", group = "client"}),

        -- Kill Window
        awful.key({modkey}, "q", function(c) c:kill() end,
                  {description = "close", group = "client"}),

        -- Move window to other monitor
        awful.key({modkey}, "a", function(c) c:move_to_screen() end,
                  {description = "move to screen", group = "client"}),

        -- Toggle sticky window
        awful.key({modkey, shift}, "b", function(c)
            c.floating = not c.floating
            c.width = 400
            c.height = 200
            awful.placement.bottom_right(c)
            c.sticky = not c.sticky
        end, {description = "toggle keep on top", group = "client"}),

        -- Minimize Window
        awful.key({modkey}, "n", function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, {description = "minimize", group = "client"}), -- Maximize Window
        awful.key({modkey}, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, {description = "(un)maximize", group = "client"}),

        -- On the fly useless gaps change
        awful.key({modkey}, "=", function() helpers.resize_gaps(5) end),
        awful.key({modkey}, "-", function() helpers.resize_gaps(-5) end), -- Single tap: Center client

        -- Double tap: Center client + Floating + Resize
        awful.key({modkey}, "c", function(c)
            awful.placement.centered(c, {
                honor_workarea = true,
                honor_padding = true
            })
            helpers.single_double_tap(nil, function()
                helpers.float_and_resize(c, screen_width * 0.25,
                                         screen_height * 0.28)
            end)
        end)
    })
end)

-- Num row keybinds
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers = {modkey},
        keygroup = "numrow",
        description = "only view tag",
        group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then tag:view_only() end
        end
    }, awful.key {
        modifiers = {modkey, "Control"},
        keygroup = "numrow",
        description = "toggle tag",
        group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then awful.tag.viewtoggle(tag) end
        end
    }, awful.key {
        modifiers = {modkey, "Shift"},
        keygroup = "numrow",
        description = "move focused client to tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:move_to_tag(tag) end
            end
        end
    }, awful.key {
        modifiers = {modkey, "Control", "Shift"},
        keygroup = "numrow",
        description = "toggle focused client on tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:toggle_tag(tag) end
            end
        end
    }, awful.key {
        modifiers = {modkey},
        keygroup = "numpad",
        description = "select layout directly",
        group = "layout",
        on_press = function(index)
            local t = awful.screen.focused().selected_tag
            if t then t.layout = t.layouts[index] or t.layout end
        end
    }
})

-- Mouse Bindings
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate{context = "mouse_click"}
        end), awful.button({modkey}, 1, function(c)
            c:activate{context = "mouse_click", action = "mouse_move"}
        end), awful.button({modkey}, 3, function(c)
            c:activate{context = "mouse_click", action = "mouse_resize"}
        end), awful.button({}, 6, function() awful.spawn("mpc volume -3") end,
                           {description = "lower music volume"}),
        awful.button({}, 7, function() awful.spawn("mpc volume +3") end,
                     {description = "raise music volume"})
    })
end)

-- EOF ------------------------------------------------------------------------
