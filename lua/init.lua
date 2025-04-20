-- lua/blaze/init.lua
---@class vim.var_accessor
---@field blaze_using_treesitter boolean
---@field mojo_highlight_all number
---@field blaze_no_auto_setup boolean


local M = {}

M.defaults = {
  lsp = {
    enabled = true,
    mojo = {
      enabled = true,
      config = {},
    },
  },
  indentation = {
    expandtab = true,
    shiftwidth = 4,
  },
  filetypes = {
    emoji_extension = true,
  },
  pixi = {
    enabled = true,
    config  = {},
  },
    magic = {
    enabled = true,
    config = {},
  },
  syntax = {
    enabled = true,
    treesitter = { enabled = true },
    fallback   = { enabled = true, highlight_all = true },
  },
}

function M.get_mojo_cmd()
  local is_windows = vim.fn.has('win32') == 1
  local is_mac = vim.fn.has('macunix') == 1
  local paths = {}

  if is_windows then
    table.insert(paths, vim.env.LOCALAPPDATA and vim.env.LOCALAPPDATA .. "\\Programs\\Mojo\\mojo.exe" or nil)
    table.insert(paths, "C:\\Program Files\\Mojo\\mojo.exe")
  else
    table.insert(paths, vim.env.HOME .. '/.local/bin/mojo')
    if is_mac then
      table.insert(paths, '/usr/local/bin/mojo')
      table.insert(paths, '/opt/homebrew/bin/mojo')
    else
      table.insert(paths, '/usr/local/bin/mojo')
      table.insert(paths, '/usr/bin/mojo')
    end
  end

  local env_path_separator = is_windows and "\\" or "/"
  local exe_extension = is_windows and ".exe" or ""
  table.insert(paths, vim.env.PIXI_HOME and
    vim.env.PIXI_HOME .. env_path_separator .. "bin" .. env_path_separator .. "mojo" .. exe_extension or nil)
  table.insert(paths, vim.env.MAGIC_HOME and
    vim.env.MAGIC_HOME .. env_path_separator .. "bin" .. env_path_separator .. "magic" .. exe_extension or nil)

  for _, path in ipairs(paths) do
    if path and vim.fn.executable(path) == 1 then
      return { path, 'lsp' }
    end
  end
end
function M.setup_syntax(opts)
  if not opts.syntax.enabled then
    return
  end

  local has_treesitter = pcall(require, "nvim-treesitter.parsers")
  local has_parser = false
  if has_treesitter then
    local parsers = require("nvim-treesitter.parsers")
    has_parser = parsers.has_parser("mojo")
  end
  vim.g.blaze_using_treesitter = has_parser and opts.syntax.treesitter.enabled

  if has_parser and opts.syntax.treesitter.enabled then
    require("blaze.syntax").setup()
  elseif opts.syntax.fallback.enabled then
    vim.g.mojo_highlight_all = opts.syntax.fallback.highlight_all and 1 or 0

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "mojo",
      callback = function()
        vim.cmd("runtime syntax/mojo.lua")
      end,
    })
  end
end

local function setup_plugin(opts)
  opts = vim.tbl_deep_extend('force', M.defaults, opts or {})
  M.options = opts

 if opts.lsp.enabled then
    require('blaze.lsp').setup_servers()
  end

 if opts.pixi.enabled then
    require("blaze.pixi").setup(opts.pixi.config)
  end

  vim.filetype.add({
    extension = {
      mojo = 'mojo',
    },
    pattern = opts.filetypes.emoji_extension and {
      ['.*%.mojo'] = 'mojo',
      ['.*%.🔥'] = 'mojo',
    } or {},
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'mojo',
    callback = function()
      vim.bo.shiftwidth = opts.indentation.shiftwidth
      vim.bo.expandtab = opts.indentation.expandtab
    end,
  })

  M.setup_syntax(opts)

  M._initialized = true
  return M
end

function M.setup(opts)
  return setup_plugin(opts)
end

if not vim.g.blaze_no_auto_setup then
  setup_plugin()
end

return M
