return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        terraformls = {},
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        hcl = { "terraform_fmt" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        terraform = { "tflint" },
        ["terraform-vars"] = { "tflint" },
      })
    end,
  },
}
