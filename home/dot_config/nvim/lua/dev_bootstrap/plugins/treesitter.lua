return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        if not vim.g.headless then
          vim.schedule(function()
            vim.notify("nvim-treesitter not ready yet; skipping initial config", vim.log.levels.WARN)
          end)
        end
        return
      end

      configs.setup({
        ensure_installed = {
          "bash",
          "css",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "query",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
