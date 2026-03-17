return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/asyncapi%.json"] = "json.asyncapi",
          [".*/asyncapi%.ya?ml"] = "yaml.asyncapi",
        },
      })

      vim.api.nvim_create_user_command("AsyncAPIValidate", function()
        local file = vim.api.nvim_buf_get_name(0)
        if file == "" then
          vim.notify("Save the buffer before validating AsyncAPI.", vim.log.levels.WARN)
          return
        end

        local result = vim.system({ "asyncapi", "validate", file }, { text = true }):wait()
        if result.code == 0 then
          vim.notify("AsyncAPI validation passed.", vim.log.levels.INFO)
          return
        end

        vim.notify(result.stderr ~= "" and result.stderr or result.stdout, vim.log.levels.ERROR)
      end, {
        desc = "Validate current AsyncAPI document",
      })
    end,
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        jsonls = {
          filetypes = { "json", "jsonc", "json.asyncapi" },
        },
        yamlls = {
          filetypes = { "yaml", "yaml.asyncapi" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        ["json.asyncapi"] = { "prettier" },
        ["yaml.asyncapi"] = { "prettier" },
      })
    end,
  },
}
