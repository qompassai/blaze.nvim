-- plugin/mojo.lua

-- Prevent double-loading the plugin
if vim.g.loaded_mojo_plugin then
  return
end
vim.g.loaded_mojo_plugin = true

-- Optional: Register health check
local ok, health = pcall(require, "mojo.health")
if ok then
  vim.health.register_report("mojo.nvim", health.check)
end

-- Setup main plugin
require("mojo").setup()
