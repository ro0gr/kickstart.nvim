local function colorscheme_exists(name)
  -- Check if the colorscheme is available in the runtimepath
  for _, colorscheme in ipairs(vim.fn.getcompletion('', 'color')) do
    if name == colorscheme then
      return true
    end
  end

  return nil
end

local last_known_colorscheme = nil
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    if vim.g.colors_name then
      last_known_colorscheme = vim.g.colors_name
    end
  end,
})

-- Try to switch to an alternative colorscheme variant when background option is changed,
-- based on the different naming conventions and current background value(dark/light).
--
-- There are many themes that don't support automatic background switching.
-- Many of them use dark, light in the name, so user should choose a proper theme name manually.
-- For such themes things like auto-dark-mode don't work out of the box.
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = function()
    vim.schedule(function()
      local bg = vim.o.background
      local current_colorscheme = vim.g.colors_name or last_known_colorscheme

      -- if current_colorscheme contains the bg in its name, do nothing
      if not current_colorscheme or current_colorscheme:find(bg) then
        return
      end

      local smart_replace_name = (bg == 'light' and current_colorscheme:find 'dark') and current_colorscheme:gsub('dark', 'light')
        or (bg == 'dark' and current_colorscheme:find 'light') and current_colorscheme:gsub('light', 'dark')
        or nil

      local candidates = {
        smart_replace_name,
        current_colorscheme .. '_' .. bg,
      }

      local alt_colorscheme = vim.tbl_filter(function(item)
        return colorscheme_exists(item) ~= nil
      end, candidates)

      if alt_colorscheme and alt_colorscheme[1] then
        vim.notify('Switching colorscheme to ' .. alt_colorscheme[1])

        vim.cmd.colorscheme(alt_colorscheme[1])
      end
    end)
  end,
})

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
