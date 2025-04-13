local lspconfig = require("lspconfig")

local function get_mojo_cmd()
  local paths = {
    vim.env.HOME .. "/.local/bin/mojo",
    "/usr/local/bin/mojo",
    "/usr/bin/mojo",
  }
  for _, path in ipairs(paths) do
    if vim.fn.executable(path) == 1 then
      return { path, "lsp" }
    end
  end
  return { "mojo", "lsp" }
end

lspconfig.mojo.setup {
  cmd = get_mojo_cmd(),
  filetypes = { "mojo", "🔥" },
  root_dir = function(fname)
    return require("lspconfig.util").find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  settings = {
    mojo = {
      modularHomePath = vim.env.MODULAR_HOME or (vim.env.HOME .. "/.modular"),
    },
  },
}
