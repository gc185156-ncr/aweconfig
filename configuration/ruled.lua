local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()

    -- Global
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            size_hints_honor = false,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_overlap +
                awful.placement.no_offscreen
        }
    }

    -- Tasklist order
    ruled.client.append_rule {
        id = "tasklist_order",
        rule = {},
        properties = {},
        callback = awful.client.setslave
    }

    ruled.client.append_rule {
        class = "fzf-menu",
        properties = {floating = true}
    }
    -- Spawn floating clients centered

    ruled.client.append_rule {
        rule_any = {floating = true},
        properties = {placement = awful.placement.centered}
    }

    -- Center Placement
    --[[    ruled.client.append_rule {
        id = "center_placement",
        rule_any = {
            type = {"dialog"},
            class = {"Steam", "discord", "markdown_input", "synergys"},
            instance = {"markdown_input"},
            role = {"GtkFileChooserDialog", "conversation"}
        },
        properties = {placement = awful.placement.center}
    } ]] --

end)
