-- /qompassai/blaze.nvim/tests/api/init_spec.lua
-- -------------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
package.path = '../../lua/?.lua;../../lua/?/init.lua;' .. package.path
package.loaded['nvim-treesitter.parsers'] = {
  get_parser_configs = function()
    return {}
  end,
}
package.loaded['nvim-treesitter.configs'] = {
  setup = function()
    return true
  end,
}
local function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end
local function tbl_deep_extend(behavior, ...)
  local function merge(dst, src)
    for k, v in pairs(src) do
      if type(v) == 'table' and type(dst[k]) == 'table' then
        merge(dst[k], v)
      else
        dst[k] = deepcopy(v)
      end
    end
    return dst
  end
  local args = { ... }
  local result = deepcopy(args[2] or {})
  for i = 3, #args do
    merge(result, args[i])
  end
  return result
end
_G.vim = _G.vim or {}
_G.vim.api = _G.vim.api
  or setmetatable({}, {
    __index = function()
      return function() end
    end,
  })
_G.vim.fn = _G.vim.fn
  or setmetatable({}, {
    __index = function()
      return function() end
    end,
  })
_G.vim.g = _G.vim.g or {}
_G.vim.env = _G.vim.env or {}
_G.vim.bo = _G.vim.bo or {}
_G.vim.filetype = _G.vim.filetype or { add = function() end }
_G.vim.deepcopy = deepcopy
_G.vim.tbl_deep_extend = tbl_deep_extend
local blaze = require('blaze.init')
local default_opts = {
  lsp = { enabled = false },
  pixi = { enabled = false },
  magic = { enabled = false },
  filetypes = { emoji_extension = false },
  indentation = { shiftwidth = 4, expandtab = true },
  format_on_save = false,
  enable_linting = false,
  dap = { enabled = false },
  syntax = { enabled = false, fallback = { enabled = false, highlight_all = false } },
}
describe('blaze.nvim core', function()
  it('should return a table', function()
    assert.is_table(blaze)
  end)
  it('should have a setup function', function()
    assert.is_function(blaze.setup)
  end)
  it('should initialize with default options', function()
    local result = blaze.setup(default_opts)
    assert.is_table(result)
    assert.is_true(result._initialized)
  end)
  it('should return a valid Mojo command', function()
    local cmd = blaze.get_mojo_cmd()
    assert.is_table(cmd)
    assert.is_string(cmd[1])
    assert.is_string(cmd[2])
    assert.are.equal(cmd[2], 'lsp')
  end)
  it('should allow custom options', function()
    local opts = deepcopy(default_opts)
    opts.lsp.enabled = false
    local result = blaze.setup(opts)
    assert.is_table(result.options)
    assert.is_false(result.options.lsp.enabled)
  end)
end)
