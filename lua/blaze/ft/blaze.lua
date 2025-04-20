--blaze.nvim/lua/blaze/ft/blaze.lua
local M = {}

function M.setup()
  vim.filetype.add({
    extension = {
      mojo = "mojo",
      ["🔥"] = "mojo",
    },
    pattern = {
      [".*%.🔥"] = "mojo",
    },
  })
end

return M
