-- grep
if vim.fn.executable 'rg' == 1 then
  vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.o.grepformat = '%f:%l:%c:%m'
end

vim.api.nvim_create_user_command('Rg', function(opts)
  local args = opts.fargs
  local pattern = ''
  if #args == 0 then
    pattern = vim.fn.input 'Rg pattern: '
  elseif #args == 1 then
    pattern = args[1]
  else
    print 'Usage: Rg <pattern> [path]'
    return
  end

  local path = '.'

  vim.cmd('silent grep! ' .. pattern .. ' ' .. path .. ' | copen')
end, {
  nargs = '*',
  desc = 'Search for a pattern using rg and populate the quickfix list',
})

vim.keymap.set('n', 'gsg', '<cmd>Rg<CR>', {
  desc = 'Search for a pattern using rg and populate the quickfix list',
})

vim.keymap.set('v', 'gsg', function()
  local saved_reg = vim.fn.getreg '"'
  vim.cmd 'normal! "vy'
  local pattern = vim.fn.getreg 'v'
  vim.fn.setreg('"', saved_reg)

  vim.cmd('silent grep! ' .. pattern .. ' . | copen')
end, {
  desc = 'Search for selected text using rg and populate the quickfix list',
})
