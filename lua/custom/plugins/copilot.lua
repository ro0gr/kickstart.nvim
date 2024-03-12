return {
  'github/copilot.vim',
  config = function()
    vim.keymap.set('i', '<M-S-W>', '<Plug>(copilot-accept-word)')
  end,
}
