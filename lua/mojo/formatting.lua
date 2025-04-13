-- lua/mojo/formatting.lua

local M = {}

function M.setup()
  local ok, null_ls = pcall(require, "null-ls")
  if not ok then return end

  local mojo_config = require("mojo").options or {}

  local line_length = mojo_config.line_length or 88

  null_ls.register({
    name = "mojo_format",
    method = null_ls.methods.FORMATTING,
    filetypes = { "mojo" },
    generator = null_ls.generator({
      command = "mojo",
      args = { "format", "--line-length", tostring(line_length), "-" },
      to_stdin = true,
    }),
  })

  vim.api.nvim_create_user_command("MojoFormat", function()
  vim.cmd("write")
  local file = vim.fn.expand("%:p")
  vim.fn.jobstart({ "magic", "run", "mojo", "format", file }, {
    stdout_buffered = true,
    on_exit = function(_, code)
      if code == 0 then vim.cmd("edit") end
    end,
  })
end, { desc = "Run mojo format using magic" })

  if mojo_config.format_on_save then
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.mojo", "*.🔥" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end

return M

