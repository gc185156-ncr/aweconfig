local B = require("subcomponents.titlebar")

local function trim_long_name(txt)
    if string.len(txt) > 50 then
        return string.sub(txt, 1, 50)
    else
        return txt
    end
end

client.connect_signal("request::titlebars", function(c)
    local titlewidget = wibox.widget {
        visible = false,
        text = trim_long_name(c.name),
        widget = wibox.widget.textbox,
        font = "Terminus Regular 10"
    }
    c:connect_signal("property::name",
                     function(z) titlewidget.text = trim_long_name(z.name) end)

    -- buttons for the titlebar {{{
    local buttons = gears.table.join(awful.button({}, mouse.LEFT, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
        titlewidget.visible = true
    end), awful.button({}, mouse.RIGHT, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
    end))
    -- }}}

    local main = wibox.widget {
        {
            -- Title
            align = "center",
            widget = titlewidget
        },
        buttons = buttons,
        layout = wibox.layout.flex.horizontal
    }
    main:connect_signal("mouse::leave",
                        function() titlewidget.visible = false end)

    awful.titlebar(c, {
        size = 44,
        -- comment out for normal look
        bg_normal = beautiful.bg_normal,
        bg_focus = beautiful.bg_normal
    }):setup{
        nil,
        main,
        {
            -- Right
            -- awful.titlebar.widget.maximizedbutton(c),
            B.custom_minimized_button(c),
            B.custom_maximized_button(c),
            B.custom_close_button(c),
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)
