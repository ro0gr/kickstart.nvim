return {
  {
    'utilyre/sentiment.nvim',
    enabled = false,
    version = '*',
    event = 'VeryLazy', -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
}
