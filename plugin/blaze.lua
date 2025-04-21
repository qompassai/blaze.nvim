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
local blaze = require('blaze')
if not vim.g.blaze_no_auto_setup then
  blaze._initialize()
end
