-- update highlights when switching windows
vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  callback = function()
    vim.schedule(function()
      vim.cmd 'set winhighlight=Normal:Normal' -- Restore normal highlight
    end)
  end,
})

vim.api.nvim_create_autocmd('WinLeave', {
  pattern = '*',
  callback = function()
    vim.cmd 'set winhighlight=Normal:NormalNC' -- Apply dim highlight
  end,
})

-- Highlight current line only on focused window
vim.api.nvim_create_autocmd('WinLeave', {
  desc = 'Hide cursor line when leaving window',
  callback = function()
    vim.opt.cursorline = false
    vim.opt.colorcolumn = '0' -- Disable color column
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  desc = 'Display cursor line when entering window',
  callback = function()
    vim.opt.cursorline = true
    vim.opt.colorcolumn = '100'
  end,
})
