vim.pack.add {
  'https://github.com/carlos-algms/agentic.nvim',
}

require('agentic').setup {
  provider = 'opencode-acp',
}

vim.keymap.set({ 'n', 't' }, '<M-a>', function()
  require('agentic').toggle()
end, { desc = 'Toggle agentic' })

vim.keymap.set({ 'n', 'v' }, 'ga', function()
  return require('agentic').add_selection_or_file_to_context()
end, { expr = true, desc = 'Add range to agentic([A]I)' })

vim.keymap.set('n', '<Leader>as', function()
  require('agentic').new_session()
end, { desc = 'New [A]gentic [S]ession' })

vim.o.autoread = true
