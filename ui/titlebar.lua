local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

-- Add a `titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  local function create_title_button(color_focus, img)
    local tb = wibox.widget({
      {
        {
          image = img,
          forced_width = dpi(10),
          forced_height = dpi(10),
          widget = wibox.widget.imagebox,
        },
        margins = dpi(5),
        widget = wibox.container.margin
      },
      forced_width = dpi(20),
      widget = wibox.container.background,
    })

    tb:connect_signal("mouse::enter", function()
      tb.bg = color_focus .. 55
    end)
    tb:connect_signal("mouse::leave", function()
      tb.bg = beautiful.xbackground .. "00"
    end)

    tb.visible = true
    return tb
  end

  local close_button = beautiful.icon_path .. "close.png"
  local close_icon = gears.color.recolor_image(close_button, beautiful.xcolor9)
  local close = create_title_button(beautiful.xcolor8, close_icon)
  close:connect_signal("button::press", function()
    c:kill()
  end)

  local last_left_click
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      if os.time() - (last_left_click or 0) < 1 then
        -- Assume to be double click
        c.maximized = not c.maximized
      else
        awful.mouse.client.move(c)
      end
      last_left_click = os.time()
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup({
    {
      helpers.horizontal_pad(4),
      {
        awful.titlebar.widget.iconwidget(c),
        top = dpi(2),
        bottom = dpi(2),
        widget = wibox.container.margin,
      },
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    {
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    {
      close,
      layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.align.horizontal,
  })
end)
