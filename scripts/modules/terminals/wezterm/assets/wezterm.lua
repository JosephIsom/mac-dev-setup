-- mac-dev-setup managed WezTerm baseline
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function appearance()
  if wezterm.gui and wezterm.gui.get_appearance then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function is_dark_mode()
  return appearance():find 'Dark' ~= nil
end

local colors_dark = {
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
    '#59B7C9',
    '#E9E9E9',
  },
  brights = {
    '#606060',
    '#EC5F5D',
    '#78B855',
    '#F6C944',
    '#6F63D9',
    '#E45C9D',
    '#5FA79B',
    '#FFFFFF',
  },
}

local colors_light = {
  foreground = '#272727',
  background = '#FFFFFF',
  cursor_bg = '#3477F7',
  cursor_fg = '#FFFFFF',
  selection_bg = '#BAD6FB',
  selection_fg = '#000000',
  ansi = {
    '#272727',
    '#CE4745',
    '#78B856',
    '#F6C94E',
    '#3477F7',
    '#8B4292',
    '#4DAFC3',
    '#F7F7F7',
  },
  brights = {
    '#7F7F7F',
    '#CE4745',
    '#78B856',
    '#F6C94E',
    '#6559CC',
    '#E45C9D',
    '#5A9B90',
    '#FFFFFF',
  },
}

config.colors = is_dark_mode() and colors_dark or colors_light
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
