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
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
}

vim.cmd 'cab tgb Gitsigns blame'
vim.cmd 'cab tgbl Gitsigns toggle_current_line_blame'
vim.cmd 'cab gd Gitsigns diffthis'

-- Fugitive and related plugins
vim.pack.add {
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tommcdo/vim-fubitive',
  'https://github.com/tpope/vim-rhubarb',
}

vim.cmd 'cab G Git'
-- let command line to be closed before toggling.
-- This way, GitToggle internal logic won't false detect the cmdline as the focused buffer
-- and close the Fugitive buffer if needed.
--
-- Use the `t` prefix as a "toggle" abbreviation.
-- Initially I've tried to use just `g` but it conflicts with the `g//` command.
vim.cmd 'cab tg \\| GitToggle'
vim.cmd 'cab gs Git switch'
vim.cmd 'cab gsc Git switch -c '
vim.cmd 'cab gsC Git switch -c '
vim.cmd 'cab gpl Git! pull origin '
vim.cmd 'cab gps Git! push --force-with-lease '
vim.cmd 'cab gl tab vertical Git log --decorate --graph'
vim.cmd 'cab gf Git! fetch \\|'
vim.cmd 'cab gcp Git cherry-pick '
vim.cmd 'cab gr Git rebase '
vim.cmd 'cab gri Git rebase -i @~'
vim.cmd 'cab gro Git rebase --onto origin/'
vim.cmd 'cab grc Git rebase --continue'
vim.cmd 'cab gra Git rebase --abort'
vim.cmd 'cab grs Git reset @~'
-- stash/unstash
vim.cmd 'cab gst Git stash'
vim.cmd 'cab grsh Git reset --hard '
vim.cmd 'cab gc Git commit'
vim.cmd 'cab gca Git commit --amend'
vim.cmd 'cab gw tab Git show'
vim.cmd 'cab gco Git co '
vim.cmd 'cab gb vert Git branch'
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
    vim.cmd 'vert Git'
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
