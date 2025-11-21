vim.opt.sessionoptions:append 'globals,localoptions'

local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = 'SessionSavePre',
  group = config_group,
  callback = function()
    vim.g.SessionColorscheme = vim.g.colors_name
  end,
})

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = 'SessionLoadPost',
  group = config_group,
  callback = function()
    if vim.g.SessionColorscheme then
      vim.cmd.colorscheme(vim.g.SessionColorscheme)
    end
  end,
})

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

  {
    'Shatur/neovim-session-manager',
    lazy = false,
    priority = 10000,
    config = function()
      local session_manager = require 'session_manager'
      session_manager.setup {
        autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
      }
    end,
  },
}
