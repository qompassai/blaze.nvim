--/qompassai/blaze.nvim/lua/blaze/config.lua
-- ---------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
local M = {}
M.defaults = {
  format_on_save = true,
  enable_linting = true,
  dap = {
    enabled = true,
  },
  lsp = {
    enabled = true,
    mojo = {
      enabled = true,
      config = {},
    },
  },
  indentation = {
    expandtab = true,
    shiftwidth = 4,
  },
  filetypes = {
    emoji_extension = true,
  },
  pixi = {
    enabled = true,
    auto_detect = true,
    config = {},
    commands = {},
    keymaps = {
      enabled = true,
      prefix = '<leader>p',
    },
    display = {
      method = 'float', -- options: "split", "vsplit", "float", "notify"
      height = 15,
      width = 80,
    },
  },
  magic = {
    enabled = true,
    config = {},
    show_output = true,
    commands = {
      list = true,
    },
  },
  syntax = {
    enabled = true,
    treesitter = {
      enabled = true,
    },
    fallback = {
      enabled = true,
      highlight_all = true,
    },
  },
}
M.options = vim.deepcopy(M.defaults)
return M
