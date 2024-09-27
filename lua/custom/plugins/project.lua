return {
  {
    'ahmedkhalf/project.nvim',
    event = 'VeryLazy',
    opts = {
      detection_methods = { 'pattern', 'lsp' },
      ignore_lsp = { 'lua_ls' },
      patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package-lock.json', '.sln' },
      ---@usage When set to false, you will get a message when project.nvim changes your directory.
      silent_chdir = false,
      scope_chdir = 'tab',
    },
    config = function(_, opts)
      require('project_nvim').setup(opts)
    end,
  },

  'Shatur/neovim-session-manager',
}
