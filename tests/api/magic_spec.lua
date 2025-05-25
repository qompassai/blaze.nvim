-- /qompassai/blaze.nvim/tests/api/magic_spec.lua
-- -------------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
package.path = '../../lua/?.lua;../../lua/?/magic.lua;' .. package.path
---@diagnostic disable: undefined-global
--local assert = require("luassert")
describe('Blaze Magic Module', function()
  local magic_binary_path = '/mock/path/to/magic'
  local test_output = 'Package list:\n  mojo (1.0.0)\n  modular (2.1.3)'
  before_each(function()
    _G._original_executable = vim.fn.executable
    _G._original_system = vim.fn.system
    _G._original_notify = vim.notify
    vim.fn.executable = function(path)
      if path == magic_binary_path then
        return 1
      end
      return 0
    end
    _G._last_system_cmd = nil
    vim.fn.system = function(cmd)
      _G._last_system_cmd = cmd
      return test_output
    end
    vim.notify = function() end
    package.loaded['blaze.magic'] = nil
    local magic = require('blaze.magic')
    magic.get_magic_binary = function()
      return magic_binary_path
    end
    magic.run_magic_command = function(cmd, args)
      local command = magic_binary_path .. ' ' .. cmd
      if args and args ~= '' then
        command = command .. ' ' .. args
      end
      return vim.fn.system(command)
    end
  end)
  after_each(function()
    vim.fn.executable = _G._original_executable
    vim.fn.system = _G._original_system
    vim.notify = _G._original_notify
    package.loaded['blaze.magic'] = nil
  end)
  describe('Command Functions', function()
    it('list() executes the magic list command', function()
      local magic = require('blaze.magic')
      local output = magic.list()

      assert.are.equal(test_output, output)
      assert.are.equal(magic_binary_path .. ' list', _G._last_system_cmd)
    end)

    it('list() with args appends arguments to the command', function()
      local magic = require('blaze.magic')
      local _ = magic.list('--verbose')

      assert.are.equal(magic_binary_path .. ' list --verbose', _G._last_system_cmd)
    end)
    it('install() executes the magic install command', function()
      local magic = require('blaze.magic')
      local _ = magic.install('mojo')
      assert.are.equal(magic_binary_path .. ' install mojo', _G._last_system_cmd)
    end)
    it('update() executes the magic update command', function()
      local magic = require('blaze.magic')
      local _ = magic.update()
      assert.are.equal(magic_binary_path .. ' update', _G._last_system_cmd)
    end)
  end)
  describe('setup()', function()
    it('initializes keymaps', function()
      _G._keymap_calls = {}
      vim.keymap.set = function(mode, lhs, _, opts)
        table.insert(_G._keymap_calls, { mode = mode, lhs = lhs })
        return true
      end
      _G._original_pcall = _G.pcall
      _G.pcall = function(fn, ...)
        if type(fn) == 'function' and select(1, ...) == 'which-key' then
          return false, 'module not found'
        end
        return _G._original_pcall(fn, ...)
      end
      local magic = require('blaze.magic')
      magic.setup()
      local has_list_keymap = false
      for _, call in ipairs(_G._keymap_calls) do
        if call.mode == 'n' and call.lhs == '<leader>mL' then
          has_list_keymap = true
          break
        end
      end
      assert.is_true(has_list_keymap)
      _G.pcall = _G._original_pcall
    end)
    it('warns when magic binary is not found', function()
      local notify_called = false
      vim.notify = function(msg, level)
        if msg:match('Magic binary not found') and level == vim.log.levels.WARN then
          notify_called = true
        end
      end
      local magic = require('blaze.magic')
      magic.get_magic_binary = function()
        return nil
      end
      magic.setup()
      assert.is_true(notify_called)
    end)
  end)
  describe('get_magic_binary()', function()
    it('checks common installation paths', function()
      package.loaded['blaze.magic'] = nil
      local magic = require('blaze.magic')
      local paths_checked = {}
      vim.fn.executable = function(path)
        table.insert(paths_checked, path)
        if path == '/usr/bin/magic' then
          return 1
        end
        return 0
      end
      local bin = magic.get_magic_binary()
      assert.are.equal('/usr/bin/magic', bin)
      assert.is_true(#paths_checked > 5)
    end)
  end)
end)
