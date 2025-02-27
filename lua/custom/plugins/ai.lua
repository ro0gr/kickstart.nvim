return {
  {
    'github/copilot.vim',
    config = function()
      vim.keymap.set('i', '<M-S-W>', '<Plug>(copilot-accept-word)')
    end,
  },

  {
    'olimorris/codecompanion.nvim',
    config = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'github/copilot.vim',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
      opts = {
        -- Set debug logging
        log_level = 'DEBUG',
      },
    },
  },
}
