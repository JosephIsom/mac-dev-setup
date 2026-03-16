return {
  {
    name = "mac-dev-setup-gradle-groovy",
    lazy = false,
    init = function()
      vim.filetype.add({
        filename = {
          ["Jenkinsfile"] = "groovy",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        groovyls = {
          cmd = { "groovy-language-server" },
          filetypes = { "groovy" },
        },
      })
    end,
  },
}
