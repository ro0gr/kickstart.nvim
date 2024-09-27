vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'customize terminal buffers appearance',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd 'setlocal signcolumn=no'
  end,
})

local function get_bufnr_from_name(name)
  local buflist = vim.fn['floaterm#buflist#gather']()
  for _, bufnr in ipairs(buflist) do
    local bufname = vim.fn.getbufvar(bufnr, 'floaterm_name')
    if bufname == name then
      return bufnr
    end
  end
  return -1
end

local function toggleFloaterm(args)
  local name = args:match '--name=([^%s]+)'
  local bufnr = get_bufnr_from_name(name)

  if bufnr == -1 then
    vim.cmd('FloatermNew ' .. args)
  else
    vim.cmd('FloatermToggle ' .. name)
  end
end

return {
  'voldikss/vim-floaterm',
  config = function()
    vim.keymap.set({ 'n', 't' }, '<M-`>', function()
      local name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

      toggleFloaterm('--name=' .. name .. ' --title=' .. name .. ' tmux new -A -t "' .. name .. '"')
    end, { silent = true, desc = 'Project multiplexer' })

    -- for safety, allow to delete the terminal buffer only from the normal mode
    vim.keymap.set({ 'n', 't' }, '<M-Del>', ':FloatermKill<CR>', { silent = true })
    vim.keymap.set('n', '<M-Tab>', ':FloatermNext<CR>', { silent = true })
    vim.keymap.set('t', '<M-Tab>', '<C-\\><C-n>:FloatermNext<CR>', { silent = true })
    vim.keymap.set('n', '<M-S-Tab>', ':FloatermPrev<CR>', { silent = true })
    vim.keymap.set('t', '<M-S-Tab>', '<C-\\><C-n>:FloatermPrev<CR>', { silent = true })

    vim.g.floaterm_wintype = 'split'
    vim.g.floaterm_position = 'topleft'
    vim.g.floaterm_height = 15

    -- HM... I'd really like it to auto insert when I toggle/open a terminal
    -- but I don't want to auto insert when I just navigate to a terminal
    -- which is already open, cause it stops my normal navigation flow.
    vim.g.floaterm_autoinsert = false
  end,
}
