--blaze.nvim/lazy.lua
return {
  "qompassai/blaze.nvim",
  lazy = true,
  ft = { "mojo", "🔥" },
  config = function()
    require("blaze").setup()
  end,
  dependencies = {
   "qompassai/blaze-ts",
   "mason/nvim-lsp",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  }
}
