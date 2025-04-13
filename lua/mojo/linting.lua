local M = {}

function M.setup()
  local ok, lint = pcall(require, "lint")
  if not ok then
    vim.health.report_warn("nvim-lint not available")
    return
  end

  -- Define custom Mojo linter using `mojo format`
  lint.linters.mojo_format = {
    cmd = "mojo",
    stdin = false,
    args = { "format", "--quiet" },
    stream = "stderr",
    ignore_exitcode = true,
    parser = function(output)
      local diagnostics = {}
      for line in vim.gsplit(output, "\n", { plain = true }) do
        table.insert(diagnostics, {
          lnum = 0,
          col = 0,
          message = line,
          severity = vim.diagnostic.severity.WARN,
          source = "mojo format",
        })
      end
      return diagnostics
    end,
  }

  lint.linters_by_ft = lint.linters_by_ft or {}
  lint.linters_by_ft.mojo = { "mojo_format" }

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.mojo", "*.🔥" },
    callback = function()
      lint.try_lint()
    end,
  })

  vim.health.report_ok("mojo_format linter registered via nvim-lint")
end

return M

