--blaze.nvim/lazy.lua
---------------------
return {
  "qompassai/blaze.nvim",
  lazy = true,
  ft = { "mojo", "🔥" },
  config = function()
    require("blaze").setup()
  end,
  dependencies = {
   "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
   "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
    "mfussenegger/nvim-dap-python",
    "nvimtools/none-ls.nvim",
    "zeioth/none-ls-autoload.nvim",
  }
}
