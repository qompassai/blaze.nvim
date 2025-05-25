package = 'blaze.nvim'
version = '1.0-1'
source = {
  url = 'git+https://github.com/qompassai/blaze.nvim.git',
  tag = 'v1.0.0',
}
description = {
  summary = 'blaze.nvim: 🔥 for AI',
  detailed = [[
    A modern Neovim plugin for the 🔥(mojo) language. Provides syntax highlighting,
    Treesitter (via blaze-ts.nvim), DAP, formatting, linting, and container-use.
    Designed for 0.1x developers & 10x developers alike.
  ]],
  homepage = 'https://github.com/qompassai/blaze.nvim',
  license = 'AGPL-3.0 AND Q-CDA',
}
dependencies = {
  'lua >= 5.1',
}
build = {
  type = 'builtin',
  modules = {
    ['blaze'] = 'lua/blaze/init.lua',
    ['init'] = 'lua/init.lua',
    ['blaze.autocmds'] = 'lua/blaze/autocmds.lua',
    ['blaze.container'] = 'lua/blaze/container.lua',
    ['blaze.dap'] = 'lua/blaze/dap.lua',
    ['blaze.formatting'] = 'lua/blaze/formatting.lua',
    ['blaze.health'] = 'lua/blaze/health.lua',
    ['blaze.keymaps'] = 'lua/blaze/keymaps.lua',
    ['blaze.linting'] = 'lua/blaze/linting.lua',
    ['blaze.lsp'] = 'lua/blaze/lsp.lua',
    ['blaze.lualine'] = 'lua/blaze/lualine.lua',
    ['blaze.magic'] = 'lua/blaze/magic.lua',
    ['blaze.pixi'] = 'lua/blaze/pixi.lua',
    ['blaze.syntax'] = 'lua/blaze/syntax.lua',
    ['blaze.ft.blaze'] = 'lua/blaze/ft/blaze.lua',
  },
  copy_directories = {
    'plugin',
    'autoload',
    'doc',
    'ftplugin',
    'indent',
    'syntax',
  },
}
