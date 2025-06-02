--/qompassai/blaze.nvim/lazy.lua
-- --------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
return {
  'qompassai/blaze.nvim',
  lazy = true,
  ft = { 'mojo', '🔥' },
  config = function()
    vim.g.blaze_no_auto_setup = true
    require('blaze').setup({
      format_on_save = true,
      enable_linting = true,
      dap = {
        enabled = true,
      },
      lsp = {
        enabled = true,
        mojo = {
          enabled = true,
          config = {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            handlers = {
              ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
              }),
              ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
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
                vim.lsp.buf.format { async = true }
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
              return lspconfig.util.find_git_ancestor(fname) 
                or lspconfig.util.find_node_modules_ancestor(fname)
                or vim.fn.getcwd()
            end,
            init_options = {
            },
          },
        },
      },
      indentation = {
        expandtab = true,
        shiftwidth = 4,
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
    })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim', 
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'jay-babu/mason-nvim-dap.nvim',
    'mfussenegger/nvim-dap-python',
    'nvimtools/none-ls.nvim',
    'zeioth/none-ls-autoload.nvim',
    {
      'qompassai/blaze-ts.nvim',
      lazy = true,
      ft = { 'mojo', '🔥' },
    },
  },
}
