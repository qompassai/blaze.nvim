-- /qompassai/blaze.nvim/indent/blaze.lua
-- --------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
-- luacheck: globals vim ipairs pairs type loadstring
---@diagnostic disable: undefined-field, undefined-global, need-check-nil
local M = {}
local function apply_indent_settings(bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'lisp', false)
    vim.api.nvim_buf_set_option(bufnr, 'autoindent', true)
    vim.api.nvim_buf_set_option(bufnr, 'indentexpr',
                                "v:lua.require'blaze.autoload.mojo'.indentexpr()")
    local keys = vim.api.nvim_buf_get_option(bufnr, 'indentkeys')
    if not keys:match('<:>') then
        vim.api.nvim_buf_set_option(bufnr, 'indentkeys',
                                    keys .. ',<:>,=elif,=except')
    end
    vim.b[bufnr].undo_indent = 'setl ai< inde< indk< lisp<'
end
function M.setup()
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'mojo',
        ---@param arg { buf: integer }
        callback = function(arg)
            if vim.b[arg.buf].blaze_mojo_indent_applied then return end
            apply_indent_settings(arg.buf)
            vim.b[arg.buf].blaze_mojo_indent_applied = true
        end,
        desc = 'Blaze.nvim – Mojo indent settings'
    })
    if _G.GetMojoIndent == nil then
        _G.GetMojoIndent = function(lnum)
            return require('blaze.autoload.blaze').get_indent(lnum)
        end
    end
end
return M
