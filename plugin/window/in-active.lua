local function update_color_column_color()
  vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'CursorLine' })
end

-- Function to determine if the theme is light or dark
local function is_dark_mode()
  return vim.o.background == 'dark' -- "dark" or "light"
end

-- Function to update dimmed colors based on current theme
local function update_dim_colors()
  local dim_bg

  -- Choose dim color based on light/dark mode
  if is_dark_mode() then
    dim_bg = '#333333' -- Darker shade for dark themes
  else
    dim_bg = '#DDDDDD' -- Lighter shade for light themes
  end

  -- Set highlight for inactive windows
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = dim_bg })
end

-- update highlights when switching windows
vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  callback = function()
    vim.cmd 'set winhighlight=Normal:Normal' -- Restore normal highlight
  end,
})

vim.api.nvim_create_autocmd('WinLeave', {
  pattern = '*',
  callback = function()
    vim.cmd 'set winhighlight=Normal:NormalNC' -- Apply dim highlight
  end,
})

-- Automatically update colors when the colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    update_dim_colors()

    update_color_column_color()
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

vim.schedule(function()
  update_color_column_color()
  update_dim_colors()
end)
