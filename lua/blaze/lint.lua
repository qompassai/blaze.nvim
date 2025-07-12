-- /qompassai/blaze.nvim/lua/blaze/lint.lua
-- ------------------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
local M = {}
function M.blaze_lint()
  local ok, lint = pcall(require, 'lint')
  if not ok then
    vim.schedule(function()
      vim.notify('nvim-lint not available', vim.log.levels.INFO)
    end)
    return
  end
  lint.linters.mojo_format = {
    cmd = 'mojo',
    stdin = false,
    args = { 'format', '--quiet' },
    stream = 'stderr',
    ignore_exitcode = true,
    parser = function(output)
      local diagnostics = {}
      for line in vim.split(output or '', '\n', { plain = true, trimempty = true }) do
        if line ~= '' then
          table.insert(diagnostics, {
            lnum = 0,
            col = 0,
            message = line,
            severity = vim.diagnostic.severity.WARN,
            source = 'mojo format',
          })
        end
      end
      return diagnostics
    end,
  }
  lint.linters_by_ft = lint.linters_by_ft or {}
  lint.linters_by_ft.mojo = { 'mojo_format' }
  vim.schedule(function()
    vim.notify('mojo_format linter registered via nvim-lint', vim.log.levels.INFO)
  end)
end
return M
