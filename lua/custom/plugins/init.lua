vim.cmd 'cab Q q'
vim.cmd 'cab W w'
vim.cmd 'cab Wq wq'
vim.cmd 'cab Qa qa'

-- Highlight current line only on focused window
vim.api.nvim_create_autocmd('WinLeave', {
  desc = 'Hide cursor line when leaving window',
  callback = function()
    vim.opt.cursorline = false
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  desc = 'Display cursor line when entering window',
  callback = function()
    vim.opt.cursorline = true
  end,
})

vim.keymap.set('n', '<C-c>', function()
  vim.cmd 'startinsert'
end, { noremap = true, silent = true })

local orig_scrolloff

local function zzAndToggleScrolloff()
  if orig_scrolloff == nil then
    orig_scrolloff = vim.opt.scrolloff:get()
  end

  vim.cmd 'normal! zz'

  if 9999 == vim.opt.scrolloff:get() then
    vim.notify 'Setting scrolloff to original value'
    vim.opt.scrolloff = orig_scrolloff
    vim.opt.cursorline = true
    -- vim.opt.number = true
    -- vim.opt.relativenumber = true
  else
    vim.notify 'Setting scrolloff to 9999'
    vim.opt.scrolloff = 9999
    vim.opt.cursorline = false
    -- vim.opt.number = false
    -- vim.opt.relativenumber = true
  end
end

vim.keymap.set('n', 'zZ', zzAndToggleScrolloff, { noremap = true })
vim.keymap.set('n', '<Leader>Tc', ':TSContextToggle<CR>', { noremap = true })

vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })
vim.keymap.set('n', '*', '*zz', { noremap = true })
vim.keymap.set('n', '#', '#zz', { noremap = true })
vim.keymap.set('n', 'g*', 'g*zz', { noremap = true })
vim.keymap.set('n', 'g#', 'g#zz', { noremap = true })

-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    config = function()
      vim.opt.spelllang = { 'en', 'programming' }
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }

      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },

  {
    'mawkler/demicolon.nvim',
    -- keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' }, -- Uncomment this to lazy load
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('demicolon').setup {
        keymaps = {
          repeat_motions = false,
        },
      }

      local nxo = { 'n', 'x', 'o' }

      vim.keymap.set(nxo, ';', require('demicolon.repeat_jump').next)
      vim.keymap.set(nxo, ',', require('demicolon.repeat_jump').prev)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      -- mode = 'topline',
    },
  },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- Example mapping to toggle outline
      { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      outline_window = {
        position = 'left',
      },
      -- Your setup opts here
    },
  },

  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'virtual',
      enable_named_colors = true,
    },
  },

  {
    'chrishrb/gx.nvim',
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    cmd = { 'Browse' },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true, -- default settings
  },

  {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    opts = {},
  },

  {
    'b0o/SchemaStore.nvim',
    opts = {},
    config = function()
      require('lspconfig').jsonls.setup {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },

  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },

  {
    'tummetott/unimpaired.nvim',
    event = 'VeryLazy',
    opts = {
      keymaps = {
        previous_file = {
          mapping = '[f',
          description = 'Previous file in directory. :colder in qflist',
          dot_repeat = false,
        },
        next_file = {
          mapping = ']f',
          description = 'Next file in directory. :cnewer in qflist',
          dot_repeat = false,
        },
      },
      -- Disable the default mappings if you prefer to define your own mappings
      default_keymaps = false,
      -- add options here if you wish to override the default settings
    },
  },

  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},
    config = function()
      require('fzf-lua').setup {}

      -- it just turns to be called `tabs` in lua
      -- in fact it looks up for windows, not tabs
      -- That's why it's `sw` instead of `st`,
      -- and as a bonus, it's way more convenient to type 🤲
      vim.keymap.set('n', '<Leader>sw', '<CMD>FzfLua tabs<CR>', { noremap = true, desc = '[s]earch [w]indow' })
    end,
  },
}
