-- /qompassai/blaze.nvim/lua/blaze/ft/blaze.lua
-- Copyright (C) 2025 Qompass AI, All rights reserved
-- -----------------------------------------------
local M = {}
function M.setup()
  vim.filetype.add({
    extension = {
      mojo = 'mojo',
      ['🔥'] = 'mojo',
    },
    pattern = {
      ['.*%.🔥'] = 'mojo',
    },
  })
end
return M
