-- mac-dev-setup managed WezTerm baseline
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.font_size = 14.0
config.colors = {
  foreground = '#BCBEC4',
  background = '#191A1C',
  cursor_bg = '#CED0D6',
  cursor_fg = '#191A1C',
  cursor_border = '#CED0D6',
  selection_bg = '#373B39',
  selection_fg = '#DFE1E5',
  scrollbar_thumb = '#43454A',
  split = '#2B2D30',
  ansi = {
    '#191A1C',
    '#F75464',
    '#6AAB73',
    '#E0BB65',
    '#56A8F5',
    '#C77DBB',
    '#2AACB8',
    '#BCBEC4',
  },
  brights = {
    '#6F737A',
    '#FA6675',
    '#73BD79',
    '#F2C55C',
    '#70AEFF',
    '#CF84CF',
    '#42C3D4',
    '#CED0D6',
  },
  tab_bar = {
    background = '#191A1C',
    active_tab = {
      bg_color = '#2B2D30',
      fg_color = '#DFE1E5',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#191A1C',
      fg_color = '#6F737A',
    },
    inactive_tab_hover = {
      bg_color = '#1F2024',
      fg_color = '#BCBEC4',
    },
    new_tab = {
      bg_color = '#191A1C',
      fg_color = '#6F737A',
    },
    new_tab_hover = {
      bg_color = '#1F2024',
      fg_color = '#BCBEC4',
    },
  },
}
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
