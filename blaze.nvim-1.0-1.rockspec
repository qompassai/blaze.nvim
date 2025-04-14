return {
  package = "blaze.nvim",
  version = "1.0-1",

  source = {
    url = "git+https://github.com/qompassai/blaze.nvim.git",
    tag = "v1.0.0"
  },

  description = {
    summary = "blaze.nvim: 🔥🔥🔥 for AI",
    detailed = [[
      A modern Neovim plugin for the 🔥(mojo) language. Provides syntax highlighting,
      Treesitter grammar, DAP, formatting, linting, and IDE integration.
      Designed for developers ready to go blazingly fast with AI.
    ]],
    homepage = "https://github.com/qompassai/blaze.nvim",
    license = "AGPL-3.0 AND Q-CDA"
  },

  dependencies = {
    "lua >= 5.1"
  },

  build = {
    type = "builtin",
    modules = {
      ["blaze"] = "lua/blaze/init.lua",
      ["blaze.dap"] = "lua/blaze/dap.lua",
      ["blaze.formatting"] = "lua/blaze/formatting.lua",
      ["blaze.linting"] = "lua/blaze/linting.lua",
      ["blaze.lsp"] = "lua/blaze/lsp.lua",
      ["blaze.syntax"] = "lua/blaze/syntax.lua",
      ["blaze.lualine"] = "lua/blaze/lualine.lua",
      ["blaze.health"] = "lua/blaze/health.lua"
    }
  }
}

