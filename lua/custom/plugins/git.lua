local FugitiveTab = function()
  -- if there is already a tab named "Git", focus it
  -- for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
  --   if vim.api.nvim_tabpage_get_var(tab, 'name') == 'Fugitive' then
  --     vim.api.nvim_set_current_tabpage(tab)
  --     return
  --   end
  -- end
  --
  -- or use create new tab
  vim.cmd 'tab Git | tabmove0 | TabRename Fugitive'
end

vim.api.nvim_create_user_command('GitTab', FugitiveTab, {
  desc = 'Opens/Focuses Git in a new tab at the first position',
  nargs = 0,
})

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
-- vim.cmd 'cab gb FzfLua git_branches'
vim.cmd 'cab gb lua Snacks.picker.git_branches()'
vim.cmd 'cab gco Git co '

vim.cmd 'cab tgb Gitsigns blame'
vim.cmd 'cab tgbl Gitsigns toggle_current_line_blame'
vim.cmd 'cab gd Gitsigns diffthis'

vim.keymap.set('n', '<leader>sb', 'lua Snacks.picker.git_branches()', { desc = '[S]earch [B]ranches' })

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
        break
      end

      if vim.bo[buf].filetype == 'git' then
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

return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gv', '<CMD>vertical Git<CR>', { desc = '[G]it [v]ertical' })
      vim.keymap.set('n', '<leader>gt', '<CMD>GitTab<CR>', { desc = '[G]it [t]ab' })
      vim.keymap.set('n', '<leader>gb', '<CMD>Gitsigns blame<CR>', { desc = '[G]it [b]lame' })
      vim.keymap.set('n', '<leader>tgb', '<CMD>Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [b]lame' })
      vim.keymap.set('n', '<leader>gd', '<CMD>Gitsigns diffthis<CR>', { desc = '[G]it [d]iff file' })
      vim.keymap.set('n', '<leader>gp', '<CMD>Git! ps --force-with-lease<CR>', { desc = '[G]it [p]ush' })
    end,
  },
  'tommcdo/vim-fubitive',
  'tpope/vim-rhubarb',
}
