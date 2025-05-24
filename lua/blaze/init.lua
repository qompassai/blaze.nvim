--blaze.nvim/lua/blaze/init.lua
--------------------------------
--luacheck
---@class vim.var_accessor
---@field blaze_using_treesitter boolean
---@field mojo_highlight_all number
---@field blaze_no_auto_setup boolean
local M = {}

local config = require("blaze.config")
local M = {}

M.defaults = config.defaults
M.options = config.options

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

  return { 'mojo', 'lsp' }
end

function M.setup_syntax(opts)
  if opts and not opts.syntax.enabled then
    return
  end

  local has_blazets, blazets = pcall(require, "blaze-ts")
  if has_blazets then
    blazets.setup(opts.syntax)
  else
    if opts and opts.syntax and opts.syntax.fallback and opts.syntax.fallback.enabled then
      vim.g.mojo_highlight_all = opts.syntax.fallback.highlight_all and 1 or 0

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function()
          vim.cmd("runtime syntax/blaze.lua")
        end,
      })
    end
  end
end
function M.setup_dap()
  require("blaze.dap").setup()
end
function M.setup_formatting()
  require("blaze.formatting").setup()
end
function M.setup_linting()
  require("blaze.linting").setup()
end
function M.setup_magic()
  require("blaze.magic").setup()
end
function M.setup_utils()
  require("blaze.utils").setup()
end
--function M.setup_treesitter()
--  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
--  parser_config.mojo = {
--    install_info = {
--      url = "https://github.com/qompassai/blaze-ts.nvim",
--      files = { "src/parser.c", "src/grammar.js" },
--      branch = "main",
--     generate_requires_npm = true,
--      requires_generate_from_grammar = true,
--    },
--    filetype = "mojo", "🔥"
--  }
 --   require("nvim-treesitter.configs").setup {
--    ensure_installed = { "mojo", "lua", "vim", "bash", "python" },
--    highlight = {
--      enable = true,
--      additional_vim_regex_highlighting = false,
--    },
--  }
--end

local function setup_plugin(opts)
  opts = vim.tbl_deep_extend('force', config.defaults, opts or {})
config.options = opts
M.options = opts

  if opts.lsp and opts.lsp.enabled then
    require('blaze.lsp').setup_servers()
  end

  if opts.pixi and opts.pixi.enabled then
    require("blaze.pixi").setup(opts.pixi)
  end

    if opts and opts.magic and opts.magic.enabled then
    require('blaze.magic').setup(opts.magic)
  end

  if opts.filetypes and opts.filetypes.emoji_extension then
    require("blaze.ft.blaze").setup()
  else
    vim.filetype.add({
      extension = {
        mojo = 'mojo',
      },
    })
  end
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'mojo',
    callback = function()
      if opts.indentation then
        vim.bo.shiftwidth = opts.indentation.shiftwidth
        vim.bo.expandtab = opts.indentation.expandtab
      end
    end,
  })
   M.setup_syntax(opts)
  M.setup_treesitter()
  if opts.format_on_save then
    M.setup_formatting()
  end
  if opts.enable_linting then
    M.setup_linting()
  end
  if opts.dap and opts.dap.enabled then
    M.setup_dap()
  end
  M._initialized = true
  return M
end
---@param user_opts table|nil
function M.setup(user_opts)
  user_opts = user_opts or {}
  return setup_plugin(user_opts)
end
if not vim.g.blaze_no_auto_setup then
  setup_plugin()
end
vim.api.nvim_create_user_command("Fever", function()
  print("🌡️ Running blaze.nvim Healthcheck...\n")
  local status = {
    ["treesitter (parser)"] = pcall(require, "nvim-treesitter.parsers"),
    ["null-ls"] = pcall(require, "null-ls"),
    ["dap"] = pcall(require, "dap"),
    ["mojo binary"] = vim.fn.executable("mojo") == 1,
  }
  for label, ok in pairs(status) do
    print(string.format("%s %s", ok and "✅" or "❌", label))
  end
end, {})
return M
