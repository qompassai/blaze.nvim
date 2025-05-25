-- /qompassai/blaze.nvim/lua/blaze/syntax.lua
-- -----------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
local M = {}
function M.setup()
  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.mojo = {
    install_info = {
      url = 'https://github.com/qompassai/blaze-ts.nvim',
      files = { 'src/parser.c', 'src/grammar.js', 'src/scanner.c', 'main.zig', 'root.zig' },
      branch = 'main',
      generate_requires_npm = true,
      requires_generate_from_grammar = true,
    },
    filetype = { 'mojo', '🔥' },
  }
  vim.filetype.add({
    extension = {
      mojo = 'mojo',
      ['🔥'] = 'mojo',
    },
    pattern = {
      ['.*%.mojo'] = 'mojo',
      ['.*%.🔥'] = 'mojo',
      ['.*%.fire'] = 'mojo',
    },
  })
  vim.g.mojo_highlight_all = 1
end
return M
