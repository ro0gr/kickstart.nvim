return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    picker = {
      enabled = true,

      matcher = {
        frecency = true,
        frecency_bonus = true,
        history_bonus = true,
      },
    },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    terminal = { enabled = true },
  },
  keys = {
    -- Top Pickers & Explorer
    {
      'gs<Space>',
      function()
        require('snacks').picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      'gsf',
      function()
        require('snacks').picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader><leader>',
      function()
        require('snacks').picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      'gsg',
      function()
        require('snacks').picker.grep {}
      end,
      desc = '[S]earch [G]rep',
    },
    {
      'gsw',
      function()
        require('snacks').picker.grep_word {}
      end,
      desc = '[S]earch [W]ord',
    },
    {
      'gsa',
      function()
        require('snacks').picker()
      end,
      desc = '[S]earch [A]ll Pickers',
    },
    {
      'gsb',
      function()
        require('snacks').picker.git_branches()
      end,
      desc = '[S]earch [B]ranches',
    },
    {
      'gsr',
      function()
        require('snacks').picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      'gsn',
      function()
        require('snacks').picker.files {
          dirs = { vim.fn.stdpath 'config' },
        }
      end,
      desc = '[S]earch [N]eovim files',
    },
    {
      'gsc',
      function()
        require('snacks').picker.colorschemes()
      end,
      desc = '[S]earch [C]olorschemes',
    },
    {
      'gsh',
      function()
        require('snacks').picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      'gsd',
      function()
        require('snacks').picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
  },
}
