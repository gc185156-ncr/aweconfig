-- wibar.lua
-- Wibar (top bar)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

-- Seperator -----------------------------------------------------------------

local sep = wibox.widget({
  { color = beautiful.xcolor8, text = "::", widget = wibox.widget.textbox },
  bottom = dpi(3),
  widget = wibox.container.margin,
})

-- Time Widget ----------------------------------------------------------------

local time_text = wibox.widget({
  font = beautiful.font,
  format = "%b %d, %T",
  align = "center",
  valign = "center",
  refresh = 1,
  widget = wibox.widget.textclock,
})

time_text.markup = "<span foreground='" .. beautiful.xcolor8 .. "'>" .. time_text.text .. "</span>"

time_text:connect_signal("widget::redraw_needed", function()
  time_text.markup = "<span foreground='" .. beautiful.xcolor8 .. "'>" .. time_text.text .. "</span>"
end)

local time_widget = wibox.widget({
  {
    { time_text, top = dpi(1), widget = wibox.container.margin },
    layout = wibox.layout.fixed.horizontal,
  },
  left = dpi(10),
  right = dpi(10),
  bottom = dpi(2),
  widget = wibox.container.margin,
})

-- Systray Widget -------------------------------------------------------------

local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
  mysystray,
  left = dpi(8),
  right = dpi(8),
  widget = wibox.container.margin,
}

local final_systray = wibox.widget({
  {
    mysystray_container,
    top = dpi(9),
    botto = dpi(4),
    left = dpi(4),
    right = dpi(4),
    layout = wibox.container.margin,
  },
  bg = beautiful.bg_systray,
  -- shape = helpers.rrect(beautiful.border_radius),
  widget = wibox.container.background,
})

local wrap_widget = function(w)
  local wrapped = wibox.widget({
    w,
    top = dpi(4),
    left = dpi(3),
    bottom = dpi(4),
    right = dpi(3),
    widget = wibox.container.margin,
  })
  return wrapped
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
    ontop = true,
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

  local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal("request::activate", "tasklist", { raise = true })
      end
    end),
    awful.button({}, 3, function()
      awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
      awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
      awful.client.focus.byidx(-1)
    end)
  )

  s.mytasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    bg = beautiful.wibar_bg,
    buttons = tasklist_buttons,
    layout = { spacing = dpi(8), layout = wibox.layout.fixed.horizontal },
    widget_template = {
      {
        {
          awful.widget.clienticon,
          forced_width = dpi(20),
          forced_height = dpi(19),
          widget = wibox.container.constraint,
        },
        {
          {
            id = "indicator",
            forced_width = dpi(10),
            forced_height = dpi(1),
            visible = false,
            bg = beautiful.xcolor8,
            shape = gears.shape.rectangle,
            widget = wibox.container.background,
          },
          top = dpi(4),
          widget = wibox.container.margin
        },
        layout = wibox.layout.align.vertical,
      },
      id = "background_role",
      widget = wibox.container.background,
      create_callback = function(self, c, index, clients)
        c:connect_signal("focus", function()
          self:get_children_by_id("indicator")[1].visible = true
        end)
        c:connect_signal("unfocus", function()
          self:get_children_by_id("indicator")[1].visible = false
        end)
        self:connect_signal("mouse::enter", function()
          awesome.emit_signal("bling::task_preview::visibility", s, true, c)
        end)
        self:connect_signal("mouse::leave", function()
          awesome.emit_signal("bling::task_preview::visibility", s, false, c)
        end)
      end,
    },
  })
  -- Add widgets to the wibox
  s.mywibox:setup({
    layout = wibox.layout.align.vertical,
    nil,
    {
      {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
          layout = wibox.layout.fixed.horizontal,
          s.mytaglist,
          sep,
        },
        {
          wrap_widget(s.mytasklist),
          widget = wibox.container.constraint,
        },
        {
          awful.widget.only_on_screen(final_systray, screen[1]),
          helpers.horizontal_pad(4),
          wrap_widget({
            s.mylayoutbox,
            top = dpi(4),
            bottom = dpi(4),
            right = dpi(4),
            left = dpi(6),
            widget = wibox.container.margin,
          }),
          wrap_widget(time_widget),
          helpers.horizontal_pad(4),
          layout = wibox.layout.fixed.horizontal,
        },
      },
      widget = wibox.container.background,
      bg = beautiful.xcolor0 .. "00",
    },
  })
end)

-- EOF ------------------------------------------------------------------------
