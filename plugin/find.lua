vim.cmd 'cabbrev sf find'

local finders = {
  'fd --type f --hidden --exclude .git',
  'rg --files --hidden --glob "!.git/*"',
}

local detect_finder_cmd = function()
  for _, cmd in pairs(finders) do
    if vim.fn.executable(vim.split(cmd, ' ')[1]) == 1 then
      return cmd
    end
  end

  vim.notify('No file finder (fd, rg) found! Falling back to find.', vim.log.levels.WARN)

  return 'find . -type f -not -path "*/\\.git/*" | sed "s|^\\./||"'
end

local finder_cmd = detect_finder_cmd()

local find_complete_func = function(arg)
  -- Get git root or fallback to cwd
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local root = vim.v.shell_error == 0 and git_root or vim.fn.getcwd()

  local find = string.format('cd %s && ' .. finder_cmd, vim.fn.shellescape(root))
  local all_files = vim.fn.systemlist(find)
  if arg == '' then
    return all_files
  end

  return require('utils').match_with_wildoptions(all_files, arg)
end

_G.FindFunct = find_complete_func
vim.opt.findfunc = 'v:lua.FindFunct'
