-- tests/api/command_spec.lua
---@diagnostic disable: undefined-global
local assert = require("luassert")

describe("Magic List functionality", function()
  before_each(function()
    require('blaze').setup()

    _G._original_system = vim.fn.system
    vim.fn.system = function(cmd)
      _G._last_system_cmd = cmd
      return "Package list:\n  mojo (1.0.0)\n  modular (2.1.3)"
    end
  end)

  after_each(function()
    if _G._original_system then
      vim.fn.system = _G._original_system
      _G._original_system = nil
    end
  end)

  it("executes magic list command via keymap", function()
    local magic = require('blaze.magic')
    -- Fix unused variable by assigning to _ (or use it in an assertion)
    local _ = magic.list()
    -- Alternatively: Use the output value
    -- assert.matches("Package list:", output)

    assert.is_not_nil(_G._last_system_cmd)
    assert.matches("list", _G._last_system_cmd)
  end) -- Missing end statement added here

  it("handles invalid arguments gracefully", function()
    vim.fn.system = function(cmd)
      if cmd:match("invalid_arg") then
        error("Error: Invalid argument provided")
      end
      return "Normal output"
    end

    -- Fix redefined local by using the previously required module
    -- local magic = require('blaze.magic')
    local success, err = pcall(function()
      require('blaze.magic').list("invalid_arg")
    end)

    assert.is_false(success)
    assert.matches("Invalid argument", err)
  end)
end)

