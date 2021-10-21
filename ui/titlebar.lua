local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")


local function create_title_button(c, color_focus, color_unfocus, img)
  local tb_icon = {
     forced_width = dpi(16),
     forced_height = dpi(16),
     bg = color_focus,
     image = img,
     widget = wibox.widget.imagebox
  }
  local tb = wibox.widget {
    tb_icon,
    top = dpi(4),
    widget = wibox.container.margin
  }
  tb.visible = true
  local function update()
    if client.focus == c then
      tb.bg = color_focus
    else
      tb.bg = color_unfocus
    end
  end
  update()

  c:connect_signal("focus", update)
  c:connect_signal("unfocus", update)
  tb:connect_signal("mouse::enter", function() tb.bg = color_focus .. 55 end)
  tb:connect_signal("mouse::leave", function() tb.bg = color_focus end)

  tb.visible = true
  return tb
end

-- Add a `titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  local function create_title_button(c, color_focus, color_unfocus, img)
    local tb_icon = {
       forced_width = dpi(16),
       forced_height = dpi(16),
       bg = color_focus,
       image = img,
       widget = wibox.widget.imagebox
    }

    local tb = wibox.widget {
      tb_icon,
      top = dpi(4),
      widget = wibox.container.margin
    }
    tb.visible = true
    return tb
  end

  local close_button = gears.surface.load_uncached(
                      gfs.get_configuration_dir() .. "icons/titlebar/close.png")
  local close_icon = gears.color.recolor_image(close_button, "#EC6B64")
  local close = create_title_button(c, "#EC6B6499" , beautiful.xcolor0 .. "55", close_icon)
  close:connect_signal("button::press", function() c:kill() end)

  local last_left_click
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      if os.time() - (last_left_click or 0) < 1 then
        -- Assume to be double click
        c.maximized = not c.maximized
      else
        awful.mouse.client.move(c)
      end
      last_left_click = os.time()
    end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c) : setup {
    {
      helpers.horizontal_pad(6),
      {
        awful.titlebar.widget.iconwidget(c),
        top = dpi(2),
        bottom = dpi(2),
        widget = wibox.container.margin
      },
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal
    },
    { -- Title
      {
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
    },
    {
      {
        close,
        helpers.horizontal_pad(6),
        top = dpi(2),
        bottom = dpi(5),
        widget = wibox.container.margin,
      },
      layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.align.horizontal
  }
end)

