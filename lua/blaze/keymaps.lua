-- lua/blaze/keymaps.lua

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

local M = {}

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
    vim.notify("mojo executable not found in PATH", vim.log.levels.WARN)
  end
end

M.setup = function()
  local wk_ok, wk = pcall(require, "which-key")
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  local fallback_mappings = {
    { "<leader>mf", run_mojo_format, "🔥 Format" },
    { "<leader>mh", "<cmd>Fever<CR>", "🌡️ Run health check" },
    { "<leader>mi", "<cmd>!magic install mojo<CR>", "❤️‍🔥 Install 🔥" },
    { "<leader>mu", "<cmd>!magic update<CR>", "📦 Update dependencies" },
    { "<leader>ml", "<cmd>!magic lock<CR>", "🔒 Lock dependencies" },
    { "<leader>mx", "<cmd>!magic exec<CR>", "🧙‍♂️ Execute shell cmd" },
    { "<leader>ms", "<cmd>!magic shell<CR>", "🔮 Open magic shell" },
    { "<leader>mt", "<cmd>!magic tree<CR>", "🌲 Show dependency tree" },
    { "<leader>mg", "<cmd>!magic global<CR>", "🌍 Manage global packages" },
    { "<leader>mb", "<cmd>!magic build<CR>", "🔨 Build project" },
    { "<leader>mc", "<cmd>!magic clean<CR>", "🧹 Clean Magic cache" },
    { "<leader>mv", "<cmd>!magic self-update<CR>", "✨ Update Magic CLI" },
    { "<leader>mC", "<cmd>!magic completion --shell bash<CR>", "🧩 Generate shell completion" },
    { "<leader>mT", "<cmd>!magic telemetry --help<CR>", "📡 Telemetry help" },
    { "<leader>mH", "<cmd>!magic help<CR>", "📜 Magic help overview" },
  }

  if wk_ok then
    wk.register({
      ["<leader>m"] = {
        name = "+🔥 Mojo",
        f = { run_mojo_format, "🔥 Format via magic" },
        h = { "<cmd>Fever<CR>", "🌧️ Health Check" },
        i = { "<cmd>!magic install mojo<CR>", "❤️🔥 Install 🔥" },
        u = { "<cmd>!magic update<CR>", "📦 Update deps" },
        l = { "<cmd>!magic lock<CR>", "🔒 Lock env" },
        x = { "<cmd>!magic exec<CR>", "🧙‍♂️ Exec shell cmd" },
        s = { "<cmd>!magic shell<CR>", "🔮 Magic shell" },
        t = { "<cmd>!magic tree<CR>", "🌲 Dep tree" },
        g = { "<cmd>!magic global<CR>", "🌍 Global pkg" },
        b = { "<cmd>!magic build<CR>", "🔨 Build Mojo" },
        c = { "<cmd>!magic clean<CR>", "🧹 Clean build cache" },
        v = { "<cmd>!magic self-update<CR>", "✨ Self Update" },
        C = { "<cmd>!magic completion --shell bash<CR>", "🧩 Shell Completion" },
        T = { "<cmd>!magic telemetry --help<CR>", "🚱 Telemetry Settings" },
        H = { "<cmd>!magic help<CR>", "📜 Help Overview" },
      },
      ["❤️‍🔥"] = {
        name = "+🔥",
        map("n", "<leader>mf", run_mojo_format, vim.tbl_extend("force", opts, { desc = "🔥 Format" })),
        -- In Normal mode: <leader> + m + f — Format Mojo file

        map("n", "<leader>mh", "<cmd>Fever<CR>", vim.tbl_extend("force", opts, { desc = "🌡️ Run health check" })),
        -- In Normal mode: <leader> + m + h — Run Fever health check

        map("n", "<leader>mi", "<cmd>!magic install mojo<CR>", vim.tbl_extend("force", opts, { desc = "❤️‍🔥 Install 🔥" })),
        -- In Normal mode: <leader> + m + i — Install Mojo via Magic

        map("n", "<leader>mu", "<cmd>!magic update<CR>",
          vim.tbl_extend("force", opts, { desc = "📦 Update dependencies" })),
        -- In Normal mode: <leader> + m + u — Update project dependencies

        map("n", "<leader>ml", "<cmd>!magic lock<CR>", vim.tbl_extend("force", opts, { desc = "🔒 Lock dependencies" })),
        -- In Normal mode: <leader> + m + l — Lock environment dependencies

        map("n", "<leader>mx", "<cmd>!magic exec<CR>", vim.tbl_extend("force", opts, { desc = "🧙‍♂️ Execute shell cmd" })),
        -- In Normal mode: <leader> + m + x — Execute command inside Magic shell

        map("n", "<leader>ms", "<cmd>!magic shell<CR>", vim.tbl_extend("force", opts, { desc = "🔮 Open magic shell" })),
        -- In Normal mode: <leader> + m + s — Start Magic shell session

        map("n", "<leader>mt", "<cmd>!magic tree<CR>", vim.tbl_extend("force", opts, { desc = "🌲 Show dependency tree" })),
        -- In Normal mode: <leader> + m + t — View dependency tree

        map("n", "<leader>mg", "<cmd>!magic global<CR>",
          vim.tbl_extend("force", opts, { desc = "🌍 Manage global packages" })),
        -- In Normal mode: <leader> + m + g — Manage global packages

        map("n", "<leader>fb", "<cmd>!magic build<CR>", vim.tbl_extend("force", opts, { desc = "🔨 Build project" })),
        -- In Normal mode: <leader> + m + b — Build 🔥 project

        map("n", "<leader>mc", "<cmd>!magic clean<CR>", vim.tbl_extend("force", opts, { desc = "🧹 Clean Magic cache" })),
        -- In Normal mode: <leader> + m + c — Clean Magic build and task cache

        map("n", "<leader>mv", "<cmd>!magic self-update<CR>",
          vim.tbl_extend("force", opts, { desc = "✨ Update Magic CLI" })),
        -- In Normal mode: <leader> + m + v — Update Magic tool to latest

        map("n", "<leader>m/", "<cmd>!magic completion --shell bash<CR>",
          vim.tbl_extend("force", opts, { desc = "🧩 Generate shell completion" })),
        -- In Normal mode: <leader> + m + / — Generate bash shell completion

        map("n", "<leader>fT", "<cmd>!magic telemetry --help<CR>",
          vim.tbl_extend("force", opts, { desc = "📡 Telemetry help" })),
        -- In Normal mode: <leader> + m + T — Show telemetry configuration help

        map("n", "<leader>fH", "<cmd>!magic help<CR>", vim.tbl_extend("force", opts, { desc = "📜 Magic help overview" })),
        -- In Normal mode: <leader> + m + H — Show Magic help overview
      },
    })
  else
    for _, m in ipairs(fallback_mappings) do
      map("n", m[1], m[2], vim.tbl_extend("force", opts, { desc = m[3] }))
    end
  end
end

return M
