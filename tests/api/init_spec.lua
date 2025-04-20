-- tests/api/init_spec.lua
-- luacheck: globals describe it before_each it assert spy require
---@diagnostic disable: unused-local, undefined-global, undefined-field
local helpers = require('helpers')
local spy = require('luassert.spy')


describe("blaze/init.lua", function()
  before_each(function()
    package.loaded['blaze']      = nil
    package.loaded['blaze.pixi'] = nil
  end)

  it("uses the built‑in defaults if no opts given", function()
    local blaze = require('blaze').setup()
    assert.is_table(blaze)
    assert.is_true(blaze.options.lsp.enabled)
    assert.is_false(blaze.options.pixi.enabled)
    assert.is_true(blaze.options.syntax.fallback.highlight_all)
  end)

  it("merges user opts into defaults", function()
    local b = require('blaze').setup({ indentation = { shiftwidth = 2 } })
    assert.equals(2, b.options.indentation.shiftwidth)
    assert.is_true(b.options.lsp.enabled)
  end)

  it("does NOT call pixi.setup when pixi.enabled = false", function()
    local pixi = { setup = spy.new(function() end) }
    package.loaded['blaze.pixi'] = pixi

    require('blaze').setup({ pixi = { enabled = false } })
    assert.spy(pixi.setup).was_not_called()
  end)

  it("calls pixi.setup exactly once with the provided config when pixi.enabled = true", function()
    local pixi = { setup = spy.new(function() end) }
    package.loaded['blaze.pixi'] = pixi

    local cfg = { foo = "bar" }
    require('blaze').setup({ pixi = { enabled = true, config = cfg } })
    assert.spy(pixi.setup).was.called(1)
    assert.spy(pixi.setup).was.called_with(cfg)
  end)
end)

vim.tbl_deep_extend = function(_, ...)
  local result = {}
  for _, t in ipairs({...}) do
    if type(t) == "table" then
      for k, v in pairs(t) do
        result[k] = v
      end
    end
  end
  return result
end

return {}
