local M = {}

M.defaults = {
  format_on_save = true,
  enable_linting = true,
  dap = {
    enabled = true,
  },
   pixi = {
    enabled = true,
    auto_detect = true,
    commands = {
    },
    keymaps = {
      enabled = true,
      prefix = "<leader>p",
    },
    display = {
      method = "float",  -- "split", "vsplit", "float", or "notify"
      height = 15,
      width = 80,
    }
  },
}

M.options = {}

---@param user_opts table|nil
function M.setup(user_opts)
  user_opts = user_opts or {}
  M.options = vim.tbl_deep_extend("force", {}, M.options, user_opts)

  require("blaze").setup(M.options)

  if M.options.keymaps then
    require("blaze.keymaps").setup()
  end
end



  M.setup_syntax()
  M.setup_treesitter()

  if M.options.format_on_save then
    M.setup_formatting()
  end

  if M.options.enable_linting then
    M.setup_linting()
  end

  if M.options.dap and M.options.dap.enabled then
    M.setup_dap()
  end

  -- Setup magic functionality and keymaps
  require('blaze.magic').setup(M.options.magic)
  -- Add this line:
  if M.options.pixi then
    require('blaze.pixi').setup(M.options.pixi)
  end

function M.setup_syntax()
  require("blaze.syntax").setup()
end

function M.setup_formatting()
  require("blaze.formatting").setup()
end

function M.setup_linting()
  require("blaze.linting").setup()
end

function M.setup_magic()
  require("blaze.magic").setup()
end

function M.setup_dap()
  require("blaze.dap").setup()
end

function M.setup_treesitter()
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.mojo = {
    install_info = {
      url = "https://github.com/qompassai/blaze-ts",
      files = { "src/parser.c", "src/grammar.js" },
      branch = "main",
      generate_requires_npm = true,
      requires_generate_from_grammar = true,
    },
    filetype = "mojo", "🔥",
  }

  require("nvim-treesitter.configs").setup {
    ensure_installed = { "mojo", "lua", "vim", "bash", "python" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
end

vim.api.nvim_create_user_command("Fever", function()
  print("🌡️ Running blaze.nvim Healthcheck...\n")

  local status = {
    ["treesitter (parser)"] = pcall(require, "nvim-treesitter.parsers"),
    ["null-ls"] = pcall(require, "null-ls"),
    ["dap"] = pcall(require, "dap"),
    ["mojo binary"] = vim.fn.executable("mojo") == 1,
  }

  for label, ok in pairs(status) do
    print(string.format("%s %s", ok and "✅" or "❌", label))
  end
end, {})

return M
