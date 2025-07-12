-- /qompassai/blaze.nvim/lua/blaze/init.lua
-- -----------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
local M = {}

local config = require('blaze.config')
local mojo_paths = require('blaze.paths')
M.defaults = config.defaults
M.options = config.options
function M.mojo_cmd() return mojo_paths.find_mojo_executable() end
function M.mojo_lsp_cmd() return mojo_paths.find_mojo_lsp() end
function M.mojo_syntax(opts)
    if not (opts and opts.syntax and opts.syntax.enabled) then return end
    local has_blazets, blazets = pcall(require, 'blaze-ts')
    if has_blazets then
        blazets.setup(opts.syntax)
    else
        if opts and opts.syntax and opts.syntax.fallback and
            opts.syntax.fallback.enabled then
            vim.g.mojo_highlight_all =
                opts.syntax.fallback.highlight_all and 1 or 0
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'mojo',
                callback = function(event)
                    vim.cmd('runtime syntax/blaze.lua')
                end
            })
        end
    end
end
function M.blaze_dap() require('blaze.dap').setup() end
function M.blaze_linting() require('blaze.linting').setup() end
function M.blaze_magic() require('blaze.magic').setup() end
function M.blaze_utils() require('blaze.utils').setup() end
function M.blaze_treesitter()
    local parser_config =
        require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.mojo = {
        install_info = {
            url = 'https://github.com/qompassai/blaze-ts.nvim',
            files = {
                'src/parser.c', 'src/grammar.js', 'src/scanner.c', 'main.zig',
                'root.zig'
            },
            branch = 'main',
            requires_generate_from_grammar = true
        },
        filetype = {'mojo', '🔥'}
    }
    require('nvim-treesitter.configs').setup({
        ensure_installed = {'mojo', 'lua', 'vim', 'bash', 'python'},
        highlight = {enable = true, additional_vim_regex_highlighting = false}
    })
end
local function setup_plugin(opts)
    opts = vim.tbl_deep_extend('force', config.defaults, opts or {})
    config.options = opts
    M.options = opts
    if opts.lsp and opts.lsp.enabled then
        require('blaze.lsp').setup_servers()
    end
    if opts.pixi and opts.pixi.enabled then
        require('blaze.pixi').setup(opts.pixi)
    end
    if opts.magic and opts.magic.enabled then
        require('blaze.magic').setup(opts.magic)
    end
    if opts.filetypes and opts.filetypes.emoji_extension then
        require('blaze.ft.blaze').setup()
    else
        vim.filetype.add({extension = {mojo = 'mojo', ['🔥'] = 'mojo'}})
    end
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'mojo',
        callback = function(event)
            if opts.indentation then
                vim.bo.shiftwidth = opts.indentation.shiftwidth
                vim.bo.expandtab = opts.indentation.expandtab
                vim.b.mojo_indent = opts.indentation
            end
        end
    })
    M.blaze_syntax(opts)
    M.blaze_treesitter()
    if opts.enable_linting then M.setup_linting() end
    if opts.dap and opts.dap.enabled then M.setup_dap() end
    M._initialized = true
    return M
end
---@param user_opts table|nil
function M.setup(user_opts)
    user_opts = user_opts or {}
    return setup_plugin(user_opts)
end
vim.api.nvim_create_user_command('Fever', function(cmd_opts)
    print('🌡️ Running blaze.nvim Healthcheck...\n')
    local mojo_cmd = M.get_mojo_cmd()
    local status = {
        ['treesitter (parser)'] = pcall(require, 'nvim-treesitter.parsers'),
        ['null-ls'] = pcall(require, 'null-ls'),
        ['dap'] = pcall(require, 'dap'),
        ['mojo binary'] = vim.fn.executable(mojo_cmd[1]) == 1,
        ['mojo path'] = mojo_cmd[1]
    }
    for label, ok in pairs(status) do
        if label == 'mojo path' then
            print(string.format('📍 %s: %s', label, ok))
        else
            print(string.format('%s %s', ok and '✅' or '❌', label))
        end
    end
end, {})
return M
