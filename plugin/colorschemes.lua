vim.pack.add {
  'https://github.com/3dyuval/retro-fallout.nvim',
  'https://github.com/NLKNguyen/papercolor-theme',
  'https://github.com/NTBBloodbath/doom-one.nvim',
  'https://github.com/altercation/vim-colors-solarized',
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/oskarnurm/koda.nvim',
  'https://github.com/projekt0n/caret.nvim',
  'https://github.com/rakr/vim-one',
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/rktjmp/lush.nvim', -- dependency for zenbones
  'https://github.com/sainnhe/edge',
  'https://github.com/sainnhe/everforest',
  'https://github.com/savq/melange-nvim',
  'https://github.com/zenbones-theme/zenbones.nvim',
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
}

local function update_color_column_color()
  vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'CursorLine' })
end

-- Function to determine if the theme is light or dark
local function is_dark_mode()
  return vim.opt.background:get() == 'dark' -- "dark" or "light"
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

local update_callback = function()
  update_dim_colors()
  update_color_column_color()
end

-- Automatically update colors when the colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = update_callback,
})

-- also update on background change
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = update_callback,
})

vim.schedule(update_callback)

-- restore project colorscheme on session load
--
vim.opt.sessionoptions:append 'globals'

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = 'SessionSavePre',
  callback = function()
    vim.g.SessionColorscheme = vim.g.colors_name
  end,
})

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = 'SessionLoadPost',
  callback = function()
    if vim.g.SessionColorscheme then
      vim.cmd.colorscheme(vim.g.SessionColorscheme)
    end
  end,
})
