-- blaze.nvim/lua/blaze/keymaps.lua
local M = {}

M.setup = function(opts)
  opts = opts or {}
  local pixi_prefix = opts.pixi and opts.pixi.keymaps and opts.pixi.keymaps.prefix or "<leader>p"

  -- Nerd Translate Legend for blaze.nvim kaymappings

 -- '🔥 Mojo': The Mojo programming language.
-- 'Magic': A tool that helps manage Mojo projects, dependencies, and builds.
-- 'Format' (🔥): Automatically fixes the layout of your code to make it neat and readable.
-- 'Health Check' (🌧️): Runs a check to make sure everything is set up correctly.
-- 'Install Mojo' (❤️‍🔥): Downloads and installs Mojo on your computer.
-- 'Update Dependencies' (📦): Updates all the libraries and tools your project uses.
-- 'Lock Dependencies' (🔒): Stops libraries from being updated to avoid breaking your project.
-- 'Execute Shell Command' (🧙‍♂️): Runs any command in a special environment for 🔥 projects.
-- 'Magic Shell' (🔮): Opens a special terminal where you can manage your 🔥 project.
-- 'Dependency Tree' (🌲): Shows all the libraries your project uses in a tree format.
-- 'Global Packages' (🌍): Manages tools that are installed globally on your computer.
-- 'Build Project' (🔨): Compiles your 🔥 project into something you can run.
-- 'Self Update' (✨): Updates the Magic tool itself to the latest version.
-- 'Shell Completion' (🧩): Adds tab-completion for Magic commands in your terminal.
-- 'Telemetry Help' (📡): Shows settings for tracking usage data in Magic tools.
-- 'Help Overview' (📜): Displays a menu with all the Magic commands you can use.

 local function run_mojo_format()
    local file = vim.fn.expand("%:p")
    if vim.fn.executable("mojo") == 1 then
      vim.fn.jobstart({ "mojo", "format", file }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = "mojo format" })
          end
        end,
        on_stderr = function(_, err)
          if err then
            vim.notify(table.concat(err, "\n"), vim.log.levels.ERROR, { title = "mojo format error" })
          end
        end,
      })
    else
      vim.notify("🔥 executable not found in PATH", vim.log.levels.WARN)
    end
  end

  local function shell_cmd(cmd)
    return function() vim.cmd("!" .. cmd) end
  end

  local mojo_commands = {
    f = { run_mojo_format, "🔥 Format via magic" },
    h = { "<cmd>Fever<CR>", "🌡️ Health Check" },
    i = { shell_cmd("magic install mojo"), "❤️🔥 Install 🔥" },
    u = { shell_cmd("magic update"), "📦 Update deps" },
    l = { shell_cmd("magic lock"), "🔒 Lock env" },
    x = { shell_cmd("magic exec"), "🧙‍♂️ Exec shell cmd" },
    s = { shell_cmd("magic shell"), "🔮 Magic shell" },
    t = { shell_cmd("magic tree"), "🌲 Dep tree" },
    g = { shell_cmd("magic global"), "🌍 Global pkg" },
    b = { shell_cmd("magic build"), "🔨 Build Mojo" },
    c = { shell_cmd("magic clean"), "🧹 Clean build cache" },
    v = { shell_cmd("magic self-update"), "✨ Self Update" },
    C = { shell_cmd("magic completion --shell bash"), "🧩 Shell Completion" },
    T = { shell_cmd("magic telemetry --help"), "🚱 Telemetry Settings" },
    H = { shell_cmd("magic help"), "📜 Help Overview" },
  }

  local wk_ok, wk = pcall(require, "which-key")
  local map = vim.keymap.set
  local key_opts = { noremap = true, silent = true }

  local pixi_commands = {
    i = { function() vim.cmd("PixiInit") end, "🧪 Initialize project" },
    a = { function() vim.cmd("PixiAdd") end, "📦 Add dependency" },
    r = { function() vim.cmd("PixiRun") end, "🏃 Run command" },
    s = { function() vim.cmd("PixiShell") end, "🐚 Start shell" },
    I = { function() vim.cmd("PixiInstall") end, "⬇️ Install dependencies" },
    c = { function() vim.cmd("PixiCompletion") end, "🧩 Generate completion" },
    g = { function() vim.cmd("PixiGlobal") end, "🌍 Global management" },
    A = { function() vim.cmd("PixiAuth") end, "🔑 Login to package servers" },
    t = { function() vim.cmd("PixiTask") end, "📋 Manage tasks" },
    f = { function() vim.cmd("PixiInfo") end, "ℹ️ Project info" },
    u = { function() vim.cmd("PixiUpload") end, "⬆️ Upload package" },
    S = { function() vim.cmd("PixiSearch") end, "🔎 Search packages" },
    p = { function() vim.cmd("PixiProject") end, "📁 Project management" },
    h = { function() vim.cmd("PixiHelp") end, "❓ Show help" },
  }

  local function cmd_with_args(cmd)
    return function()
      vim.ui.input({ prompt = cmd .. " arguments: " }, function(input)
        if input then
          vim.cmd(cmd .. " " .. input)
        end
      end)
    end
  end
  pixi_commands.a = { cmd_with_args("PixiAdd"), "📦 Add dependency" }
  pixi_commands.r = { cmd_with_args("PixiRun"), "🏃 Run command" }
  pixi_commands.S = { cmd_with_args("PixiSearch"), "🔎 Search packages" }

  if wk_ok then
    wk.register({
      ["<leader>m"] = {
        name = "+🔥 Mojo",
      }
    })

    for key, mapping in pairs(mojo_commands) do
      wk.register({
        [key] = mapping
      }, { prefix = "<leader>m" })
    end

    wk.register({
      [pixi_prefix] = {
        name = "+🧪 Pixi",
      }
    })

    for key, mapping in pairs(pixi_commands) do
      wk.register({
        [key] = mapping
      }, { prefix = pixi_prefix })
    end
  else
  for key, mapping in pairs(mojo_commands) do
    local mapping_opts = vim.tbl_extend("force", key_opts, { desc = mapping[2] })
    map("n", "<leader>m" .. key, mapping[1], mapping_opts)
  end

  for key, mapping in pairs(pixi_commands) do
    local mapping_opts = vim.tbl_extend("force", key_opts, { desc = mapping[2] })
    map("n", pixi_prefix .. key, mapping[1], mapping_opts)
  end
end
end
function M.setup_mojo_keymaps(opts)
  -- Future implementation
end

return M
