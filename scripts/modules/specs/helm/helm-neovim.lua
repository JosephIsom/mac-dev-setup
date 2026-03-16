return {
  {
    "towolf/vim-helm",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/templates/.*%.ya?ml"] = "helm",
          [".*/templates/.*%.tpl"] = "helm",
          [".*/Chart%.yaml"] = "yaml",
          [".*/values[^/]*%.ya?ml"] = "yaml",
        },
      })
    end,
    ft = { "helm" },
  },
}
