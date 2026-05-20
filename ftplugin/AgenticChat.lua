vim.treesitter.start(0, 'markdown')

vim.keymap.set('n', '<C-c>', function()
  require('agentic').stop_generation()
end, { buffer = true, desc = 'Stop Agentic generation' })
