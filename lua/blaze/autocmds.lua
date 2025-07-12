-- /qompassai/blaze.nvim/lua/blaze/autocmds.lua
-- Blaze.nvim Autocmds
-- Copyright (C) 2025 Qompass AI, All rights reserved
--------------------------------------------------
local M = {}

function M.blaze_autocmds(opts)
    opts = opts or {}
    local ft_group = vim.api.nvim_create_augroup('BlazeMojoFileType',
                                                 {clear = true})
    local buf_group = vim.api.nvim_create_augroup('BlazeMojoBuffers',
                                                  {clear = true})
    vim.api.nvim_create_autocmd('FileType', {
        group = ft_group,
        pattern = 'mojo',
        callback = function(event)
            if opts.indentation then
                vim.bo.shiftwidth = opts.indentation.shiftwidth
                vim.bo.expandtab = opts.indentation.expandtab
            end
            vim.cmd('runtime syntax/blaze.lua')
        end
    })

    if opts.format_on_save then
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = buf_group,
            pattern = {'*.mojo', '*.🔥'},
            callback = function(event)
                vim.lsp.buf.format({async = false})
            end
        })
    end

    vim.api.nvim_create_user_command('MagicRun', function(cmd_opts)
        ---@cast cmd_opts {args: string, fargs: string[], bang: boolean, line1: number, line2: number, mods: string, reg: string}
        local cmd =
            'docker run --rm -v $(pwd):/app ghcr.io/modular/magic:latest ' ..
                cmd_opts.args
        vim.fn.system(cmd)
    end, {nargs = '*', desc = 'Run magic command in container'})

    if opts.auto_detect then
        vim.api.nvim_create_autocmd('BufEnter', {
            group = buf_group,
            callback = function(_event)
                require('blaze.pixi').detect_pixi_project()
            end
        })
    end

    M.blaze_commands(opts)
    return M
end

local container = require('blaze.container')

vim.api.nvim_create_user_command('ContainerRun', function(cmd_opts)
    ---@cast cmd_opts {args: string}
    container.run_command(cmd_opts.args)
end, {nargs = '*', desc = 'Run command in container'})

vim.api.nvim_create_user_command('MagicRun', function(cmd_opts)
    ---@cast cmd_opts {args: string}
    container.run_command('magic ' .. cmd_opts.args)
end, {nargs = '*', desc = 'Run magic command in container'})

vim.api.nvim_create_user_command('ContainerSetRuntime', function(cmd_opts)
    ---@cast cmd_opts {args: string}
    local runtime = cmd_opts.args
    if runtime == 'docker' or runtime == 'podman' or runtime == 'nerdctl' or
        runtime == 'auto' then
        container.config.runtime = runtime
        vim.notify('Container runtime set to: ' .. runtime, vim.log.levels.INFO)
    else
        vim.notify(
            "Invalid runtime. Use 'docker', 'podman', 'nerdctl', or 'auto'",
            vim.log.levels.ERROR)
    end
end, {nargs = 1, desc = 'Set container runtime (docker, podman, nerdctl, auto)'})

vim.api.nvim_create_user_command('MojoRun', function(_cmd_opts)
    local file = vim.fn.expand('%:p')
    vim.cmd(string.format('split | terminal magic run mojo run %s', file))
end, {desc = 'Run current mojo file'})

return M
