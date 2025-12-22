local build_tmux_cmd = function(project_name)
  return 'tmux new -A -t "' .. project_name .. '"'
end

vim.api.nvim_create_user_command('TermProjectFocus', function()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local bufnr = -1
  local term_buf_title = 'tmux(' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~') .. ')'

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if string.find(buf_name, term_buf_title, 1, true) then
      bufnr = buf
      break
    end
  end

  if bufnr == -1 then
    vim.cmd 'topleft new'
    vim.cmd('terminal ' .. build_tmux_cmd(project_name))
    vim.api.nvim_buf_set_name(0, term_buf_title)
  else
    local win_found = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        vim.api.nvim_set_current_win(win)
        win_found = true
        break
      end
    end

    if not win_found then
      vim.cmd('topleft new | buffer ' .. bufnr)
    end
  end

  -- if buffer is insert mode, close the window
  if vim.api.nvim_get_mode().mode == 't' then
    vim.cmd 'hide'

  -- otherwise, enter insert mode
  else
    vim.schedule(function()
      vim.cmd 'startinsert'
    end)
  end
end, {
  desc = 'Toggle terminal with tmux session named after current directory',
})

vim.keymap.set({ 'n', 't', 'i' }, '<M-t>', function()
  vim.cmd 'TermProjectFocus'
end, {
  desc = 'Open terminal with tmux session named after current working directory',
})
