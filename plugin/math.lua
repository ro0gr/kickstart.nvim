-- user command to sum all the lines
vim.api.nvim_create_user_command('SumLines', function()
  local sum = 0
  for _, line in ipairs(vim.fn.getline(1, '$')) do
    sum = sum + (tonumber(line) or 0)
  end
  print('Sum of all lines: ' .. sum)
end, { desc = 'Sum all lines in the current buffer' })
