-- blaze.nvim/lua/blaze/magic.lua
local M = {}
local function run_mojo_format()
  vim.notify("Formatting Mojo file...", vim.log.levels.INFO)
  local magic_path = M.get_magic_binary()
  if magic_path then
    local current_file = vim.fn.expand('%:p')
    local cmd = magic_path .. ' format ' .. current_file
    return vim.fn.system(cmd)
  end

  vim.notify("No formatting method available", vim.log.levels.ERROR)
end

  vim.notify("No formatting method available", vim.log.levels.ERROR)
M.defaults = {
  enabled = true,
  commands = {
    list = true,
  },
  show_output = true,
}

function M.get_magic_binary()
  local os_name = vim.loop.os_uname().sysname:lower()
  local home = vim.env.HOME or vim.fn.expand('~')
  local possible_paths = {}

  if os_name:match("darwin") or os_name:match("mac") then
    table.insert(possible_paths, home .. "/.modular/bin/magic")
    table.insert(possible_paths, "/usr/local/bin/magic")
    table.insert(possible_paths, "/opt/local/bin/magic")
    table.insert(possible_paths, "/usr/bin/magic")
    table.insert(possible_paths, "/bin/magic")
    table.insert(possible_paths, home .. "/bin/magic")
  elseif os_name:match("windows") or os_name:match("win") then
    table.insert(possible_paths, home .. "\\.modular\\bin\\magic.exe")
    table.insert(possible_paths, "C:\\Program Files\\magic.exe")
    table.insert(possible_paths, "C:\\Program Files (x86)\\magic.exe")
    table.insert(possible_paths, os.getenv("LOCALAPPDATA") .. "\\bin\\magic.exe")
    table.insert(possible_paths, "C:\\bin\\magic.exe")
  else
    table.insert(possible_paths, home .. "/.modular/bin/magic")
    table.insert(possible_paths, "/usr/local/bin/magic")
    table.insert(possible_paths, "/usr/bin/magic")
    table.insert(possible_paths, "/bin/magic")
    table.insert(possible_paths, home .. "/bin/magic")
  end

  for _, path in ipairs(possible_paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

function M.list(args) return M.run_magic_command("list", args) end
function M.install(args) return M.run_magic_command("install", args) end
function M.update(args) return M.run_magic_command("update", args) end
function M.lock() return M.run_magic_command("lock", "") end
function M.exec(args) return M.run_magic_command("exec", args) end
function M.shell() return M.run_magic_command("shell", "") end
function M.tree() return M.run_magic_command("tree", "") end
function M.global(args) return M.run_magic_command("global", args) end
function M.build() return M.run_magic_command("build", "") end
function M.clean() return M.run_magic_command("clean", "") end
function M.self_update() return M.run_magic_command("self-update", "") end
function M.completion(shell) return M.run_magic_command("completion", "--shell " .. (shell or "bash")) end
function M.telemetry() return M.run_magic_command("telemetry", "--help") end
function M.help() return M.run_magic_command("help", "") end
function M.setup_keymaps()
  local wk_ok, wk = pcall(require, "which-key")
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  local magic_commands = {
    f = { function() run_mojo_format() end, "🔥 Format via magic" },
    h = { "<cmd>Fever<CR>", "🌡️ Health Check" },
    i = { function() M.install("mojo") end, "❤️🔥 Install 🔥" },
    u = { function() M.update() end, "📦 Update deps" },
    l = { function() M.lock() end, "🔒 Lock env" },
    x = { function() M.exec() end, "🧙‍♂️ Exec shell cmd" },
    s = { function() M.shell() end, "🔮 Magic shell" },
    t = { function() M.tree() end, "🌲 Dep tree" },
    g = { function() M.global() end, "🌍 Global pkg" },
    b = { function() M.build() end, "🔨 Build 🔥" },
    c = { function() M.clean() end, "🧹 Clean build cache" },
    v = { function() M.self_update() end, "✨ Self Update" },
    C = { function() M.completion("bash") end, "🧩 Shell Completion" },
    T = { function() M.telemetry() end, "🚱 Telemetry Settings" },
    H = { function() M.help() end, "📜 Help Overview" },
    L = { function() M.list() end, "📋 List packages" },
  }

 if wk_ok then
    ---@type table<string, table>
    local wk_mappings = {
      ["<leader>m"] = {
        name = "+🔥 Mojo",
      }
    }
       for key, mapping in pairs(magic_commands) do
      ---@diagnostic disable-next-line: param-type-mismatch
      wk_mappings["<leader>m"][key] = mapping
    end

    wk.register(wk_mappings)
  else
    for key, mapping in pairs(magic_commands) do
      map("n", "<leader>m" .. key, mapping[1], vim.tbl_extend("force", opts, { desc = mapping[2] }))
    end
  end
end
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.defaults, opts)

  if not M.get_magic_binary() then
    if M.config.show_output then
      vim.notify("Magic binary not found. Some features may not work.", vim.log.levels.WARN)
    end
  end

  M.setup_keymaps()
  return M
end
