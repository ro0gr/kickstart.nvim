vim.diagnostic.config {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = {
    priority = 9999,
    severity = {
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.ERROR,
    },
  },

  -- Show all diagnostics as underline (for their messages type `<Leader>ld`)
  underline = { severity = vim.diagnostic.severity.HINT },

  -- Show more details immediately for errors on the current line
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
