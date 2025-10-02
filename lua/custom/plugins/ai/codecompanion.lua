vim.keymap.set({ 'n', 'v' }, '<A-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>ta', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

vim.cmd [[cab cc CodeCompanion]]
vim.cmd [[cab ccc CodeCompanionChat]]

return {
  {
    'olimorris/codecompanion.nvim',
    config = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'github/copilot.vim',
      'ravitemer/mcphub.nvim',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
          keymaps = {
            next_chat = { modes = { n = '<A-]>' } },
            previous_chat = { modes = { n = '<A-[>' } },
          },
        },
        inline = {
          adapter = 'copilot',
        },
      },
      opts = {
        -- Set debug logging
        -- log_level = 'DEBUG',
        extensions = {
          mcphub = {
            callback = 'mcphub.extensions.codecompanion',
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true, -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            },
          },
        },
      },
    },
  },
}
