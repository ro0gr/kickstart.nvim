local M = {}

-- Function to update terminal/window title
function M.update_title(prefix)
  prefix = prefix or 'nvim'
  local formatted_cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
  vim.o.titlestring = prefix .. ': ' .. formatted_cwd
end

-- Setup autocmds for title updates
function M.setup(prefix)
  prefix = prefix or vim.g.neovide and 'neovide' or 'nvim'

  vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged' }, {
    callback = function()
      M.update_title(prefix)
    end,
  })

  -- Set initial title
  M.update_title(prefix)
end

return M
