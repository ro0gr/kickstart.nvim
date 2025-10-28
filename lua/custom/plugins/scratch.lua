vim.cmd [[cab sc Scratch]]

local setup_scratch_buffer = function()
  vim.opt_local.buftype = 'nofile'
  vim.opt_local.bufhidden = 'hide'
  vim.opt_local.swapfile = false
end

-- Create the :Scratch command
-- Accepts a filetype argument to set the buffer's filetype if provided
-- If there is a visual selection when the command is invoked, the selected lines
-- are copied into the new scratch buffer, and the filetype defaults to that of
-- the original buffer unless overridden by the argument.
--
-- Usage: :Scratch [filetype]
vim.api.nvim_create_user_command('Scratch', function(opts)
  local lines_selected = opts.range > 0 and vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false) or nil

  -- trim any leading/trailing whitespace from the argument
  local filetype = opts.args:match '^%s*(.-)%s*$'

  if lines_selected then
    -- If there is a visual selection, use the filetype of the original
    filetype = filetype ~= '' and filetype or vim.api.nvim_get_option_value('filetype', { buf = 0 })
  end

  vim.cmd 'new'

  setup_scratch_buffer()

  if lines_selected then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines_selected)
  end

  if filetype ~= '' then
    vim.bo.filetype = filetype
  end
end, {
  nargs = '?', -- Allow zero or one argument
  range = true, -- Allow visual selection
  desc = 'Create a scratch buffer and optionally set filetype',
})

return {}
