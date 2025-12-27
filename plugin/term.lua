-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local build_tmux_cmd = function(project_name)
  return 'tmux new -A -t "' .. project_name .. '"'
end

vim.api.nvim_create_user_command('TermProjectFocus', function()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local bufnr = -1
  local cmd = build_tmux_cmd(project_name)

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if string.find(buf_name, cmd, 1, true) then
      bufnr = buf
      break
    end
  end

  if bufnr == -1 then
    vim.cmd 'topleft new'
    vim.cmd('terminal ' .. cmd)
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
  desc = 'Toggle [t]erminal with tmux session named after current working directory',
})

local function is_terminal_buffer()
  return vim.bo.buftype == 'terminal'
end

local send_termcode = function(key)
  local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(termcode, 't', true)
end

local setup_terminal_keymap = function(key, desc)
  vim.keymap.set('n', key, function()
    if not is_terminal_buffer() then
      -- Pass through normally for non-terminal buffers
      return key
    end

    if vim.api.nvim_get_mode().mode == 't' then
      send_termcode(key)
      return ''
    end

    vim.schedule(function()
      vim.cmd 'startinsert'

      vim.defer_fn(function()
        send_termcode(key)
      end, 200)
    end)

    return ''
  end, {
    expr = true, -- Allows conditional return
    silent = true,
    desc = desc,
  })
end

setup_terminal_keymap('<C-c>', 'Send Ctrl+c(interrupt) to terminal (auto-insert mode)')
setup_terminal_keymap('<C-b>', 'Send Ctrl+b(tmux leader) to terminal (auto-insert mode)')
