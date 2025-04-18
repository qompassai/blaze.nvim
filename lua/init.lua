-- lua/blaze/init.lua
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
  syntax = {
    enabled = true,
    treesitter = {
      enabled = true,
    },
    fallback = {
      enabled = true,
      highlight_all = true, -- corresponds to vim.g.mojo_highlight_all
    },
  },
}

function M.get_mojo_cmd()
  local paths = {
    vim.env.HOME .. '/.local/bin/mojo',
    '/usr/local/bin/mojo',
    '/usr/bin/mojo',
    vim.env.PIXI_HOME and vim.env.PIXI_HOME .. '/bin/mojo' or nil,
    vim.env.MAGIC_HOME and vim.env.MAGIC_HOME .. '/bin/magic' or nil,
  }
  for _, path in ipairs(paths) do
    if path and vim.fn.executable(path) == 1 then
      return { path, 'lsp' }
    end
  end
  return { 'mojo', 'lsp' }
end

function M.setup_syntax(opts)
  if not opts.syntax.enabled then
    return
  end

  -- Check if TreeSitter is available and has the parser
  local has_treesitter = pcall(require, "nvim-treesitter.parsers")
  local has_parser = false
  if has_treesitter then
    local parsers = require("nvim-treesitter.parsers")
    has_parser = parsers.has_parser("mojo")
  end

  -- Set global variable for other parts of the plugin
  vim.g.blaze_using_treesitter = has_parser and opts.syntax.treesitter.enabled

  if has_parser and opts.syntax.treesitter.enabled then
    -- Use TreeSitter for syntax highlighting
    require("blaze.syntax").setup()
  elseif opts.syntax.fallback.enabled then
    -- Fallback to traditional syntax highlighting
    vim.g.mojo_highlight_all = opts.syntax.fallback.highlight_all and 1 or 0

    -- This autocmd ensures the syntax file is loaded for the mojo filetype
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
  vim.filetype.add({
    extension = {
      mojo = 'mojo',
    },
    pattern = opts.filetypes.emoji_extension and {
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

  if opts.lsp.enabled then
    require('blaze.lsp').setup_servers()
  end

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

