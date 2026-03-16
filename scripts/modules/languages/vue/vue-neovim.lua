local function vue_language_server_path()
  local npm_root = vim.trim(vim.fn.system({ "npm", "root", "-g" }))

  if npm_root == "" or vim.v.shell_error ~= 0 then
    return nil
  end

  local path = npm_root .. "/@vue/language-server"
  if vim.uv.fs_stat(path) then
    return path
  end

  return nil
end

local filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local plugin_path = vue_language_server_path()
      local ts_plugin = plugin_path and {
        {
          name = "@vue/typescript-plugin",
          location = plugin_path,
          languages = { "vue" },
        },
      } or {}

      opts = require("mac_dev_setup.config.tooling").extend_servers(opts, {
        ts_ls = {
          init_options = {
            plugins = ts_plugin,
          },
          filetypes = filetypes,
        },
        vue_ls = {},
      })

      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        vue = { "prettier" },
      })
    end,
  },
}
