local function is_nonmodifiable_window(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return not vim.bo[buf].modifiable
end

local function apply_window_style(win, is_active)
  if type(win) ~= 'number' then
    return
  end

  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  if is_active then
    vim.wo[win].winhighlight = ''
    vim.wo[win].cursorline = true
    vim.wo[win].colorcolumn = '100'
    return
  end

  -- TODO: consider buffer-type-specific inactive palettes (for example,
  -- terminal) and skip the custom style for real files that happen to be
  -- nomodifiable.
  if is_nonmodifiable_window(win) then
    vim.wo[win].winhighlight = 'Normal:NormalNonTextNC,WinSeparator:WinSeparatorNonTextNC'
  else
    vim.wo[win].winhighlight = 'Normal:NormalNC'
  end

  vim.wo[win].cursorline = false
  vim.wo[win].colorcolumn = '0'
end

vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  callback = function()
    apply_window_style(vim.api.nvim_get_current_win(), true)
  end,
})

vim.api.nvim_create_autocmd('WinLeave', {
  pattern = '*',
  callback = function()
    apply_window_style(vim.api.nvim_get_current_win(), false)
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function(args)
    local win = vim.fn.bufwinid(args.buf)
    if win == -1 then
      return
    end

    apply_window_style(win, win == vim.api.nvim_get_current_win())
  end,
})

vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'modifiable',
  callback = function()
    local win = vim.api.nvim_get_current_win()
    apply_window_style(win, true)
  end,
})
