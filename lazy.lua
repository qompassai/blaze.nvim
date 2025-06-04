-- /qompassai/diver/lua/plugins/lang/mojo.lua
-- ----------------------------------------
-- copyright (c) 2025 qompass ai, all rights reserved
return {
  {
    'qompassai/blaze.nvim',
    ft = { 'mojo', '🔥' },
    init = function()
      vim.g.blaze_no_auto_setup = true
    end,
    opts = {
      format_on_save = true,
      enable_linting = true,
      indentation = {
        expandtab = true,
        shiftwidth = 4,
        closed_paren_align_last_line = true,
        continue = 'shiftwidth() * 2',
      },
      dap = {
        enabled = true,
      },
      lsp = {
        enabled = true,
        mojo = {
          enabled = true,
          config = {
            handlers = {
              ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = 'rounded',
              }),
              ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = 'rounded',
              }),
            },
            on_attach = function(client, bufnr)
              vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
              local opts = { buffer = bufnr, silent = true }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set('n', '<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, opts)
              vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<leader>f', function()
                vim.lsp.buf.format({ async = true })
              end, opts)
            end,
            settings = {
              mojo = {
                modularHomePath = vim.env.MODULAR_HOME or (vim.env.HOME .. '/.modular'),
                enableInlayHints = true,
                enableCompletion = true,
                enableDiagnostics = true,
              },
            },
            root_dir = function(fname)
              local lspconfig = require('lspconfig')
              return lspconfig.util.find_git_ancestor(fname) or lspconfig.util.find_node_modules_ancestor(fname) or vim.fn.getcwd()
            end,
            init_options = {},
          },
        },
      },
      filetypes = {
        emoji_extension = true,
      },
      pixi = {
        enabled = true,
        auto_detect = true,
        keymaps = {
          enabled = true,
          prefix = '<leader>p',
        },
        display = {
          method = 'float',
          height = 15,
          width = 80,
        },
      },
      magic = {
        enabled = true,
        show_output = true,
        commands = {
          list = true,
        },
      },
      syntax = {
        enabled = true,
        treesitter = {
          enabled = true,
        },
        fallback = {
          enabled = true,
          highlight_all = true,
        },
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'jay-babu/mason-nvim-dap.nvim',
      'mfussenegger/nvim-dap-python',
      'nvimtools/none-ls.nvim',
      'zeioth/none-ls-autoload.nvim',
    },
  },
  {
    'qompassai/blaze-ts.nvim',
    ft = { 'mojo', '🔥' },
    opts = {
      parser = {
        install_dir = vim.fn.stdpath('data') .. '/lazy/blaze-ts.nvim/parser',
        auto_install = true,
      },
      nvim_treesitter = {
        ensure_installed = { 'mojo' },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            node_decremental = '<bs>',
          },
        },
        parser_config = {
          mojo = {
            install_info = {
              url = 'https://github.com/qompassai/blaze-ts.nvim',
              files = { 'src/parser.c', 'src/grammar.js' },
              branch = 'main',
              requires_generate_from_grammar = false,
            },
            filetype = { 'mojo', '🔥' },
            maintainers = { '@qompassai' },
          },
        },
      },
    },
  },
}
