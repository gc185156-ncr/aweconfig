local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

-- Bling Module
local bling = require("module.bling")

-- This is to slave windows' positions in floating layout
-- Not Mine
-- https://github.com/larkery/awesome/blob/master/savefloats.lua
require("module.savefloats")

-- Better mouse resizing on tiled
-- Nodt mine
-- https://github.com/larkery/awesome/blob/master/better-resize.lua
require("module.better-resize")

client.connect_signal("request::manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not c.size_hints.user_position and
        not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Give ST and icon
    if c.class == "st-256color" or c.class == "st-dialog" or c.class ==
        "st-float" or c.instance == "st-256color" then
        local new_icon = gears.surface(gfs.get_configuration_dir() ..
                                           "icons/ghosts/terminal.png")
        c.icon = new_icon._native
        --[[  elseif c.class == "discord" or c.instance == "discord" then
        local new_icon = gears.surface(gfs.get_configuration_dir() ..
                                           "icons/ghosts/discord.png")
        c.icon = new_icon._native]] --
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus",
                      function(c) c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus",
                      function(c) c.border_color = beautiful.border_normal end)

-- Set the layouts

tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile, awful.layout.suit.floating,
    })
end)

-- Layout List Widget ---------------------------------------------------------

-- List
local ll = awful.widget.layoutlist {
    source = awful.widget.layoutlist.source.default_layouts, -- DOC_HIDE
    spacing = dpi(24),
    base_layout = wibox.widget {
        spacing = dpi(24),
        forced_num_cols = 2,
        layout = wibox.layout.grid.vertical
    },
    widget_template = {
        {
            {
                id = 'icon_role',
                forced_height = dpi(68),
                forced_width = dpi(68),
                widget = wibox.widget.imagebox
            },
            margins = dpi(24),

            widget = wibox.container.margin
        },
        id = 'background_role',
        forced_width = dpi(68),
        forced_height = dpi(68),
        widget = wibox.container.background
    }
}

-- Popup
local layout_popup = awful.popup {
    widget = wibox.widget {
        {ll, margins = dpi(24), widget = wibox.container.margin},
        bg = beautiful.xbackground .. "cc",
        shape = helpers.rrect(beautiful.border_radius),
        border_color = beautiful.widget_border_color,
        border_width = beautiful.widget_border_width,
        widget = wibox.container.background
    },
    placement = awful.placement.centered,
    ontop = true,
    visible = false,
    bg = beautiful.bg_normal .. "00"
}

-- Key Bindings for Widget ----------------------------------------------------

-- Make sure you remove the default `Mod4+Space` and `Mod4+Shift+Space`
-- keybindings before adding this.
function gears.table.iterate_value(t, value, step_size, filter, start_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then return end

    step_size = step_size or 1
    local new_key = gears.math.cycle(#t, k + step_size)

    if filter and not filter(t[new_key]) then
        for i = 1, #t do
            local k2 = gears.math.cycle(#t, new_key + i)
            if filter(t[k2]) then return t[k2], k2 end
        end
        return
    end

    return t[new_key], new_key
end

awful.keygrabber {
    start_callback = function() layout_popup.visible = true end,
    stop_callback = function() layout_popup.visible = false end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
    keybindings = {
        {
            {modkey, "Shift"}, " ", function()
                awful.layout.set(gears.table.iterate_value(ll.layouts,
                                                           ll.current_layout, -1),
                                 nil)
            end
        }, {
            {modkey}, " ", function()
                awful.layout.set(gears.table.iterate_value(ll.layouts,
                                                           ll.current_layout, 1),
                                 nil)
            end
        }
    }
}

-- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
    local t = screen.primary.selected_tag
    if vis then
        for idx, c in ipairs(t:clients()) do c.hidden = true end
    else
        for idx, c in ipairs(t:clients()) do c.hidden = false end
    end
end)


-- Titlebar for floating windows ----------------------------------------------------
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
end)

client.connect_signal('property::maximized', function(c)
    setTitlebar(c, not c.maximized) 
end)

client.connect_signal('property::fullscreen', function(c)
    setTitlebar(c, not c.fullscreen) 
end)

client.connect_signal('manage', function(c)
    setTitlebar(c, c.floating or c.first_tag.layout == awful.layout.suit.floating)
    -- setTitlebar(c, c.first_tag.layout == awful.layout.suit.floating)
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

-- EOF ------------------------------------------------------------------------
