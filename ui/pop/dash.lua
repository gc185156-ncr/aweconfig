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

local panelWidget = wibox.widget {
    {cpu_widget, layout = wibox.layout.align.vertical},
    layout = wibox.layout.flex.horizontal
}

local dash_manager = {}
local dashboard = wibox({
    visible = false,
    ontop = true,
    type = "splash",
    screen = screen.primary
})
awful.placement.maximize(dashboard)
dashboard.bg = beautiful.exit_screen_bg or "#111111"
dashboard.fg = beautiful.exit_screen_fg or "#FEFEFE"

-- Add dash to each screen
awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.dash = dashboard
    else
        s.dash = helpers.screen_mask(s, beautiful.exit_screen_bg or
                                         beautiful.xbackground .. "80")
    end
end)

local function set_visibility(v) for s in screen do s.dash.visible = v end end

local dash_grabber

dash_manager.dash_hide = function()
    awful.keygrabber.stop(dash_grabber)
    set_visibility(false)
    awesome.emit_signal("widgets::splash::visibility", dashboard.visible)
end

dash_manager.dash_show = function()
    dash_grabber = awful.keygrabber.run(function(_, key, event)
        -- Ignore case
        key = key:lower()
        if event == "release" then return end
        if key == 'escape' or key == 'q' or key == 'x' then
            dash_manager.dash_hide()
        end
    end)
    set_visibility(true)
    awesome.emit_signal("widgets::splash::visibility", dashboard.visible)
end

dashboard:setup{
    nil,
    {nil, panelWidget, expand = "none", layout = wibox.layout.align.horizontal},
    expand = "none",
    layout = wibox.layout.align.vertical
}

return dash_manager
