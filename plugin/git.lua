vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim',
}

local gitsigns = require 'gitsigns'

gitsigns.setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- visual mode
    map('v', 'ghs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    map('v', 'ghr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })
    -- normal mode
    map('n', 'ghs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', 'ghr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
  end,
}

vim.cmd 'cab gbl Gitsigns blame'
vim.cmd 'cab gbll Gitsigns toggle_current_line_blame'
vim.cmd 'cab gd Gitsigns diffthis'

-- Fugitive and related plugins
vim.pack.add {
  'https://github.com/tpope/vim-fugitive',
  'https://codeberg.org/trevorhauter/gitportal.nvim',
}

local gitportal = require 'gitportal'

gitportal.setup {
  always_include_current_line = true, -- Include the current line in permalinks by default
}

vim.cmd 'cab G Git'
vim.cmd 'cab gs GitSwitch'
vim.cmd 'cab gsc Git switch -c '
vim.cmd 'cab gpl Git! pull origin '
vim.cmd 'cab gps Git! push --force-with-lease '
vim.cmd 'cab gf Git! fetch \\|'
vim.cmd 'cab grs Git reset @~'

-- log
vim.cmd 'cab gl Git ++curwin log --decorate --graph --oneline -100'
vim.cmd 'cab glo Gclog -100'

-- rebase
vim.cmd 'cab gri Git rebase -i'
vim.cmd 'cab gro Git rebase --onto'
vim.cmd 'cab grc Git rebase --continue'
vim.cmd 'cab gra Git rebase --abort'
-- stash/unstash
vim.cmd 'cab gst Git stash'
vim.cmd 'cab grsh Git reset --hard '
vim.cmd 'cab gc Git commit'
vim.cmd 'cab gca Git commit --amend'
vim.cmd 'cab gcp Git cherry-pick '
vim.cmd 'cab gsh Git  ++curwin show'
vim.cmd 'cab gco Git co '
vim.cmd 'cab gb Git ++curwin branch'
vim.cmd 'cab gbm Git branch -m '

-- Toggle the Fugitive buffer
-- If the buffer is not focused, open it. If it is focused, close it.
vim.api.nvim_create_user_command('GitToggle', function()
  local fugitive_buf

  local buffers = vim.api.nvim_list_bufs()
  local git_buffers = {}
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) then
      if vim.bo[buf].filetype == 'fugitive' then
        fugitive_buf = buf
      elseif vim.bo[buf].filetype == 'git' then
        table.insert(git_buffers, buf)
      end
    end
  end

  local current_buf = vim.api.nvim_get_current_buf()

  -- if fugitive buffer isn't focused
  if fugitive_buf == nil or current_buf ~= fugitive_buf then
    -- Open(or focus) it
    vim.cmd 'Git'
  else
    vim.api.nvim_buf_delete(fugitive_buf, { force = true })

    for _, buf in ipairs(git_buffers) do
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, {
  desc = 'Toggle Fugitive buffer',
  nargs = 0,
})

vim.keymap.set({ 'n', 'i', 't' }, '<M-g>', '<CMD>GitToggle<CR>', { desc = 'Fu[g]itive toggle' })

-- :GitSwitch
--
-- auto-complete local branches and remotes sorted by recency
-- fuzzymatch auto-complete.
-- if the branch doesn't exist, create it and switch to it with a confirmation prompt.
vim.api.nvim_create_user_command('GitSwitch', function(opts)
  local selected = opts.args:match '^%s*(.-)%s*$'
  if not selected or selected == '' then
    return
  end

  -- check if the branch exists locally or remotely
  local branch_exists = selected == '-'
  if not branch_exists then
    vim.fn.system('git rev-parse --verify ' .. vim.fn.shellescape(selected) .. ' 2>/dev/null')
    branch_exists = vim.v.shell_error == 0
  end

  if branch_exists then
    vim.cmd('Git switch ' .. selected)
  else
    local confirm = vim.fn.confirm('Branch "' .. selected .. '" does not exist. Create it?', '&Yes\n&No')
    if confirm == 1 then
      vim.cmd('Git switch -c ' .. selected)
    end
  end
end, {
  desc = 'Switch to a git branch',
  nargs = 1,
  complete = function(arglead)
    local branches = vim.fn.systemlist 'git branch --all --sort=-committerdate --format="%(refname:short)"'

    if arglead == '' then
      return branches
    end

    return require('utils').match_with_wildoptions(branches, arglead)
  end,
})
