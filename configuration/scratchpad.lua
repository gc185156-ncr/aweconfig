local bling = require("module.bling")
local rubato = require("module.rubato")

-- Anitmations
local top_drawer = rubato.timed({
  pos = -400,
  rate = 144,
  intro = 0.1,
  easing = rubato.quadratic,
  duration = 0.2,
  awestore_compat = true,
})

-- Anitmations
local bottom_drawer = rubato.timed({
  pos = 2000,
  rate = 144,
  intro = 0.1,
  easing = rubato.quadratic,
  duration = 0.2,
  awestore_compat = true,
})

local music_control = bling.module.scratchpad({
  command = "alacritty --title music --class ncmpcpp,Scratchpad --command 'ncmpcpp'",
  rule = { instance = "ncmpcpp" },
  sticky = true,
  autoclose = false,
  floating = true,
  geometry = { x = 500, y = 1015, height = 400, width = (screen_width * 0.625) },
  reapply = true,
  dont_focus_before_close = false,
  rubato = { y = bottom_drawer },
})


awesome.connect_signal("scratch::music", function()
  music_control:toggle()
  -- music_vis:toggle()
end)



local drop_term = bling.module.scratchpad({
  command = "alacritty --title term --class drop_term,Scratchpad",
  rule = { instance = "drop_term" },
  sticky = true,
  autoclose = true,
  floating = true,
  geometry = { x = 20, y = 40, height = 400, width = screen_width - 40 },
  reapply = true,
  dont_focus_before_close = false,
  rubato = { y = top_drawer },
})

awesome.connect_signal("scratch::term", function()
  drop_term:toggle()
end)

local launcher = bling.module.scratchpad({
  command = "alacritty --title launcher --class launcher,Scratchpad -e /home/gcc/.config/awesome/scripts/launcher.sh",
  rule = { instance = "launcher" },
  sticky = true,
  autoclose = false,
  floating = true,
  geometry = { x = 970, y = 600, height = 300, width = 685 },
  reapply = true,
  dont_focus_before_close = true,
})

awesome.connect_signal("scratch::launcher", function()
  launcher:toggle()
end)

local games = bling.module.scratchpad({
  command = "alacritty --tittle games --class games,Scratchpad -e /home/gcc/.config/awesome/scripts/games-launcher.sh",
  rule = { instance = "st-256color" },
  sticky = true,
  autoclose = false,
  floating = true,
  geometry = { x = 880, y = 420, height = 600, width = 800 },
  reapply = true,
  dont_focus_before_close = true,
})

awesome.connect_signal("scratch::games", function()
  games:toggle()
end)
