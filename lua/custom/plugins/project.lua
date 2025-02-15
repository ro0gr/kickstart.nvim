return {
  {
    'ahmedkhalf/project.nvim',

    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    event = 'VeryLazy',
    opts = {
      detection_methods = {
        'pattern',
        -- 'lsp'
      },
      ignore_lsp = { 'lua_ls' },
      patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package-lock.json', '.sln' },
      ---@usage When set to false, you will get a message when project.nvim changes your directory.
      silent_chdir = false,
      scope_chdir = 'win',
    },
    config = function(_, opts)
      require('project_nvim').setup(opts)

      local telescope = require 'telescope'
      telescope.load_extension 'projects'

      vim.keymap.set('n', '<leader>sp', telescope.extensions.projects.projects, { desc = '[S]earch [P]rojects' })
    end,
  },

  'Shatur/neovim-session-manager',
}
