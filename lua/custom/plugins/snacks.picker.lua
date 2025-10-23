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
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      'gsf',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      'gsg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      'gsa',
      function()
        Snacks.picker()
      end,
      desc = '[S]earch [A]ll Pickers',
    },
    {
      'gsb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = '[S]earch [B]ranches',
    },
    {
      'gsr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      'gsn',
      function()
        Snacks.picker.files {
          dirs = { vim.fn.stdpath 'config' },
        }
      end,
      desc = '[S]earch [N]eovim files',
    },
    {
      'gsc',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = '[S]earch [C]olorschemes',
    },
    {
      'gsh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      'gsd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
  },
}
