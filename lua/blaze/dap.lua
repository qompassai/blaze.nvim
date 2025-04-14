local M = {}

local function find_mojo_executable()
  local possible_paths = {
    vim.env.HOME .. "/.local/bin/mojo",
    "/usr/src/debug/mojo",
    "/usr/bin/mojo",
    "/usr/local/bin/mojo"
  }
  for _, path in ipairs(possible_paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return "mojo"
end

function M.setup()
  local has_dap, dap = pcall(require, "dap")
  if not has_dap then return end

  dap.adapters.mojo = {
    type = "executable",
    command = find_mojo_executable(),
    args = { "debug" },
  }

  dap.configurations.mojo = {
    {
      type = "mojo",
      request = "launch",
      name = "Launch Mojo Program",
      program = "${file}",
      pythonPath = function()
        return find_mojo_executable()
      end,
    },
  }
end

return M
