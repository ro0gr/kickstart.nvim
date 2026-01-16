vim.pack.add {
  'https://github.com/carlos-algms/agentic.nvim',
}

local agentic = require 'agentic'

agentic.setup {
  provider = 'opencode-acp',
}

-- focus the prompt input or close the chat if already focused
vim.keymap.set({ 'n', 't', 'i' }, '<M-a>', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local was_in_insert = vim.api.nvim_get_mode().mode == 'i'

  agentic.open() -- open chat of gain focus

  if vim.api.nvim_get_current_buf() == current_buf and was_in_insert then
    -- if the buffer didn't change, it means we were already in the chat,
    -- so let's treat this as a toggle
    agentic.close()
  end
end, { desc = 'Toggle [a]gentic' })

vim.keymap.set({ 'v' }, '<M-a>', function()
  return agentic.add_selection()
end, { expr = true, desc = 'Add range to agentic([A]I)' })

vim.g.autoread = true
