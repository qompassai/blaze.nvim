-- ~/.GH/Qompass/Lua/Blaze.nvim/lua/blaze/paths.lua
-- ------------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved

local M = {}
---@return table: {executable_path, type}
function M.find_mojo_executable()
  local is_windows = vim.fn.has('win32') == 1
  local is_mac = vim.fn.has('macunix') == 1
  local paths = {}
  if is_windows then
    if vim.env.LOCALAPPDATA then
      table.insert(paths, vim.env.LOCALAPPDATA .. '\\Programs\\Mojo\\mojo.exe')
      table.insert(paths, vim.env.LOCALAPPDATA .. '\\Mojo\\mojo.exe')
      table.insert(paths, vim.env.LOCALAPPDATA .. '\\Modular\\Mojo\\mojo.exe')
    end
    if vim.env.APPDATA then
      table.insert(paths, vim.env.APPDATA .. '\\Mojo\\mojo.exe')
      table.insert(paths, vim.env.APPDATA .. '\\Modular\\Mojo\\mojo.exe')
    end
    if vim.env.USERPROFILE then
      table.insert(paths, vim.env.USERPROFILE .. '\\bin\\mojo.exe')
      table.insert(paths, vim.env.USERPROFILE .. '\\.local\\bin\\mojo.exe')
      table.insert(paths, vim.env.USERPROFILE .. '\\.modular\\bin\\mojo.exe')
      table.insert(paths, vim.env.USERPROFILE .. '\\AppData\\Local\\Programs\\Mojo\\mojo.exe')
    end
    if vim.env.ChocolateyInstall then
      table.insert(paths, vim.env.ChocolateyInstall .. '\\bin\\mojo.exe')
    end
    table.insert(paths, 'C:\\tools\\mojo\\mojo.exe')
    table.insert(paths, 'C:\\Users\\' .. (vim.env.USERNAME or 'user') .. '\\scoop\\apps\\mojo\\current\\mojo.exe')
    table.insert(paths, 'C:\\Program Files\\Mojo\\mojo.exe')
    table.insert(paths, 'C:\\Program Files (x86)\\Mojo\\mojo.exe')
    table.insert(paths, 'C:\\ProgramData\\Mojo\\mojo.exe')
  else
    if vim.env.HOME then
      table.insert(paths, vim.env.HOME .. '/.local/bin/mojo')
      table.insert(paths, vim.env.HOME .. '/bin/mojo')
      table.insert(paths, vim.env.HOME .. '/.cargo/bin/mojo')
      table.insert(paths, vim.env.HOME .. '/.pyenv/bin/mojo')
      table.insert(paths, vim.env.HOME .. '/.modular/bin/mojo')
      table.insert(paths, vim.env.HOME .. '/.cache/modular/bin/mojo')
    end
    if is_mac then
      if vim.env.HOME then
        table.insert(paths, vim.env.HOME .. '/Applications/Mojo.app/Contents/MacOS/mojo')
        table.insert(paths, vim.env.HOME .. '/Library/Application Support/Mojo/mojo')
      end
      table.insert(paths, '/usr/local/bin/mojo')
      table.insert(paths, '/opt/homebrew/bin/mojo')
      table.insert(paths, '/usr/local/Cellar/mojo/*/bin/mojo')
      table.insert(paths, '/opt/local/bin/mojo')
      table.insert(paths, '/Applications/Mojo.app/Contents/MacOS/mojo')
      table.insert(paths, '/Library/Application Support/Mojo/mojo')
    else
      if vim.env.HOME then
        table.insert(paths, vim.env.HOME .. '/.npm-global/bin/mojo')
        table.insert(paths, vim.env.HOME .. '/.yarn/bin/mojo')
      end
      table.insert(paths, '/usr/local/bin/mojo')
      table.insert(paths, '/usr/bin/mojo')
      table.insert(paths, '/opt/mojo/bin/mojo')
      table.insert(paths, '/snap/bin/mojo')
      table.insert(paths, '/var/lib/flatpak/exports/bin/mojo')
    end
  end
  local env_path_separator = is_windows and '\\' or '/'
  local exe_extension = is_windows and '.exe' or ''
  if vim.env.PIXI_HOME then
    table.insert(
      paths,
      vim.env.PIXI_HOME
        .. env_path_separator
        .. 'bin'
        .. env_path_separator
        .. 'mojo'
        .. exe_extension
    )
  end
  if vim.env.MAGIC_HOME then
    table.insert(
      paths,
      vim.env.MAGIC_HOME
        .. env_path_separator
        .. 'bin'
        .. env_path_separator
        .. 'magic'
        .. exe_extension
    )
  end
  for _, path in ipairs(paths) do
    if path and vim.fn.executable(path) == 1 then
      return { path, 'lsp' }
    end
  end
  return { 'mojo', 'lsp' }
end
---@return table: {executable_path}
function M.find_mojo_lsp()
  local is_windows = vim.fn.has('win32') == 1
  local paths = {}
  local exe_extension = is_windows and '.exe' or ''
  
  if vim.env.HOME then
    table.insert(paths, vim.env.HOME .. '/.local/bin/mojo-lsp-server' .. exe_extension)
    table.insert(paths, vim.env.HOME .. '/.modular/pkg/packages.modular.com_mojo/bin/mojo-lsp-server' .. exe_extension)
  end
  
  table.insert(paths, 'mojo-lsp-server' .. exe_extension)
  for _, path in ipairs(paths) do
    if path and vim.fn.executable(path) == 1 then
      return { path }
    end
  end
  local mojo_cmd = M.find_mojo_executable()
  return { mojo_cmd[1], 'lsp' }
end

---@return table: list of all paths checked
function M.get_all_paths()
  local is_windows = vim.fn.has('win32') == 1
  local is_mac = vim.fn.has('macunix') == 1
  local paths = {}
  return paths
end

return M

