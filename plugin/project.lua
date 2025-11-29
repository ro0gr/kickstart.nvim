vim.opt.sessionoptions:append 'globals,localoptions'

local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands

local project_root_markers = {
  '.git',
}

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

vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter' }, {
  nested = true,
  callback = function()
    if vim.bo.filetype ~= 'oil' then
      return
    end

    local oil_dirname = require('oil').get_current_dir()
    if not oil_dirname then
      -- throw error!
      vim.notify('Could not get oil current dir', vim.log.levels.ERROR)
      return
    end

    local project_path = vim.fs.root(oil_dirname, project_root_markers)
    if project_path then
      require('project_nvim.project').set_pwd(project_path, 'vim.fs.root')
    end
  end,
})

vim.pack.add {
  'https://github.com/ahmedkhalf/project.nvim',
}

require('project_nvim').setup {
  detection_methods = { 'pattern' },
  patterns = project_root_markers,
  -- I'd like to norice when the project root changes
  silent_chdir = false,
  -- allow open projects alongside each other in different splits
  scope_chdir = 'win',
}
vim.api.nvim_set_keymap('n', '<C-w>gsp', '<cmd>tab ProjectSelect<CR>', { noremap = true, silent = true, desc = '[S]earch [P]rojects' })

vim.api.nvim_set_keymap('n', 'gsp', '<cmd>ProjectSelect<CR>', { noremap = true, silent = true, desc = '[S]earch [P]rojects' })

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/Shatur/neovim-session-manager',
}

require('session_manager').setup {
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
}
