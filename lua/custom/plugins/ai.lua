return {
  {
    'github/copilot.vim',
    config = function()
      vim.keymap.set('i', '<M-S-W>', '<Plug>(copilot-accept-word)')
    end,
  },

  -- require 'custom.plugins.ai.codecompanion',
  --
  require 'custom.plugins.ai.avante',
}
