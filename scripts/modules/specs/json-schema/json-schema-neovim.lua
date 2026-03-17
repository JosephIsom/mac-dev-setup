return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*%.schema%.json"] = "json.schema",
        },
      })

      vim.api.nvim_create_user_command("JSONSchemaValidate", function()
        local file = vim.api.nvim_buf_get_name(0)
        if file == "" then
          vim.notify("Save the buffer before validating JSON Schema.", vim.log.levels.WARN)
          return
        end

        local result = vim.system({ "ajv", "compile", "-s", file }, { text = true }):wait()
        if result.code == 0 then
          vim.notify("JSON Schema validation passed.", vim.log.levels.INFO)
          return
        end

        vim.notify(result.stderr ~= "" and result.stderr or result.stdout, vim.log.levels.ERROR)
      end, {
        desc = "Validate current JSON Schema",
      })
    end,
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        jsonls = {
          filetypes = { "json", "jsonc", "json.schema" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        ["json.schema"] = { "prettier" },
      })
    end,
  },
}
