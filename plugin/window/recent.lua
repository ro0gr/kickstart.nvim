local window_stack = {}

local function push_window(win_id)
  for i, id in ipairs(window_stack) do
    if id == win_id then
      table.remove(window_stack, i)
      break
    end
  end

  table.insert(window_stack, win_id)
end

-- Function to pop the most recent valid window from the stack
local function pop_window()
  while #window_stack > 0 do
    local win_id = table.remove(window_stack)
    if vim.api.nvim_win_is_valid(win_id) then
      return win_id
    end
  end
  return nil
end

vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    push_window(current_win)
  end,
})

vim.keymap.set({ 'n', 't', 'i' }, '<M-Tab>', function()
  vim.cmd 'RecentWindow'
end, { noremap = true, silent = true })

vim.api.nvim_create_user_command('RecentWindow', function()
  vim.print(#window_stack)

  local current_win = vim.api.nvim_get_current_win()
  local previous_win = pop_window()

  if previous_win and previous_win ~= current_win then
    vim.api.nvim_set_current_win(previous_win)

    push_window(current_win)
  end
end, {})
