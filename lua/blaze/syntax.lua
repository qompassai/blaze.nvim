-- /qompassai/blaze.nvim/lua/blaze/syntax.lua
-- Qompass AI Blaze.nvim Syntax Module
-- Copyright (C) 2025 Qompass AI, All rights reserved
-----------------------------------------------------
local M = {}
function M.blaze_syntax()
   local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.mojo = {
    install_info = {
      url = 'https://github.com/qompassai/blaze-ts.nvim',
      files = { 'src/parser.c', 'src/grammar.js', 'src/node-types.json', 'src/scanner.c', 'src/main.zig', 'src/root.zig', 'tree_sitter/*.h' },
      branch = 'main',
      generate_requires_npm = true,
      requires_generate_from_grammar = true,
    },
    filetype = { 'mojo', '🔥' },
  }
  vim.filetype({
    extension = { mojo = 'mojo', ['🔥'] = 'mojo' },
    pattern = {
      ['.*%.mojo'] = 'mojo',
      ['.*%.🔥'] = 'mojo',
      ['.*%.fire'] = 'mojo',
    },
  })
  vim.g.mojo_highlight_all = 1
  	require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" }
})
end
return M
