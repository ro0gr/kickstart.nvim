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

local function open_recent_project(opts)
  local project_nvim = require 'project_nvim'
  local recent_projects = project_nvim.get_recent_projects()

  local mods = opts.mods or ''
  local prompt_prefix = (mods ~= '') and ('[Open ' .. mods .. '] ') or ''

  if #recent_projects == 0 then
    vim.notify('No recent projects found!', vim.log.levels.WARN)
    return
  end

  vim.ui.select(recent_projects, {
    prompt = prompt_prefix .. 'Select Recent Project:',
    kind = 'file',
    format_item = function(item)
      return vim.fn.fnamemodify(item, ':t') .. ' (' .. item .. ')'
    end,
  }, function(selected)
    if selected then
      local cmd = (mods ~= '') and mods .. ' new' or 'edit'

      vim.cmd(cmd .. ' ' .. selected)
      vim.cmd.cd(selected)
      vim.notify('Switched to project: ' .. selected)
    end
  end)
end

vim.api.nvim_create_user_command('ProjectSelect', open_recent_project, {
  desc = 'Open a recent project using project.nvim',
})

return {
  {
    'ahmedkhalf/project.nvim',

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

      vim.api.nvim_set_keymap('n', '<C-w>gsp', '<cmd>tab ProjectSelect<CR>', { noremap = true, silent = true, desc = '[S]earch [P]rojects' })
      vim.api.nvim_set_keymap('n', 'gsp', '<cmd>ProjectSelect<CR>', { noremap = true, silent = true, desc = '[S]earch [P]rojects' })
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
