-- /qompassai/blaze.nvim/lua/blaze/container.lua
-- -----------------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved

local M = {}

M.config = {
  image = 'ghcr.io/modular/magic:latest',
  mount_current = true,
  working_dir = '/app',
  container_name = 'blaze-magic',
  runtime = 'auto', -- "auto", "docker", "podman", or "nerdctl"
  rootless = true,
}

function M.detect_runtime()
  local runtimes = {
    { name = 'docker', cmd = 'docker' },
    { name = 'podman', cmd = 'podman' },
    { name = 'nerdctl', cmd = 'nerdctl' },
  }

  for _, runtime in ipairs(runtimes) do
    if vim.fn.executable(runtime.cmd) == 1 then
      return runtime.name
    end
  end

  return nil
end

function M.get_runtime_cmd()
  if M.config.runtime == 'auto' then
    local detected = M.detect_runtime()
    if detected then
      return detected
    else
      vim.notify('No container runtime found (docker, podman, or nerdctl)', vim.log.levels.ERROR)
      return nil
    end
  end

  if vim.fn.executable(M.config.runtime) == 1 then
    return M.config.runtime
  else
    vim.notify('Configured runtime ' .. M.config.runtime .. ' not found', vim.log.levels.ERROR)
    return nil
  end
end

function M.run_command(cmd, opts)
  opts = opts or {}

  local runtime = M.get_runtime_cmd()
  if not runtime then
    return nil
  end

  local mount = M.config.mount_current
      and ('-v %s:%s'):format(vim.fn.getcwd(), M.config.working_dir)
    or ''

  local rootless_flags = ''
  if M.config.rootless then
    if runtime == 'nerdctl' then
      rootless_flags = '--namespace=default'
    end
  end

  local container_cmd =
    string.format('%s %s run --rm %s %s %s', runtime, rootless_flags, mount, M.config.image, cmd)

  if opts.async then
    vim.fn.jobstart(container_cmd, {
      on_stdout = opts.on_stdout,
      on_stderr = opts.on_stderr,
      on_exit = opts.on_exit,
    })
  else
    local output = vim.fn.system(container_cmd)
    return output
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})

  local detected = M.detect_runtime()
  if detected then
    vim.notify(
      'Using container runtime: ' .. (M.config.runtime == 'auto' and detected or M.config.runtime),
      vim.log.levels.INFO
    )
  else
    vim.notify(
      'No container runtime found. Please install docker, podman, or nerdctl.',
      vim.log.levels.WARN
    )
  end

  return M
end

return M
