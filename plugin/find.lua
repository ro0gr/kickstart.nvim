vim.cmd 'cabbrev sf SearchFile'

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
  -- -- Get git root or fallback to cwd
  -- local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  -- local root = vim.v.shell_error == 0 and git_root or vim.fn.getcwd()
  --
  local root = vim.fn.getcwd()

  local find = string.format('cd %s && ' .. finder_cmd, vim.fn.shellescape(root))
  local all_files = vim.fn.systemlist(find)
  if arg == '' then
    return all_files
  end

  return require('utils').match_with_wildoptions(all_files, arg)
end

_G.FindFunct = find_complete_func
vim.opt.findfunc = 'v:lua.FindFunct'

-- :SearchFile
-- Search for a file in the current git repository or cwd if not in a git repo.
-- Reuse FindFunct for cmdline completion, but let's also use vim.fn.getbufinfo({ buflisted = 1 })
-- that should be prioritized and sorted by the lastused the completion list,
-- so that they appear at the top of the list.
--
-- Completion should support fuzzy matching.
-- no ui input, select. Just plain vim cmdline interface.
vim.api.nvim_create_user_command('SearchFile', function(options)
  local file = options.args
  if file == '' then
    return
  end

  vim.cmd.edit(file)
end, {
  desc = 'Search for a file in the current git repository or cwd if not in a git repo',
  complete = function(arg)
    local listed_buffers = vim.fn.getbufinfo { buflisted = 1 }
    table.sort(listed_buffers, function(a, b)
      return a.lastused > b.lastused
    end)

    local listed_buffer_names = {}
    for _, buf in pairs(listed_buffers) do
      table.insert(listed_buffer_names, vim.fn.fnamemodify(buf.name, ':~:.'))
    end

    if arg == '' then
      return listed_buffer_names
    end

    local files = find_complete_func(arg)
    -- all_files should have listed buffers at the top, followed by the rest of the files in the cwd. No duplicates.
    local all_files = vim.list_extend(listed_buffer_names, files)
    -- Remove duplicates while preserving order
    local seen = {}
    local unique_files = {}
    for _, file in pairs(all_files) do
      if not seen[file] then
        table.insert(unique_files, file)
        seen[file] = true
      end
    end

    return require('utils').match_with_wildoptions(unique_files, arg)
  end,
  nargs = 1,
})

-- Open buffer list and select first item
vim.keymap.set('n', '<C-n>', ':SearchFile <Tab>', { noremap = true, desc = 'Open buffer list and select first' })
