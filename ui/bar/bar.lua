-- wibar.lua
-- Wibar (top bar)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local vicious = require("vicious")

-- Seperator -----------------------------------------------------------------

local sep = wibox.widget {
    {color = beautiful.xcolor8, text = "::", widget = wibox.widget.textbox},
    bottom = dpi(3),
    widget = wibox.container.margin
}

-- CPU Widget ----------------------------------------------------------------
local cpu_text = wibox.widget.textbox()
-- vicious.cache(vicious.widgets.cpu)
vicious.register(cpu_text, vicious.widgets.cpu, " $1%", 3)

cpu_text.markup = "<span foreground'" .. beautiful.xcolor13 .. "'>" ..
                      cpu_text.text .. "</span>"

cpu_text:connect_signal("widget::redraw_needed", function()
    cpu_text.markup = "<span foreground='" .. beautiful.xcolor13 .. "'>" ..
                          cpu_text.text .. "</span>"
end)

local cpu_icon = wibox.widget {
    font = beautiful.icon_font_name .. "16",
    markup = "<span foreground='" .. beautiful.xcolor13 .. "'></span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local cpu_widget = wibox.widget {
    {
        {cpu_icon, top = dpi(1), widget = wibox.container.margin},
        helpers.horizontal_pad(3),
        {cpu_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    bottom = dpi(2),
    widget = wibox.container.margin
}

-- Memory Widget -------------------------------------------------------------
local mem_text = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(mem_text, vicious.widgets.mem, " $2MiB", 3)

mem_text.markup = "<span foreground='" .. beautiful.xcolor13 .. "'>" ..
                      mem_text.text .. "</span>"

mem_text:connect_signal("widget::redraw_needed", function()
    mem_text.markup = "<span foreground='" .. beautiful.xcolor13 .. "'>" ..
                          mem_text.text .. "</span>"
end)

local mem_icon = wibox.widget {
    font = beautiful.icon_font_name .. "16",
    markup = "<span foreground='" .. beautiful.xcolor13 .. "'></span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local mem_widget = wibox.widget {
    {
        {mem_icon, top = dpi(1), widget = wibox.container.margin},
        helpers.horizontal_pad(3),
        {mem_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    bottom = dpi(2),
    widget = wibox.container.margin
}

-- FS Data Widget ------------------------------------------------------------------
local fs_text = wibox.widget.textbox()
vicious.register(fs_text, vicious.widgets.fs, " data ${/data avail_gb}GiB", 5)

fs_text.markup = "<span foreground='" .. beautiful.xcolor12 .. "'>" ..
                     fs_text.text .. "</span>"

fs_text:connect_signal("widget::redraw_needed", function()
    fs_text.markup = "<span foreground='" .. beautiful.xcolor12 .. "'>" ..
                         fs_text.text .. "</span>"
end)

local fs_icon = wibox.widget {
    font = beautiful.icon_font_name .. "18",
    markup = "<span foreground='" .. beautiful.xcolor12 .. "'></span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local fs_widget = wibox.widget {
    {
        {fs_icon, top = dpi(2), widget = wibox.container.margin},
        helpers.horizontal_pad(3),
        {fs_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    bottom = dpi(2),
    widget = wibox.container.margin
}

-- FS Root Widget ------------------------------------------------------------------
local fs_root_text = wibox.widget.textbox()
vicious.register(fs_root_text, vicious.widgets.fs, " root ${/ avail_gb}GiB", 5)

fs_root_text.markup = "<span foreground='" .. beautiful.xcolor12 .. "'>" ..
                          fs_root_text.text .. "</span>"

fs_root_text:connect_signal("widget::redraw_needed", function()
    fs_root_text.markup = "<span foreground='" .. beautiful.xcolor12 .. "'>" ..
                              fs_root_text.text .. "</span>"
end)

local fs_root_icon = wibox.widget {
    font = beautiful.icon_font_name .. "18",
    markup = "<span foreground='" .. beautiful.xcolor12 .. "'></span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local fs_root_widget = wibox.widget {
    {
        {fs_root_icon, top = dpi(2), widget = wibox.container.margin},
        helpers.horizontal_pad(3),
        {fs_root_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    bottom = dpi(2),
    widget = wibox.container.margin
}

-- Updates Widget -------------------------------------------------------------
local updates_text = wibox.widget.textbox()
vicious.cache(vicious.widgets.pkg)
vicious.register(updates_text, vicious.widgets.pkg, " $1", 100, 'Arch')

updates_text.markup = "<span foreground='" .. beautiful.xcolor11 .. "'>" ..
                          updates_text.text .. "</span>"

updates_text:connect_signal("widget::redraw_needed", function()
    updates_text.markup = "<span foreground='" .. beautiful.xcolor11 .. "'>" ..
                              updates_text.text .. "</span>"
end)

local updates_icon = wibox.widget {
    font = beautiful.icon_font_name .. "16",
    markup = "<span foreground='" .. beautiful.xcolor11 .. "'></span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local updates_widget = wibox.widget {
    {
        {updates_icon, top = dpi(1), widget = wibox.container.margin},
        helpers.horizontal_pad(3),
        {updates_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    bottom = dpi(2),
    widget = wibox.container.margin
}

-- Time Widget ----------------------------------------------------------------

local time_text = wibox.widget {
    font = beautiful.font,
    format = "%b %d, %T",
    align = "center",
    valign = "center",
    refresh = 1,
    widget = wibox.widget.textclock
}

time_text.markup = "<span foreground='" .. beautiful.xcolor8 .. "'>" ..
                       time_text.text .. "</span>"

time_text:connect_signal("widget::redraw_needed", function()
    time_text.markup = "<span foreground='" .. beautiful.xcolor8 .. "'>" ..
                           time_text.text .. "</span>"
end)

local time_icon = wibox.widget {
    font = beautiful.icon_font_name .. "17",
    markup = "<span foreground='" .. beautiful.xcolor12 .. "'></span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local time_pill = wibox.widget {
    {
        -- {time_icon, top = dpi(1), widget = wibox.container.margin},
        -- helpers.horizontal_pad(10),
        {time_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    bottom = dpi(2),
    widget = wibox.container.margin
}

-- Systray Widget -------------------------------------------------------------

local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    left = dpi(8),
    right = dpi(8),
    widget = wibox.container.margin
}

-- Tasklist Buttons -----------------------------------------------------------

local tasklist_buttons = gears.table.join(
                             awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end), awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                             awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

-- Create the Wibar -----------------------------------------------------------

local final_systray = wibox.widget {
    {
        mysystray_container,
        top = dpi(9),
        botto = dpi(4),
        left = dpi(4),
        right = dpi(4),
        layout = wibox.container.margin
    },
    bg = beautiful.xcolor0,
    -- shape = helpers.rrect(beautiful.border_radius),
    widget = wibox.container.background
}

local wrap_widget = function(w)
    local wrapped = wibox.widget {
        w,
        top = dpi(5),
        left = dpi(3),
        bottom = dpi(5),
        right = dpi(3),
        widget = wibox.container.margin
    }
    return wrapped
end

local make_pill = function(w, c)
    local pill = wibox.widget {
        w,
        bg = c,
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox.container.background
    }
    return pill
end

screen.connect_signal("request::desktop_decoration", function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        type = "dock",
        ontop = true
    })

    -- Remove wibar on full screen
    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = false
        else
            c.screen.mywibox.visible = true
        end
    end

    -- Remove wibar on full screen
    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = true
        end
    end

    -- Hide bar when a splash widget is visible
    awesome.connect_signal("widgets::splash::visibility", function(vis)
        screen.primary.mywibox.visible = not vis
    end)

    client.connect_signal("property::fullscreen", remove_wibar)

    client.connect_signal("request::unmanage", add_wibar)

    -- Create the taglist widget
    s.mytaglist = require("ui.widgets.taglist")(s)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons,
        bg = beautiful.wibar_bg,
        style = {
            bg = beautiful.xcolor0,
            shape = helpers.rrect(beautiful.border_radius)
        },
        layout = {spacing = dpi(8), layout = wibox.layout.fixed.horizontal},
        widget_template = {
            {
                {
                    {id = 'text_role', widget = wibox.widget.textbox},
                    layout = wibox.layout.fixed.horizontal
                },
                top = dpi(3),
                bottom = dpi(3),
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background
        }
    }

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.vertical,
        nil,
        {
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                {
                    layout = wibox.layout.fixed.horizontal,
                    s.mytaglist,
                    wrap_widget(sep),
                    wrap_widget(s.mytasklist)
                },
                {wrap_widget(time_pill), widget = wibox.container.constraint},
                {
                    awful.widget.only_on_screen(final_systray, screen[1]),
                    wrap_widget({
                        s.mylayoutbox,
                        top = dpi(4),
                        bottom = dpi(4),
                        right = dpi(4),
                        left = dpi(6),
                        widget = wibox.container.margin
                    }),
                    helpers.horizontal_pad(4),
                    layout = wibox.layout.fixed.horizontal
                }
            },
            widget = wibox.container.background,
            bg = beautiful.xcolor0 .. "00"
        },
        { -- This is for a bottom border in the bar
            widget = wibox.container.background,
            bg = beautiful.xcolor0,
            forced_height = beautiful.widget_border_width
        }
    }
end)

-- EOF ------------------------------------------------------------------------
