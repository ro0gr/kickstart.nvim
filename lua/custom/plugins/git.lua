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

vim.cmd 'cab G GitTab'
vim.cmd 'cab g Git'
vim.cmd 'cab gs Git switch'
vim.cmd 'cab gsc Git switch -c '
vim.cmd 'cab gpl Git pull origin '
vim.cmd 'cab gps Git! push --force-with-lease '
vim.cmd 'cab gl DiffviewFileHistory'
vim.cmd 'cab gf Git fetch \\|'
vim.cmd 'cab gcp Git cherry-pick '
vim.cmd 'cab gri Git rebase -i @~'
vim.cmd 'cab gro Git rebase --onto origin/main @~'
-- "s" stands for "soft"
vim.cmd 'cab grs Git reset @~'
-- stash/unstash
vim.cmd 'cab gst Git stash'
vim.cmd 'cab grsh Git reset --hard '

-- Toggle the Fugitive buffer
-- If the buffer is not focused, open it. If it is focused, close it.
vim.api.nvim_create_user_command('FugitiveToggle', function()
  local fugitive_buf

  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == 'fugitive' then
      fugitive_buf = buf
      break
    end
  end

  local current_buf = vim.api.nvim_get_current_buf()
  -- if fugitive buffer isn't focused
  if fugitive_buf == nil or current_buf ~= fugitive_buf then
    -- Open(or focus) it
    vim.cmd 'Git'
  else
    vim.api.nvim_buf_delete(fugitive_buf, { force = true })
  end
end, {
  desc = 'Toggle Fugitive buffer',
  nargs = 0,
})

vim.keymap.set({ 'n', 'i' }, '<M-g>', '<CMD>FugitiveToggle<CR>', { desc = 'Fu[g]itive toggle' })

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
  {
    'sindrets/diffview.nvim',
    config = function()
      vim.keymap.set('n', '<leader>gl', '<CMD>DiffviewFileHistory<CR>', { desc = '[G]it [l]og' })
    end,
  },
}
