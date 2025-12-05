-- File picker with fuzzy completion
--
-- TODO:
--  - support opening in splits/tabs

-- Alternative command that searches from project root
vim.api.nvim_create_user_command('Files', function(opts)
  if opts.args ~= '' then
    -- Get git root or fallback to cwd
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    local root = vim.v.shell_error == 0 and git_root or vim.fn.getcwd()

    local file_path = opts.args
    -- If path is not absolute, make it relative to root
    if not vim.startswith(file_path, '/') then
      file_path = root .. '/' .. file_path
    end

    vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
  end
end, {
  nargs = '?',
  complete = function(arglead, cmdline, cursorpos)
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

    -- If no input yet, return all files
    if arglead == '' then
      return all_files
    end

    -- Use Neovim's built-in matchfuzzy to filter and rank
    return vim.fn.matchfuzzy(all_files, arglead)
  end,
  desc = 'Open file from project root with fuzzy completion',
})

vim.keymap.set('n', 'gsf', ':Files<Space>', { desc = 'Fuzzy find file from project root' })

vim.cmd 'cabbrev sf Files'
