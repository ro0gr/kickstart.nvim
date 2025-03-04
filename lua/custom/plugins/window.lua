vim.cmd 'cab Q q'
vim.cmd 'cab W w'
vim.cmd 'cab Wq wq'
vim.cmd 'cab Qa qa'

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

-- Autocommands to update highlights when switching windows
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
  callback = update_dim_colors,
})

-- Initial setup
update_dim_colors()

-- Highlight current line only on focused window
vim.api.nvim_create_autocmd('WinLeave', {
  desc = 'Hide cursor line when leaving window',
  callback = function()
    vim.opt.cursorline = false
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  desc = 'Display cursor line when entering window',
  callback = function()
    vim.opt.cursorline = true
  end,
})

return {
  'beauwilliams/focus.nvim',
  config = function()
    require('focus').setup {
      enable = true, -- Enable the plugin
      ui = {
        -- hybridnumber = false, -- Display hybrid line numbers in the focussed window only
        -- absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

        -- cursorline = true, -- Display a cursorline in the focussed window only
        -- cursorcolumn = true, -- Display cursorcolumn in the focussed window only
        -- winhighlight = true, -- auto highlighting for focussed/unfocussed windows
        signcolumn = false,
      },
    }
  end,
}
