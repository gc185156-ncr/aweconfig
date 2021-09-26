local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)

  local close = gears.surface.load_uncached(
                      gfs.get_configuration_dir() .. "icons/titlebar/close.png")
  local close_icon = gears.color.recolor_image(close, beautiful.xcolor6)
  local remove = gears.surface.load_uncached(
                    gfs.get_configuration_dir() .. "icons/titlebar/remove.png")
  local min_icon = gears.color.recolor_image(remove, beautiful.xcolor8)
  local arrow = gears.surface.load_uncached(
                      gfs.get_configuration_dir() .. "icons/titlebar/up-arrow.png")
  local max_icon = gears.color.recolor_image(arrow, beautiful.xcolor3)

  local function create_title_button(c, color_focus, color_unfocus, img)
    local tb = wibox.widget {
      {
        forced_width = dpi(16),
        forced_height = dpi(16),
        bg = color_focus,
        image = img,
        widget = wibox.widget.imagebox
      },
      top = dpi(4),
      widget = wibox.container.margin
    }

    local function update()
      if client.focus == c then
        tb.image = gears.color.recolor_image(img, color_focus)
      else
        tb.image = gears.color.recolor_image(img, color_unfocus)
        end
    end
    update()

    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)
    tb:connect_signal("mouse::enter", function() tb.image = gears.color.recolor_image(img, color_focus) end)
    tb:connect_signal("mouse::leave", function() tb.image = gears.color.recolor_image(img, color_unfocus) end)
    tb.visible = true
    return tb
  end

  local ci = function(width, height)
    return function(cr) gears.shape.circle(cr, width, height) end
  end

  local close = create_title_button(c, beautiful.xcolor1,
                                    beautiful.xcolor0 .. "55", close_icon)
  close:connect_signal("button::press", function() c:kill() end)
  local min = create_title_button(c, beautiful.xcolor3,
                                  beautiful.xcolor0 .. "55", min_icon)
  min:connect_signal("button::press", function() c.minimized = true end)
  local max = create_title_button(c, beautiful.xcolor4,
                                  beautiful.xcolor0 .. "55", max_icon)
  max:connect_signal("button::press",
                     function() c.maximized = not c.maximized end)
  -- buttons for the titlebar
  local buttons = gears.table.join(
      awful.button({ }, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
      end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            helpers.horizontal_pad(5),
            {
              align  = "center",
              widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                min,
                helpers.horizontal_pad(10),
                max,
                helpers.horizontal_pad(10),
                close,
                layout = wibox.layout.flex.horizontal
            },
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

