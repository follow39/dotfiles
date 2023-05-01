local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'tokyonight'
config.font = wezterm.font 'Iosevka'
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

local act = wezterm.action

config.keys = {
  { key = 'p', mods = 'ALT|SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'n', mods = 'ALT|SHIFT', action = act.ScrollToPrompt(1) },
}

return config


