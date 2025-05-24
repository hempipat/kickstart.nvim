-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- lazy.nvim
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
      presets = {
        lsp_doc_border = true, -- add a border to hover docs and signature help
        inc_rename = true,
      },
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
        -- format = {
        --   cmdline = { pattern = '', icon = '󱐌 :', lang = 'vim' },
        --   help = { pattern = '^:%s*he?l?p?%s+', icon = ' 󰮦 :' },
        --   search_down = { kind = 'search', pattern = '^/', icon = '/', lang = 'regex' },
        --   search_up = { kind = 'search', pattern = '^%?', icon = '/', lang = 'regex' },
        --   filter = { pattern = '^:%s*!', icon = ' $ :', lang = 'bash' },
        --   lua = {
        --     pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
        --     icon = '  :',
        --     lang = 'lua',
        --   },
        --   input = { view = 'cmdline_input', icon = ' 󰥻 :' }, -- Used by input()
        -- },
      },
      views = {
        popupmenu = {
          relative = 'editor',
          position = {
            row = 8,
            col = '50%',
          },
          win_options = {
            winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
          },
        },
        mini = {
          size = {
            width = 'auto',
            height = 'auto',
            max_height = 15,
          },
          position = {
            row = -2,
            col = '100%',
          },
        },
      },
      lsp = {
        progress = {
          enabled = true,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d' },
              { find = '; before #%d' },
              { find = '%d fewer lines' },
              { find = '%d more lines' },
            },
          },
          opts = { skip = true },
        },
      },
      messages = {
        enabled = false,
      },
      health = {
        checker = true,
      },
      popupmenu = {
        enabled = true,
      },
      signature = {
        enabled = true,
      },
    },

    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module=""` entries
      'MunifTanjim/nui.nvim',
    },
    -- config = function()
    --   local noice = require 'noice'
    --
    --   noice.setup {}
    -- end,
  },
  -- {
  --   'nvimtools/none-ls.nvim',
  --   dependencies = {
  --     'nvimtools/none-ls-extras.nvim',
  --     'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  --   },
  --   config = function()
  --     local null_ls = require 'null-ls'
  --     local formatting = null_ls.builtins.formatting -- to setup formatters
  --     local diagnostics = null_ls.builtins.diagnostics -- to setup linters
  --
  --     -- list of formatters & linters for mason to install
  --     require('mason-null-ls').setup {
  --       ensure_installed = {
  --         'prettier', -- ts/js formatter
  --         'shfmt',
  --         'ruff',
  --       },
  --       -- auto-install configured formatters & linters (with null-ls)
  --       automatic_installation = true,
  --     }
  --
  --     local sources = {
  --       diagnostics.checkmake,
  --       formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
  --       formatting.stylua,
  --       formatting.shfmt.with { args = { '-i', '4' } },
  --       formatting.terraform_fmt,
  --       require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
  --       require 'none-ls.formatting.ruff_format',
  --     }
  --
  --     local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
  --     null_ls.setup {
  --       -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
  --       sources = sources,
  --       -- you can reuse a shared lspconfig on_attach callback here
  --       on_attach = function(client, bufnr)
  --         if client.supports_method 'textDocument/formatting' then
  --           vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
  --           vim.api.nvim_create_autocmd('BufWritePre', {
  --             group = augroup,
  --             buffer = bufnr,
  --             callback = function()
  --               vim.lsp.buf.format { async = false }
  --             end,
  --           })
  --         end
  --       end,
  --     }
  --   end,
  -- },
  --zen mode
  {
    'folke/zen-mode.nvim',
    opts = {},
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

    'rcarriga/nvim-notify',
    opts = {
      background_colour = '#000000',
    },
    -- config = function()
    --   require('notify.config').setup {
    --     stages = 'fade',
    --     timeout = 3000,
    --     background_colour = '#000000',
    --     icons = {
    --       ERROR = '',
    --       WARN = '',
    --       INFO = '',
    --       DEBUG = '',
    --       TRACE = '✎',
    --     },
    --   }
    -- vim.notify = require 'notify'
    -- end,
  },
  -- {
  --   'rcarriga/cmp-dap',
  --   dependencies = { 'hrsh7th/nvim-cmp' },
  --   config = function()
  --     require('cmp').setup.filetype({ 'sql', 'plsql' }, {
  --       sources = {
  --         { name = 'vim-dadbod-completion' },
  -- { name = 'buffer' },
  --       },
  --     })
  --   end,
  -- },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    keys = {
      { '<leader>D', '<cmd>DBUIToggle<CR>', desc = 'Toggle DBUI' },
    },
    config = function()
      local home = os.getenv 'HOME'
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_command = home .. './psql-docker.sh'
      vim.g.db_ui_save_location = home .. '/dadbod_ui'
    end,
  },
  -- Move like vim on Tmux
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require('transparent').clear_prefix 'NeoTree'
      require('transparent').clear_prefix 'Telescope'
      require('transparent').clear_prefix 'Notify'
      require('transparent').clear_prefix 'Noice'
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    opts = {},
  },
}
