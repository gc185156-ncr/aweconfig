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
            raise = true,
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

    -- ruled.client.append_rule {
    --     id = "tilebarless",
    --     rule = {
    --       instance = "ncmpcpp", "quake",
    --       name = "Friends List",
    --     },
    --     properties = {titlebars_enabled = false}
    -- }

    -- Floate em
    ruled.client.append_rule {
        id = "floating",
        rule_any = {
            class = {"Sxiv", "fzfmenu" },
            role = {
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            },
            name = {"Friends List", "Steam - News"},
            instance = {"spad", "music"}
        },
        properties = {floating = true, titlebars_enabled = false, placement = awful.placement.centered}
    }

    -- KeyBoard
    ruled.client.append_rule {
        id = "keyboard",
        rule = {class = "Onboard", instance = "onboard"},
        properties = {
            floating = true,
            focusable = false,
            ontop = true,
            titlebars = false
        }
    }

    -- Borders
    ruled.client.append_rule {
        id = "borders",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            role = {"Popup"},
            type = {"splash"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal
        }
    }

    -- Center Placement
    ruled.client.append_rule {
        id = "center_placement",
        rule_any = {
            type = {"dialog"},
            class = {
                "Steam", "discord", "markdown_input", "synergys"
            },
            instance = { "markdown_input", },
            role = {"GtkFileChooserDialog", "conversation"}
        },
        properties = {placement = awful.placement.center}
    }

    -- Titlebar rules
    ruled.client.append_rule {
        id = "titlebars",
        -- rule_any = {type = {"normal", "dialog"}},
        -- except_any = {
            -- class = {"Steam"},
            -- type = {"splash"},
            -- instance = {"onboard", "quake", "ncmpcpp"},
            -- name = {"^discord.com is sharing your screen.$", "Friends List"}
        -- },
        -- properties = {titlebars_enabled = true}
    }
end)
