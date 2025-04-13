return {
  package = "🔥.nvim",
  version = "1.0-1",

  source = {
    url = "git+https://github.com/qompassai/🔥.nvim.git",
    tag = "v1.0.0"
  },

  description = {
    summary = "🔥.nvim: Mojo support plugin for Neovim",
    detailed = [[
      A modern Neovim plugin for the Mojo language. Provides syntax highlighting,
      Treesitter grammar, DAP, formatting, linting, and IDE integration.
      Designed for developers ready to go blazingly fast with AI.
    ]],
    homepage = "https://github.com/qompassai/🔥.nvim",
    license = "AGPL-3.0 AND Q-CDA"
  },

  dependencies = {
    "lua >= 5.1"
  },

  build = {
    type = "builtin",
    modules = {
      ["mojo"] = "lua/mojo/init.lua",
      ["mojo.dap"] = "lua/mojo/dap.lua",
      ["mojo.formatting"] = "lua/mojo/formatting.lua",
      ["mojo.linting"] = "lua/mojo/linting.lua",
      ["mojo.lsp"] = "lua/mojo/lsp.lua",
      ["mojo.syntax"] = "lua/mojo/syntax.lua",
      ["mojo.lualine"] = "lua/mojo/lualine.lua",
      ["mojo.health"] = "lua/mojo/health.lua"
    }
  }
}

