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
      vim.keymap.set('n', '<leader>gg', '<CMD>tab Git<CR>', { desc = '[G]it' })
      vim.keymap.set('n', '<leader>gb', '<CMD>Gitsigns blame<CR>', { desc = '[G]it [b]lame' })
      vim.keymap.set('n', '<leader>tgb', '<CMD>Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [b]lame' })
      vim.keymap.set('n', '<leader>gl', '<CMD>Flog<CR>', { desc = '[G]it [l]og' })
      vim.keymap.set('n', '<leader>gd', '<CMD>Gitsigns diffthis<CR>', { desc = '[G]it [d]iff file' })
      vim.keymap.set('n', '<leader>gp', '<CMD>Git! ps --force-with-lease<CR>', { desc = '[G]it [p]ush' })
    end,
  },
  'tommcdo/vim-fubitive',
  'tpope/vim-rhubarb',
  {
    'sindrets/diffview.nvim',
    config = function()
      vim.keymap.set('n', '<leader>gs', '<CMD>DiffviewOpen<CR>', { desc = '[G]it [s]tatus' })
    end,
  },
  {
    'rbong/vim-flog',
    lazy = true,
    cmd = { 'Flog', 'Flogsplit', 'Floggit' },
    dependencies = {
      'tpope/vim-fugitive',
    },
  },
}
