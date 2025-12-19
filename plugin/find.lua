-- TODO:
--  - ctrl-q to send opened wildmenu completions to quickfix list.

vim.cmd 'cabbrev sf find'
vim.cmd 'cabbrev ssf sfind'
vim.cmd 'cabbrev vsf vertical sfind'
vim.cmd 'cabbrev tsf tabfind'

local find_complete_func = function(arg)
  -- Get git root or fallback to cwd
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local root = vim.v.shell_error == 0 and git_root or vim.fn.getcwd()
  -- Use fd or find to get all files from root
  local find_cmd
  if vim.fn.executable 'fd' == 1 then
    find_cmd = string.format('cd %s && fd --type f --hidden --exclude .git', vim.fn.shellescape(root))
  elseif vim.fn.executable 'rg' == 1 then
    find_cmd = string.format('cd %s && rg --files --hidden --glob "!.git/*"', vim.fn.shellescape(root))
  else
    find_cmd = string.format('cd %s && find . -type f -not -path "*/\\.git/*" | sed "s|^\\./||"', vim.fn.shellescape(root))
  end
  local all_files = vim.fn.systemlist(find_cmd)

  if arg == '' then
    return all_files
  end

  local utils = require 'utils'
  return utils.match_with_wildoptions(all_files, arg)
end

_G.FindFunct = find_complete_func
vim.opt.findfunc = 'v:lua.FindFunct'

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

local function find_to_split(split_cmd, fallback_key)
  return function()
    local cmdline = vim.fn.getcmdline()
    local filename = cmdline:match '^%s*find%s+(.+)$'

    if filename then
      local resolved = vim.fn.findfile(filename, vim.o.path)

      if resolved ~= '' then
        -- Escape the path to handle spaces and special characters
        local escaped_path = vim.fn.fnameescape(resolved)
        return vim.api.nvim_replace_termcodes('<C-u>' .. split_cmd .. ' ' .. escaped_path .. '<CR>', true, false, true)
      else
        vim.schedule(function()
          vim.notify('File not found: ' .. filename, vim.log.levels.ERROR)
        end)
        return ''
      end
    end

    -- Not a find command, return the literal key that was pressed
    return vim.api.nvim_replace_termcodes(fallback_key, true, false, true)
  end
end

-- Register the three keymaps
vim.keymap.set('c', '<C-v>', find_to_split('vsplit', '<C-v>'), { expr = true, desc = 'Convert :find to :vsplit with resolved path' })
vim.keymap.set('c', '<C-s>', find_to_split('split', '<C-s>'), { expr = true, desc = 'Convert :find to :split with resolved path' })
vim.keymap.set('c', '<C-t>', find_to_split('tabedit', '<C-t>'), { expr = true, desc = 'Convert :find to :tabedit with resolved path' })
