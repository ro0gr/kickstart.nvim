return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    }
  end,
}
