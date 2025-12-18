vim.pack.add { 'https://github.com/NickvanDyke/opencode.nvim' }

-- Required for `opts.events.reload`.
vim.o.autoread = true

vim.keymap.set({ 'n', 't' }, '<M-a>', function()
  require('opencode').toggle()
end, { desc = 'Toggle opencode' })

vim.keymap.set({ 'n', 'x' }, 'ga', function()
  return require('opencode').operator '@this '
end, { expr = true, desc = 'Add range to opencode([A]I)' })
vim.keymap.set('n', 'goo', function()
  return require('opencode').operator '@this ' .. '_'
end, { expr = true, desc = 'Add line to opencode' })

vim.keymap.set('n', '<S-C-u>', function()
  require('opencode').command 'session.half.page.up'
end, { desc = 'opencode half page up' })
vim.keymap.set('n', '<S-C-d>', function()
  require('opencode').command 'session.half.page.down'
end, { desc = 'opencode half page down' })

vim.cmd.cabbrev('sai', 'lua require("opencode").select()<CR>')
vim.cmd.cabbrev('aiask', 'lua require("opencode").ask("@this: ", { submit = true })<CR>')
