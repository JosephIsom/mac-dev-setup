return {
  {
    "folke/which-key.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          ipynb = "json",
        },
      })

      vim.api.nvim_create_user_command("JupytextSync", function()
        vim.cmd("write")
        vim.fn.jobstart({ "jupytext", "--sync", vim.api.nvim_buf_get_name(0) }, {
          stdout_buffered = true,
          stderr_buffered = true,
        })
      end, { desc = "Sync notebook/text pair with jupytext" })

      vim.api.nvim_create_user_command("JupytextPercent", function()
        vim.cmd("write")
        vim.fn.jobstart({ "jupytext", "--to", "py:percent", vim.api.nvim_buf_get_name(0) }, {
          stdout_buffered = true,
          stderr_buffered = true,
        })
      end, { desc = "Convert current notebook to py:percent with jupytext" })
    end,
    keys = {
      { "<leader>ns", "<cmd>JupytextSync<CR>", desc = "Notebook sync" },
      { "<leader>np", "<cmd>JupytextPercent<CR>", desc = "Notebook to py:percent" },
    },
  },
}
