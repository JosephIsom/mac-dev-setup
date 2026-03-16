local M = {}

local dark = {
  bg = "#1E1E1E",
  bg_alt = "#252525",
  bg_panel = "#2D2D2D",
  bg_hover = "#333333",
  fg = "#DEDEDE",
  fg_alt = "#9D9D9D",
  fg_muted = "#737373",
  border = "#444444",
  border_strong = "#606060",
  blue = "#3478F6",
  purple = "#9955A3",
  pink = "#E45C9D",
  red = "#EC5F5D",
  orange = "#E8883A",
  yellow = "#F6C944",
  green = "#78B855",
  cyan = "#59B7C9",
  teal = "#5FA79B",
  indigo = "#6F63D9",
  graphite = "#8C8C8C",
  selection = "#476288",
}

local light = {
  bg = "#FFFFFF",
  bg_alt = "#F7F7F7",
  bg_panel = "#F9F9F9",
  bg_hover = "#EEEEEE",
  fg = "#272727",
  fg_alt = "#6B6B6B",
  fg_muted = "#7F7F7F",
  border = "#EEEEEE",
  border_strong = "#D9D9D9",
  blue = "#3477F7",
  purple = "#8B4292",
  pink = "#E45C9D",
  red = "#CE4745",
  orange = "#E88839",
  yellow = "#F6C94E",
  green = "#78B856",
  cyan = "#4DAFC3",
  teal = "#5A9B90",
  indigo = "#6559CC",
  graphite = "#989899",
  selection = "#BAD6FB",
}

function M.is_dark()
  if vim.fn.has("mac") == 1 then
    local result = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
    return vim.v.shell_error == 0 and result:match("Dark") ~= nil
  end

  return vim.o.background ~= "light"
end

function M.palette()
  return M.is_dark() and dark or light
end

function M.apply()
  local c = M.palette()

  vim.o.termguicolors = true
  vim.o.background = M.is_dark() and "dark" or "light"

  local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi("Normal", { fg = c.fg, bg = c.bg })
  hi("NormalFloat", { fg = c.fg, bg = c.bg_alt })
  hi("FloatBorder", { fg = c.border, bg = c.bg_alt })
  hi("SignColumn", { bg = c.bg })
  hi("LineNr", { fg = c.fg_muted, bg = c.bg })
  hi("CursorLine", { bg = c.bg_alt })
  hi("CursorLineNr", { fg = c.blue, bg = c.bg_alt, bold = true })
  hi("Visual", { bg = c.selection, fg = "NONE" })
  hi("Pmenu", { fg = c.fg, bg = c.bg_alt })
  hi("PmenuSel", { fg = "#FFFFFF", bg = c.blue, bold = true })
  hi("Search", { fg = c.fg, bg = c.bg_hover })
  hi("IncSearch", { fg = "#FFFFFF", bg = c.blue, bold = true })
  hi("MatchParen", { fg = c.blue, bold = true })
  hi("WinSeparator", { fg = c.border, bg = c.bg })
  hi("StatusLine", { fg = c.fg, bg = c.bg_panel })
  hi("StatusLineNC", { fg = c.fg_alt, bg = c.bg_alt })
  hi("Comment", { fg = c.fg_muted, italic = true })
  hi("Keyword", { fg = c.purple, bold = true })
  hi("String", { fg = c.green })
  hi("Number", { fg = c.orange })
  hi("Function", { fg = c.blue })
  hi("Type", { fg = c.indigo })
  hi("Identifier", { fg = c.fg })
  hi("Constant", { fg = c.pink })
  hi("Operator", { fg = c.fg_alt })
  hi("Special", { fg = c.cyan })
  hi("PreProc", { fg = c.purple })
  hi("Statement", { fg = c.purple })
  hi("DiagnosticError", { fg = c.red })
  hi("DiagnosticWarn", { fg = c.yellow })
  hi("DiagnosticInfo", { fg = c.blue })
  hi("DiagnosticHint", { fg = c.teal })
  hi("GitSignsAdd", { fg = c.green, bg = c.bg })
  hi("GitSignsChange", { fg = c.yellow, bg = c.bg })
  hi("GitSignsDelete", { fg = c.red, bg = c.bg })
  hi("TelescopeNormal", { fg = c.fg, bg = c.bg })
  hi("TelescopeBorder", { fg = c.border, bg = c.bg })
  hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg_alt })
  hi("TelescopePromptBorder", { fg = c.border, bg = c.bg_alt })
  hi("TelescopePromptTitle", { fg = "#FFFFFF", bg = c.blue, bold = true })
  hi("TelescopeSelection", { bg = c.bg_alt })
  hi("WhichKey", { fg = c.blue })
  hi("WhichKeyDesc", { fg = c.fg })
  hi("WhichKeyGroup", { fg = c.purple })
  hi("WhichKeySeparator", { fg = c.graphite })
end

function M.lualine_theme()
  local c = M.palette()

  return {
    normal = {
      a = { fg = "#FFFFFF", bg = c.blue, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_alt, bg = c.bg },
    },
    insert = {
      a = { fg = "#FFFFFF", bg = c.green, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_alt, bg = c.bg },
    },
    visual = {
      a = { fg = "#FFFFFF", bg = c.purple, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_alt, bg = c.bg },
    },
    replace = {
      a = { fg = "#FFFFFF", bg = c.red, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_alt, bg = c.bg },
    },
    command = {
      a = { fg = "#FFFFFF", bg = c.yellow, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_alt },
      c = { fg = c.fg_alt, bg = c.bg },
    },
    inactive = {
      a = { fg = c.fg_alt, bg = c.bg_alt },
      b = { fg = c.fg_alt, bg = c.bg_alt },
      c = { fg = c.fg_muted, bg = c.bg },
    },
  }
end

return M
