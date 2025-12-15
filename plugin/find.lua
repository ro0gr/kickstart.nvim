-- TODO:
--  - support opening in splits/tabs via ctrl-s, ctrl-v, ctrl-t.
--  - ctrl-q to send opened wildmenu completions to quickfix list.

local find_complete_func = function(arg)
  -- Get git root or fallback to cwd
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local root = vim.v.shell_error == 0 and git_root or vim.fn.getcwd()
  -- Use fd or find to get all files from root
  local find_cmd
  if vim.fn.executable 'fd' == 1 then
    find_cmd = string.format('cd %s && fd --type f --hidden --exclude .git', vim.fn.shellescape(root))
  else
    find_cmd = string.format('cd %s && find . -type f -not -path "*/\\.git/*" | sed "s|^\\./||"', vim.fn.shellescape(root))
  end
  local all_files = vim.fn.systemlist(find_cmd)

  if arg == '' then
    return all_files
  end

  return vim.fn.matchfuzzy(all_files, arg)
end

_G.FindFunct = find_complete_func
vim.opt.findfunc = 'v:lua.FindFunct'

vim.cmd 'cabbrev sf find'
vim.cmd 'cabbrev ssf sfind'
vim.cmd 'cabbrev vsf vertical sfind'
vim.cmd 'cabbrev tsf tabfind'

-- Auto-recalculate on cmdline changes
vim.api.nvim_create_autocmd('CmdlineChanged', {
  pattern = ':',
  callback = function()
    local cmdline = vim.fn.getcmdline()

    -- Check if it's a find command
    local is_find_cmd = cmdline:match '^s?find%s' or cmdline:match '^tabfind%s' or cmdline:match '^vertical%s+sfind%s'

    if not is_find_cmd then
      return
    end

    vim.fn.wildtrigger()
  end,
})
