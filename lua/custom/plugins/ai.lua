return {
  {
    'github/copilot.vim',
    config = function()
      vim.g.copilot_node_command = vim.g.node_host_prog

      vim.keymap.set('i', '<M-S-W>', '<Plug>(copilot-accept-word)')
    end,
  },

  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
    config = function()
      require('mcphub').setup()
    end,
  },

  require 'custom.plugins.ai.codecompanion',
  require 'custom.plugins.ai.sidekick',
}
