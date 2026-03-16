return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/compose%.ya?ml"] = "yaml.docker-compose",
          [".*/docker%-compose%.ya?ml"] = "yaml.docker-compose",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        docker_compose_language_service = {
          filetypes = { "yaml.docker-compose" },
        },
      })
    end,
  },
}
