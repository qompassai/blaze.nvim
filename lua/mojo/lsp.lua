-- lua/mojo/lsp.lua

local M = {}

function M.setup()
  local lspconfig = require("lspconfig")

  if not lspconfig.configs["🔥-ls"] then
    lspconfig.configs["🔥-ls"] = {
      default_config = {
        cmd = { "mojo-lsp" },
        filetypes = { "mojo", "🔥" },
        root_dir = lspconfig.util.root_pattern(".git", "."),
      },
    }
  end

  lspconfig["🔥-ls"].setup {}
end

return M

