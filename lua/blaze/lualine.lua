-- lua/blaze/lualine.lua

local M = {}

local function has_lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    ---@diagnostic disable-next-line: undefined-field
    if client.name and client.name:lower():match("mojo") then
      return true
    end
  end
  return false
end

local function is_formatted()
  if not package.loaded["null-ls"] then return false end
  local null_ls = require("null-ls")
  local sources = null_ls.get_source({
    filetype = vim.bo.filetype,
    method = null_ls.methods.FORMATTING,
  })
  return sources and #sources > 0
end

local function is_linted()
  if not package.loaded["lint"] then return false end
  local linters = require("lint").linters_by_ft[vim.bo.filetype]
  return linters and #linters > 0
end

local function is_dap_ready()
  if not package.loaded["dap"] then return false end
  local dap = require("dap")
  return dap.session() ~= nil
end

function M.mojo_status()
  if vim.bo.filetype ~= "mojo" then return "" end
  local status = { "🔥" }

  if has_lsp() then table.insert(status, "🔥-ls") end
  if is_formatted() then table.insert(status, "🔥-fmt") end
  if is_linted() then table.insert(status, "🔥-lint") end
  if is_dap_ready() then table.insert(status, "🔥-dap") end

  return table.concat(status, " ")
end

return M
