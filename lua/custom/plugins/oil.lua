return {
  {
    'stevearc/oil.nvim',
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {

        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
        },

        win_options = {
          -- make the oil-git-status work
          signcolumn = 'yes:2',
        },

        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,

        keymaps = {
          ['~'] = false, -- I still want to use vim `~` for buffer editing
          ['`'] = false, -- disable for consistency with the `~`
          -- only allow change dir per tab
          ['<Leader>cd'] = 'actions.tcd',
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
  {
    'refractalize/oil-git-status.nvim',

    dependencies = {
      'stevearc/oil.nvim',
    },

    config = function()
      require('oil-git-status').setup {
        show_ignored = true, -- show files that match gitignore with !!
      }
    end,
  },
}
