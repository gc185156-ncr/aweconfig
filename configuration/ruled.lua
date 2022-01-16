local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
  -- Global
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      size_hints_honor = false,
      screen = awful.screen.preferred,
      placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  })

  -- Tasklist order
  ruled.client.append_rule({
    id = "tasklist_order",
    rule = {},
    properties = {},
    callback = awful.client.setslave,
  })

  ruled.client.append_rule({
    rule_any = { floating = true },
    properties = { placement = awful.placement.centered },
  })

  ruled.client.append_rule({
    rule_any = { class = "Scratchpad"},
    properties = { floating = true },
  })

  ruled.client.append_rule({
    rule_any = { type = { "normal", "dialog" } },
    except_any = {
      class = {
        "Steam",
        "Scratchpad",
        "dota2",
        "launcher",
      },
    },
    properties = { titlebars_enabled = true },
  })
end)
