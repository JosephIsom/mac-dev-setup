-- mac-dev-setup managed WezTerm baseline
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.colors = {
  foreground = '#DEDEDE',
  background = '#1E1E1E',
  cursor_bg = '#3478F6',
  cursor_fg = '#1E1E1E',
  selection_bg = '#476288',
  selection_fg = '#FFFFFF',
  ansi = {
    '#1B1B1B',
    '#EC5F5D',
    '#78B855',
    '#F6C944',
    '#3478F6',
    '#9955A3',
    '#8C8C8C',
    '#E9E9E9',
  },
  brights = {
    '#606060',
    '#EC5F5D',
    '#78B855',
    '#F6C944',
    '#3478F6',
    '#E45C9D',
    '#9C9C9C',
    '#FFFFFF',
  },
}
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.font_size = 14.0
config.scrollback_lines = 50000
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}
config.adjust_window_size_when_changing_font_size = false
config.default_prog = { os.getenv 'SHELL' or '/bin/zsh', '-l' }

local local_config = os.getenv 'HOME' .. '/.config/wezterm/local.lua'
local ok, overrides = pcall(dofile, local_config)
if ok and type(overrides) == 'table' then
  for key, value in pairs(overrides) do
    config[key] = value
  end
end

return config
