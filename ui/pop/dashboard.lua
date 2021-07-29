-- panel.lua
-- Panel Widget
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

local dashboard = wibox({
    visible = false,
    height = 60,
    width = 500,
    y = 40,
    ontop = true,
    bg = beautiful.xbackground,
    fg = beautiful.xforeground,
    border_width = dpi(1),
    border_color = beautiful.xcolor0,
    type = "dock",
    screen = screen.primary
})

function dashboard:toggle(screen)
    self.screen = screen
    self.visible = not self.visible
    awful.placement.bottom_left(self)
end

dashboard:setup{
    layout = wibox.layout.align.vertical,
    nil,
    {
        wrap_widget(temp_text),
        wrap_widget(cpu_widget),
        wrap_widget(mem_widget),
        wrap_widget(fs_root_widget),
        wrap_widget(fs_widget),
        layout = wibox.layout.fixed.horizontal
    }
}

return dashboard

-- EOF -------------------------------------------------------------------------
