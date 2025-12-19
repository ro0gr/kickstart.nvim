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
  -- I'd like to notice when the project root changes
  silent_chdir = false,
  -- allow open projects alongside each other in different splits
  scope_chdir = 'win',
}

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/Shatur/neovim-session-manager',
}

require('session_manager').setup {
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
}

vim.api.nvim_create_user_command('Projects', function(opts)
  if not opts.args or opts.args == '' then
    return
  end

  local selected = opts.args
  local mods = opts.mods or ''
  local cmd = (mods ~= '') and mods .. ' new' or 'edit'

  vim.cmd(cmd .. ' ' .. selected)
  vim.cmd.lcd(selected)
  vim.notify('Switched to project: ' .. selected)
end, {
  desc = 'Open a recent project using project.nvim',
  nargs = 1,
  complete = function(arglead)
    local project_nvim = require 'project_nvim'
    local recent_projects = project_nvim.get_recent_projects()

    -- If no input yet, return all projects
    if arglead == '' then
      return recent_projects
    end

    local utils = require 'utils'
    return utils.match_with_wildoptions(recent_projects, arglead)
  end,
})

vim.cmd 'cabbrev tsp tab Projects'
vim.cmd 'cabbrev vsp vert Projects'
vim.cmd 'cabbrev ssp horizontal Projects'
vim.cmd 'cabbrev sp Projects'
