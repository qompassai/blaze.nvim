-- /qompassai/blaze.nvim/lua/blaze/health.lua
-- -----------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
local health = vim.health or require('health')
local M = {}
local function check_exec(bin)
    if vim.fn.executable(bin) == 1 then
        health.report_ok(bin .. ' found')
    else
        health.report_error(bin .. ' not found in $PATH')
    end
end
if vim.fn.executable('magic') == 1 then
    vim.health.report_ok('magic CLI found')
else
    vim.health.report_warn('magic not found (https://www.modular.com/install)')
end
function M.check()
    health.report_start('blaze.nvim: 🌡️ check')
    check_exec('mojo')
    local ok_ts, parsers = pcall(require, 'nvim-treesitter.parsers')
    if ok_ts and parsers.get_parser_configs().mojo then
        health.report_ok("Tree-sitter parser 'mojo' installed")
    elseif ok_ts then
        health.report_warn(
            "Tree-sitter is installed but '🔥' parser not configured")
    else
        health.report_error('nvim-treesitter not found')
    end
    local ok_null, _ = pcall(require, 'null-ls')
    if ok_null then
        health.report_ok('null-ls available')
    else
        health.report_warn('null-ls not installed')
    end
    local ok_dap, _ = pcall(require, 'dap')
    if ok_dap then
        health.report_ok('nvim-dap available')
    else
        health.report_warn('nvim-dap not installed')
    end
end
return M
