return {
  {
    name = "mac-dev-setup-ansible",
    lazy = false,
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/playbooks?/.*%.ya?ml"] = "yaml.ansible",
          [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
          [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
          [".*/roles/.*/vars/.*%.ya?ml"] = "yaml.ansible",
          [".*/roles/.*/defaults/.*%.ya?ml"] = "yaml.ansible",
          [".*/ansible/.*%.ya?ml"] = "yaml.ansible",
          [".*/galaxy%.ya?ml"] = "yaml.ansible",
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        ansible = { "ansible_lint" },
        ["yaml.ansible"] = { "ansible_lint" },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        ansible = { "ansible-lint" },
        ["yaml.ansible"] = { "ansible-lint" },
      })
    end,
  },
}
