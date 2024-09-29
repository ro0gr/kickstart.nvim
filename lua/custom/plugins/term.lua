vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'customize terminal buffers appearance',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = false

    vim.cmd 'setlocal signcolumn=no'
  end,
})

-- borrowed from https://github.com/voldikss/vim-floaterm/issues/243#issuecomment-1742222523
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

      -- Auto-insert when opening a terminal, but keep it disabled
      -- when navigating to an existing terminal via regular vim navigation.
      vim.g.floaterm_autoinsert = true
      vim.api.nvim_create_autocmd({ 'TermEnter' }, {
        desc = 'auto insert in terminal',
        callback = function()
          vim.g.floaterm_autoinsert = false
        end,
      })

      toggleFloaterm('--name=' .. name .. ' --title=' .. name .. ' tmux new -A -t "' .. name .. '"')
    end, { silent = true, desc = 'Project multiplexer' })

    vim.g.floaterm_wintype = 'split'
    vim.g.floaterm_position = 'topleft'
    vim.g.floaterm_height = 15

    -- Floaterm auto insert is a bit tricky to use.
    -- It auto inserts when you open a terminal, but it also auto inserts
    -- when you navigate to a terminal which is already open.
    -- So I'm disabling it here, and enabling it only when I open a terminal.
    -- This is done in the autocmd above.
    vim.g.floaterm_autoinsert = false
  end,
}
