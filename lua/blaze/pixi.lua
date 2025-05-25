-- /qompassai/blaze.nvim/lua/blaze/pixi.lua
-- -----------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
---@class vim.var_accessor
---@field is_pixi_project boolean
local M = {}
M.is_windows = vim.fn.has('win32') == 1
M.is_mac = vim.fn.has('macunix') == 1
M.is_linux = vim.fn.has('unix') == 1 and not M.is_mac
M.config = {
  bin = nil,
  commands = true,
  auto_detect = true,
  notify = true,
  output = {
    split = 'horizontal',
    height = 15,
  },
}
M.get_pixi_path = function()
  if M.is_windows then
    return vim.env.LOCALAPPDATA and vim.env.LOCALAPPDATA .. '\\pixi\\bin\\pixi.exe' or nil
  elseif M.is_mac then
    return vim.env.HOME .. '/.pixi/bin/pixi'
  else
    return vim.env.HOME .. '/.pixi/bin/pixi'
  end
end
M.is_available = function()
  local pixi_path = M.get_pixi_path()
  if pixi_path and vim.fn.executable(pixi_path) == 1 then
    return true
  end
  local pixi_cmd = M.is_windows and 'pixi.exe' or 'pixi'
  return vim.fn.executable(pixi_cmd) == 1
end
function M.get_env_settings()
  local settings = {
    python_version = '>=3.8,<3.12',
    packages = {
      'numpy>=1.24',
      'pandas>=2.0',
      'matplotlib>=3.7',
      'ipykernel>=6.0',
    },
  }
  if M.is_windows then
    settings.python_version = '3.8'
    table.insert(settings.packages, 'pywin32>=305')
  elseif M.is_mac then
    settings.python_version = '>=3.9'
    table.insert(settings.packages, 'tensorflow-macos>=2.12')
    table.insert(settings.packages, 'tensorflow-metal>=0.9')
  else
    table.insert(settings.packages, 'tensorflow>=2.12')
    table.insert(settings.packages, 'pytorch>=2.0')
  end
  return settings
end
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  M.bin = M.config.bin or M.find_pixi_binary()
  if M.config.commands then
    M.create_commands()
  end
  if M.config.auto_detect then
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        M.detect_pixi_project()
      end,
    })
  end
end
function M.find_pixi_binary()
  local possible_paths = {
    vim.fn.expand('~/.pixi/bin/pixi'),
    '/usr/local/bin/pixi',
    '/usr/bin/pixi',
    vim.fn.expand('~/AppData/Local/pixi/bin/pixi.exe'),
  }
  for _, path in ipairs(possible_paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  if vim.fn.executable('pixi') == 1 then
    return 'pixi'
  end
  vim.notify(
    'Pixi binary not found. Please install pixi or set the path manually.',
    vim.log.levels.WARN
  )
  return nil
end
function M.show_env_info()
  M.run_command('info', '', {
    callback = function(output, success)
      if not success then
        vim.notify('Failed to get environment info', vim.log.levels.ERROR)
        return
      end
      local info = M.parse_pixi_info(output)
      local buf = vim.api.nvim_create_buf(false, true)
      local width = 60
      local height = 20
      local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = 'minimal',
        border = 'rounded',
        title = 'Pixi Environment Info',
      })
      M.info_win = win
      vim.api.nvim_win_set_option(win, 'winhl', 'NormalFloat:Normal,FloatBorder:Special')
      vim.api.nvim_win_set_option(win, 'cursorline', true)
      local lines = {}
      for section, data in pairs(info) do
        table.insert(lines, '== ' .. section .. ' ==')
        for k, v in pairs(data) do
          table.insert(lines, k .. ': ' .. v)
        end
        table.insert(lines, '')
      end
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
      vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
      vim.api.nvim_buf_set_keymap(
        buf,
        'n',
        'q',
        '<cmd>close<CR>',
        { noremap = true, silent = true }
      )
    end,
  })
end
function M.parse_pixi_info(output)
  local info = {
    project = {},
    environment = {},
    system = {},
  }
  local current_section = nil
  for _, line in ipairs(vim.split(output, '\n')) do
    line = line:gsub('^%s+', ''):gsub('%s+$', '')
    if line:match('^Project:') then
      current_section = 'project'
    elseif line:match('^Environment:') then
      current_section = 'environment'
    elseif line:match('^System:') then
      current_section = 'system'
    elseif current_section and line:match(':') then
      local key, value = line:match('([^:]+):%s*(.*)')
      if key and value then
        info[current_section][key:gsub('^%s+', '')] = value
      end
    end
  end
  return info
end
function M.detect_pixi_project()
  local pixi_toml = vim.fn.findfile('pixi.toml', '.;')
  if pixi_toml ~= '' then
    vim.b.is_pixi_project = true
  end
end
function M.run_command(cmd, args, opts)
  if not M.bin then
    vim.notify('Pixi binary not found', vim.log.levels.ERROR)
    return
  end
  opts = opts or {}
  local command = M.bin .. ' ' .. cmd
  if args then
    command = command .. ' ' .. args
  end
  if opts.terminal then
    vim.cmd('split | terminal ' .. command)
  else
    local output = vim.fn.system(command)
    local success = vim.v.shell_error == 0
    if opts.callback then
      opts.callback(output, success)
    elseif not success and M.config.notify then
      vim.notify('Command failed: ' .. command .. '\n' .. output, vim.log.levels.ERROR)
    end
    return output, success
  end
end
function M.create_commands()
  if not M.is_available() then
    vim.notify('Pixi not found. Commands will be registered but may not work.', vim.log.levels.WARN)
  end
  vim.api.nvim_create_user_command('PixiAdd', function(opts)
    ---@cast opts {args: string}
    M.run_command('add', opts.args)
    ---@cast opts {args: string}
  end, { nargs = '+', desc = 'Add a dependency to the pixi project' })
  vim.api.nvim_create_user_command('PixiAuth', function(opts)
    ---@cast opts {args: string}
    M.run_command('auth', opts.args)
  end, { nargs = '*', desc = 'Login to package servers' })
  vim.api.nvim_create_user_command('PixiCompletion', function(opts)
    ---@cast opts {args: string}
    M.run_command('completion', opts.args)
  end, { nargs = '?', desc = 'Generate shell completion script' })
  vim.api.nvim_create_user_command('PixiHelp', function(opts)
    ---@cast opts {args: string}
    M.run_command('help', opts.args)
  end, { nargs = '?', desc = 'Show pixi help' })
  vim.api.nvim_create_user_command('PixiInit', function(opts)
    ---@cast opts {args: string}
    M.run_command('init', opts.args)
  end, { nargs = '?', desc = 'Initialize a new pixi project' })
  vim.api.nvim_create_user_command('PixiInfo', function()
    M.run_command('info')
  end, { desc = 'Show project and system information' })
  vim.api.nvim_create_user_command('PixiInstall', function()
    M.run_command('install')
  end, { desc = 'Install pixi dependencies' })
  vim.api.nvim_create_user_command('PixiGlobal', function(opts)
    ---@cast opts {args: string}
    M.run_command('global', opts.args)
  end, { nargs = '*', desc = 'Global pixi management' })
  vim.api.nvim_create_user_command('PixiProject', function(opts)
    ---@cast opts {args: string}
    M.run_command('project', opts.args)
  end, { nargs = '*', desc = 'Project management' })
  vim.api.nvim_create_user_command('PixiRun', function(opts)
    ---@cast opts {args: string}
    M.run_command('run', opts.args)
  end, { nargs = '+', desc = 'Run a command in the pixi environment' })
  vim.api.nvim_create_user_command('PixiSearch', function(opts)
    ---@cast opts {args: string}
    M.run_command('search', opts.args)
  end, { nargs = '+', desc = 'Search for packages' })
  vim.api.nvim_create_user_command('PixiShell', function()
    M.run_command('shell', '', { terminal = true })
  end, { desc = 'Start a shell in the pixi environment' })
  vim.api.nvim_create_user_command('PixiTask', function(opts)
    ---@cast opts {args: string}
    M.run_command('task', opts.args)
  end, { nargs = '*', desc = 'Manage project tasks' })
  vim.api.nvim_create_user_command('PixiUpload', function(opts)
    ---@cast opts {args: string}
    M.run_command('upload', opts.args)
  end, { nargs = '+', desc = 'Upload package to prefix.dev' })
end
return M
