-- /qompassai/blaze.nvim/tests/api/init_spec.lua
-- -------------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
package.path = '../../lua/?.lua;../../lua/?/pixi.lua;' .. package.path
describe('Pixi Integration', function()
  it('parses pixi.toml', function()
    local mock_toml = [[name = "mojo-project"]]
    local project = require('blaze.pixi').parse(mock_toml)
    assert.are.equal('mojo-project', project.name)
  end)
end)
