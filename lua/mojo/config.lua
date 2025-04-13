-- lua/mojo/config.lua

local M = {}

--- Default configuration
M.options = {
  format_on_save = true,
  enable_linting = true,
  dap = {
    enabled = true,
  },
  keymaps = true, -- enables keybindings
}

--- Apply user configuration and set up plugin
---@param user_opts table|nil
function M.setup(user_opts)
  user_opts = user_opts or {}
  M.options = vim.tbl_deep_extend("force", {}, M.options, user_opts)

  require("mojo").setup(M.options)

  if M.options.keymaps then
    require("mojo.keymaps").setup()
  end
end

return M

