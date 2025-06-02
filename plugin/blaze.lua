---blaze.nvim/plugin/blaze.lua
--------------------------------
---@class vim.var_accessor
---@field loaded_blaze_plugin boolean
---@type vim.var_accessor
if vim.g.loaded_blaze_plugin then
  return
end
vim.g.loaded_blaze_plugin = true

local ok, health = pcall(require, 'blaze.health')
if ok then
  vim.health.register_report('blaze.nvim', health.check)
end

if not vim.g.blaze_no_auto_setup then
  vim.schedule(function()
    require('blaze').setup({
      format_on_save = true,
      enable_linting = true,
      dap = { enabled = true },
      lsp = { enabled = true },
      syntax = { enabled = true },
      indentation = {
        expandtab = true,
        shiftwidth = 4,
      },
      filetypes = {
        emoji_extension = true,
      },
    })
  end)
end
