local project_root_markers = {
  '.git',
}

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

vim.cmd 'cabbrev sp Projects'
