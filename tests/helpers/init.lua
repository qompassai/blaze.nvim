-- tests/helpers/init.lua

-- luacheck: globals _G ipairs pairs type
---@diagnostic disable: undefined-global

_G.vim = _G.vim or {}

vim.fn = vim.fn or {}
vim.fn.has        = vim.fn.has        or function(_) return 0 end
vim.fn.executable = vim.fn.executable or function(_) return 1 end
vim.fn.expand     = vim.fn.expand     or function(path) return path end

vim.tbl_deep_extend = vim.tbl_deep_extend or require('vim.tbl_deep_extend')

vim.api = vim.api or {}
vim.api.nvim_create_user_command = vim.api.nvim_create_user_command or function() end
vim.api.nvim_create_autocmd        = vim.api.nvim_create_autocmd        or function() end
vim.api.nvim_buf_set_lines         = vim.api.nvim_buf_set_lines         or function() end
vim.api.nvim_open_win              = vim.api.nvim_open_win              or function() end

vim.notify = vim.notify or function(_, _) end
vim.log    = vim.log    or { levels = { WARN = 1, ERROR = 2 } }

vim.bo = vim.bo or {}
vim.g  = vim.g  or {}

return {}
