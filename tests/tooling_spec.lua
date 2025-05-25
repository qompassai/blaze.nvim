-- /qompassai/blaze.nvim/tests/tooling_spec.lua
-- ---------------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved

local tooling = require('blaze.tooling')

describe('Blaze tooling', function()
  it('should return the correct version', function()
    assert.are.equal('1.0.0', tooling.version())
  end)
end)
