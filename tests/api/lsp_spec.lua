-- /qompassai/blaze.nvim/tests/api/lsp_spec.lua
-- -------------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
package.path = '../../lua/?.lua;../../lua/?/init.lua;' .. package.path
describe('LSP API', function()
  local orig_lspconfig
  local mock_setup_called = false
  before_each(function()
    mock_setup_called = false
    orig_lspconfig = package.loaded['lspconfig']
    local mock_lspconfig = {
      configs = {},
      util = {
        find_git_ancestor = function()
          return vim.fn.getcwd()
        end,
      },
      mojo = {
        setup = function()
          mock_setup_called = true
        end,
      },
    }
    package.loaded['lspconfig'] = mock_lspconfig
    if require('blaze').get_mojo_cmd then
      orig_get_mojo_cmd = require('blaze').get_mojo_cmd
      require('blaze').get_mojo_cmd = function()
        return { 'mock_mojo', 'lsp' }
      end
    end
  end)
  after_each(function()
    package.loaded['lspconfig'] = orig_lspconfig
    if orig_get_mojo_cmd then
      require('blaze').get_mojo_cmd = orig_get_mojo_cmd
    end
  end)
  it('configures Mojo LSP client when enabled', function()
    require('blaze').setup({
      lsp = {
        enabled = true,
        mojo = { enabled = true },
      },
    })
    assert.is_true(mock_setup_called)
  end)
  it('registers mojo LSP configuration correctly', function()
    local mock_lspconfig = package.loaded['lspconfig']
    mock_lspconfig.mojo = nil
    require('blaze').setup({
      lsp = {
        enabled = true,
        mojo = { enabled = true },
      },
    })
    assert.is_not_nil(mock_lspconfig.configs.mojo)
    assert.are.equal('mojo', mock_lspconfig.configs.mojo.default_config.filetypes[1])
    assert.are.equal('🔥', mock_lspconfig.configs.mojo.default_config.filetypes[2])
  end)
  it('respects user configuration', function()
    local test_config = { settings = { mojo = { customSetting = 'test_value' } } }
    local config_verified = false
    local mock_lspconfig = package.loaded['lspconfig']
    mock_lspconfig.mojo.setup = function(opts)
      assert.are.equal('test_value', opts.settings.mojo.customSetting)
      config_verified = true
    end
    require('blaze').setup({
      lsp = {
        enabled = true,
        mojo = {
          enabled = true,
          config = test_config,
        },
      },
    })
    assert.is_true(config_verified)
  end)
end)
