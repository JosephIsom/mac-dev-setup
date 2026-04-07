local M = {}

local c = {
  bg = "#191A1C",
  bg_alt = "#1F2024",
  bg_panel = "#27282B",
  bg_subtle = "#2B2D30",
  bg_emphasis = "#393B40",
  fg = "#BCBEC4",
  fg_bright = "#DFE1E5",
  fg_cursor = "#CED0D6",
  fg_muted = "#6F737A",
  fg_soft = "#868A91",
  line_nr = "#4B5059",
  line_nr_active = "#A1A3AB",
  border = "#43454A",
  blue = "#56A8F5",
  blue_bright = "#70AEFF",
  green = "#6AAB73",
  green_bright = "#73BD79",
  yellow = "#E0BB65",
  yellow_bright = "#F2C55C",
  red = "#F75464",
  red_bright = "#FA6675",
  magenta = "#C77DBB",
  magenta_bright = "#CF84CF",
  cyan = "#2AACB8",
  cyan_bright = "#42C3D4",
  orange = "#CF8E6D",
  olive = "#B3AE60",
  gold = "#D5B778",
  teal = "#16BAAC",
  selection = "#373B39",
  search = "#2D543F",
}

function M.apply()
  vim.o.termguicolors = true
  vim.o.background = "dark"

  local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi("Normal", { fg = c.fg, bg = c.bg })
  hi("NormalFloat", { fg = c.fg, bg = c.bg_panel })
  hi("FloatBorder", { fg = c.border, bg = c.bg_panel })
  hi("SignColumn", { fg = c.fg_muted, bg = c.bg })
  hi("LineNr", { fg = c.line_nr, bg = c.bg })
  hi("CursorLine", { bg = c.bg_alt })
  hi("CursorLineNr", { fg = c.line_nr_active, bg = c.bg_alt, bold = true })
  hi("CursorColumn", { bg = c.bg_alt })
  hi("ColorColumn", { bg = c.bg_alt })
  hi("WinSeparator", { fg = c.border, bg = c.bg })
  hi("Visual", { fg = c.fg_bright, bg = c.selection })
  hi("Search", { fg = c.fg_bright, bg = c.search })
  hi("IncSearch", { fg = c.bg, bg = c.blue, bold = true })
  hi("CurSearch", { fg = c.bg, bg = c.blue, bold = true })
  hi("MatchParen", { fg = c.blue_bright, bold = true })
  hi("Pmenu", { fg = c.fg, bg = c.bg_panel })
  hi("PmenuSel", { fg = c.fg_bright, bg = c.bg_subtle, bold = true })
  hi("PmenuSbar", { bg = c.bg_subtle })
  hi("PmenuThumb", { bg = c.border })
  hi("StatusLine", { fg = c.fg, bg = c.bg_panel })
  hi("StatusLineNC", { fg = c.fg_muted, bg = c.bg_subtle })
  hi("TabLine", { fg = c.fg_muted, bg = c.bg })
  hi("TabLineFill", { fg = c.fg_muted, bg = c.bg })
  hi("TabLineSel", { fg = c.fg_bright, bg = c.bg_subtle, bold = true })

  hi("Comment", { fg = "#7A7E85", italic = true })
  hi("Constant", { fg = c.magenta })
  hi("String", { fg = c.green })
  hi("Character", { fg = c.green })
  hi("Number", { fg = c.cyan })
  hi("Boolean", { fg = c.orange })
  hi("Float", { fg = c.cyan })
  hi("Identifier", { fg = c.fg })
  hi("Function", { fg = c.blue })
  hi("Statement", { fg = c.orange })
  hi("Conditional", { fg = c.orange })
  hi("Repeat", { fg = c.orange })
  hi("Label", { fg = c.gold })
  hi("Operator", { fg = c.fg })
  hi("Keyword", { fg = c.orange })
  hi("Exception", { fg = c.red })
  hi("PreProc", { fg = c.olive })
  hi("Include", { fg = c.orange })
  hi("Define", { fg = c.olive })
  hi("Macro", { fg = c.olive })
  hi("PreCondit", { fg = c.olive })
  hi("Type", { fg = c.fg })
  hi("StorageClass", { fg = c.orange })
  hi("Structure", { fg = c.teal })
  hi("Typedef", { fg = c.fg })
  hi("Special", { fg = c.cyan_bright })
  hi("SpecialChar", { fg = c.orange })
  hi("Tag", { fg = c.gold })
  hi("Delimiter", { fg = c.fg })
  hi("SpecialComment", { fg = c.olive, italic = true })
  hi("Debug", { fg = c.red })

  hi("DiagnosticError", { fg = c.red })
  hi("DiagnosticWarn", { fg = c.yellow_bright })
  hi("DiagnosticInfo", { fg = c.blue })
  hi("DiagnosticHint", { fg = c.cyan })
  hi("DiagnosticOk", { fg = c.green_bright })
  hi("DiagnosticVirtualTextError", { fg = c.red_bright, bg = c.bg })
  hi("DiagnosticVirtualTextWarn", { fg = c.yellow, bg = c.bg })
  hi("DiagnosticVirtualTextInfo", { fg = c.blue_bright, bg = c.bg })
  hi("DiagnosticVirtualTextHint", { fg = c.cyan_bright, bg = c.bg })
  hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
  hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
  hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
  hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.cyan })

  hi("DiffAdd", { fg = c.green_bright, bg = "#223128" })
  hi("DiffChange", { fg = c.blue_bright, bg = "#1F2C3A" })
  hi("DiffDelete", { fg = c.red_bright, bg = "#3A2328" })
  hi("DiffText", { fg = c.fg_bright, bg = c.bg_subtle })
  hi("GitSignsAdd", { fg = c.green })
  hi("GitSignsChange", { fg = c.blue })
  hi("GitSignsDelete", { fg = c.red })

  hi("TelescopeNormal", { fg = c.fg, bg = c.bg })
  hi("TelescopeBorder", { fg = c.border, bg = c.bg })
  hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg_panel })
  hi("TelescopePromptBorder", { fg = c.border, bg = c.bg_panel })
  hi("TelescopePromptTitle", { fg = c.bg, bg = c.blue, bold = true })
  hi("TelescopePreviewTitle", { fg = c.bg, bg = c.green, bold = true })
  hi("TelescopeResultsTitle", { fg = c.bg, bg = c.magenta, bold = true })
  hi("TelescopeSelection", { fg = c.fg_bright, bg = c.bg_subtle })
  hi("WhichKey", { fg = c.blue })
  hi("WhichKeyDesc", { fg = c.fg })
  hi("WhichKeyGroup", { fg = c.magenta })
  hi("WhichKeySeparator", { fg = c.fg_muted })

  hi("Todo", { fg = "#8BB33D", italic = true })
end

function M.lualine_theme()
  return {
    normal = {
      a = { fg = c.bg, bg = c.blue, gui = "bold" },
      b = { fg = c.fg_bright, bg = c.bg_subtle },
      c = { fg = c.fg_muted, bg = c.bg },
    },
    insert = {
      a = { fg = c.bg, bg = c.green, gui = "bold" },
      b = { fg = c.fg_bright, bg = c.bg_subtle },
      c = { fg = c.fg_muted, bg = c.bg },
    },
    visual = {
      a = { fg = c.bg, bg = c.magenta, gui = "bold" },
      b = { fg = c.fg_bright, bg = c.bg_subtle },
      c = { fg = c.fg_muted, bg = c.bg },
    },
    replace = {
      a = { fg = c.bg, bg = c.red, gui = "bold" },
      b = { fg = c.fg_bright, bg = c.bg_subtle },
      c = { fg = c.fg_muted, bg = c.bg },
    },
    command = {
      a = { fg = c.bg, bg = c.yellow, gui = "bold" },
      b = { fg = c.fg_bright, bg = c.bg_subtle },
      c = { fg = c.fg_muted, bg = c.bg },
    },
    inactive = {
      a = { fg = c.fg_muted, bg = c.bg_subtle },
      b = { fg = c.fg_muted, bg = c.bg_subtle },
      c = { fg = c.fg_muted, bg = c.bg },
    },
  }
end

return M
