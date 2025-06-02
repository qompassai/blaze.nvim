-- /qompassai/blaze.nvim/lua/blaze/lsp.lua
-- Copyright (C) 2025 Qompass AI, All rights reserved
-- ------------------------------------------------------
local M = {}
function M.setup_servers()
  local config = require('blaze.config')
  local options = config.options or config.defaults
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    vim.notify("lspconfig not found, LSP features won't be available", vim.log.levels.WARN)
    return
  end
  if options and options.lsp and options.lsp.mojo and options.lsp.mojo.enabled then
    if not lspconfig.mojo then
      lspconfig.configs = lspconfig.configs or {}
      lspconfig.configs.mojo = {
        default_config = {
          cmd = require('blaze').get_mojo_cmd(),
          filetypes = { 'mojo', '🔥' },
          root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
          end,
          single_file_support = true,
        },
        docs = {
          description = [[
https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/mojo.lua
`mojo-lsp-server` can be installed [via Modular](https://developer.modular.com/download)
🔥 is a new programming language that bridges the gap between research and production by combining Python syntax and ecosystem with systems programming and metaprogramming features.
]],
        },
      }
    end
    lspconfig.mojo.setup(vim.tbl_deep_extend('force', {
      settings = {
        mojo = {
          modularHomePath = vim.env.MODULAR_HOME or (vim.env.HOME .. '/.modular'),
        },
      },
    }, options.lsp.mojo.config or {}))
  end
end
return M
