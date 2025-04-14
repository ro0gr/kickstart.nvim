return {
  'ellisonleao/gruvbox.nvim',
  'NLKNguyen/papercolor-theme',

  'altercation/vim-colors-solarized',

  'rakr/vim-one',

  'morhetz/gruvbox',

  { 'catppuccin/nvim', name = 'catppuccin' },
  'navarasu/onedark.nvim',
  'rebelot/kanagawa.nvim',
  'jacoborus/tender.vim',
  -- vim.cmd.colorscheme 'oxocarbon'
  -- vim.cmd.colorscheme 'carbonfox'
  'nyoom-engineering/oxocarbon.nvim',
  'projekt0n/caret.nvim',
  'sainnhe/everforest',
  'sainnhe/edge',
  --   'EdenEast/nightfox.nvim',
  'scottmckendry/cyberdream.nvim',
  'fynnfluegge/monet.nvim',
  { 'projekt0n/github-nvim-theme', name = 'github-theme' },
  'dgox16/oldworld.nvim',
  {

    'folke/tokyonight.nvim',
    -- config = function()
    --   ---@diagnostic disable-next-line: missing-fields
    --   require('tokyonight').setup {
    --     styles = {
    --       comments = { italic = false }, -- Disable italics in comments
    --     },
    --   }
    --
    --   -- Load the colorscheme here.
    --   -- Like many other themes, this one has different styles, and you could load
    --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    --   vim.cmd.colorscheme 'tokyonight-night'
    -- end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
  },
  { 'savq/melange-nvim' },
  {
    'zenbones-theme/zenbones.nvim',
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    -- 'rose-pine/neovim',
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.opt.background = 'light'

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'catppuccin'
      -- vim.cmd.colorscheme 'rose-pine-dawn'

      -- vim.cmd.colorscheme 'caret'
      -- vim.cmd.colorscheme 'tokyonight-day'
      -- vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.colorscheme 'catppuccin-latte'
      -- vim.cmd.colorscheme 'oxocarbon'
      -- vim.cmd.colorscheme 'github_light'
      -- vim.cmd.colorscheme 'kanagawa'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
