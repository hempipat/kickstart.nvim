-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
      'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
      local null_ls = require 'null-ls'
      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters

      -- list of formatters & linters for mason to install
      require('mason-null-ls').setup {
        ensure_installed = {
          'prettier', -- ts/js formatter
          'shfmt',
          'ruff',
        },
        -- auto-install configured formatters & linters (with null-ls)
        automatic_installation = true,
      }

      local sources = {
        diagnostics.checkmake,
        formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
        formatting.stylua,
        formatting.shfmt.with { args = { '-i', '4' } },
        formatting.terraform_fmt,
        require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
        require 'none-ls.formatting.ruff_format',
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
        sources = sources,
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { async = false }
              end,
            })
          end
        end,
      }
    end,
  },
  -- nvim-cmp
  -- {
  --   'hrsh7th/nvim-cmp',
  -- dependencies = {
  --   'hrsh7th/cmp-nvim-lsp',     -- LSP completion
  --   'hrsh7th/cmp-buffer',       -- Buffer completion
  --   'hrsh7th/cmp-path',         -- Path completion
  --   'hrsh7th/cmp-cmdline',      -- Command line completion
  --   'L3MON4D3/LuaSnip',         -- Snippet engine
  --   'saadparwaiz1/cmp_luasnip', -- Snippet completion
  -- },
  -- config = function()
  --   local cmp = require 'cmp'
  --   cmp.setup {
  --     snippet = {
  --       expand = function(args)
  --         require('luasnip').lsp_expand(args.body)
  --       end,
  --     },
  --     mapping = cmp.mapping.preset.insert {
  --       ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --       ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --       ['<C-Space>'] = cmp.mapping.complete(),
  --       ['<C-e>'] = cmp.mapping.abort(),
  --       ['<CR>'] = cmp.mapping.confirm { select = true },
  --     },
  --     sources = cmp.config.sources {
  --       { name = 'nvim_lsp' },
  --       { name = 'luasnip' },
  --       { name = 'buffer' },
  --       { name = 'path' },
  --     },
  --   }
  --
  --   cmp.setup.cmdline(':', {
  --     mapping = cmp.mapping.preset.cmdline(),
  --     sources = cmp.config.sources {
  --       { name = 'path' },
  --       { name = 'cmdline' },
  --     },
  --   })
  -- end,
  -- },
  --
  {
    'rcarriga/cmp-dap',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('cmp').setup {
        enabled = function()
          -- return vim.api.nvim
        end,
      }

      -- require('cmp').setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
      --   sources = {
      --     { name = 'dap' },
      --   },
      -- })
    end,
  },
}
