-- plugin/blaze.lua

if vim.g.loaded_blaze_plugin then
  return
end
vim.g.loaded_blaze_plugin = true

local ok, health = pcall(require, "blaze.health")
if ok then
  vim.health.register_report("blaze.nvim", health.check)
end

require("blaze").setup()
