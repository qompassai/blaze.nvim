local M = {}

function M.setup()
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

  parser_config.mojo = {
    install_info = {
      url = "https://github.com/qompassai/blaze-ts",
      files = { "src/parser.c", "src/grammar.js" },
      branch = "main",
      generate_requires_npm = true,
      requires_generate_from_grammar = true,
    },
    filetype = "mojo" ,
  }

   -- 2. Filetype detection
  vim.filetype.add({
    extension = {
      mojo = "mojo",
      ["🔥"] = "mojo",
    },
    pattern = {
      [".*%.mojo"] = "mojo",
      [".*%.🔥"] = "mojo",
      [".*%.fire"] = "mojo",  -- Alternative extension
    },
  })
  vim.g.mojo_highlight_all = 1
end

return M

