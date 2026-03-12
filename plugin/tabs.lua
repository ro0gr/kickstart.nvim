vim.cmd 'cab tq tabclose'
vim.cmd 'cab te tabedit %:p:h'
vim.cmd 'cab tw tabedit $PWD'
vim.cmd 'cab tm tabmove'

vim.keymap.set({ 'n' }, '<M-1>', '1gt', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<M-2>', '2gt', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<M-3>', '3gt', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<M-4>', ':tablast<CR>', { noremap = true, silent = true })

-- Terminal mode mappings
vim.keymap.set({ 't', 'i' }, '<M-1>', '<C-\\><C-n>1gt', { noremap = true, silent = true })
vim.keymap.set({ 't', 'i' }, '<M-2>', '<C-\\><C-n>2gt', { noremap = true, silent = true })
vim.keymap.set({ 't', 'i' }, '<M-3>', '<C-\\><C-n>3gt', { noremap = true, silent = true })
vim.keymap.set({ 't', 'i' }, '<M-4>', '<C-\\><C-n>:tablast<CR>', { noremap = true, silent = true })

local function format_path(name)
  if name == '' then
    return '[No Name]'
  end

  -- Handle protocols (oil://, fugitive://, etc.)
  local proto, path = name:match '^(%w+)://(.*)$'
  if proto then
    local p_short = proto:sub(1, 1) .. '///'
    local suffix = path:match '(/+)$' or ''
    local clean_path = path:gsub('/+$', '')
    -- Use :.:~ to prefer relative to CWD, then Home
    local relative = vim.fn.fnamemodify(clean_path, ':.:~')
    local shortened = vim.fn.pathshorten(relative)
    return p_short .. shortened .. suffix
  end

  -- Normal files: relative to CWD if possible, else Home
  return vim.fn.pathshorten(vim.fn.fnamemodify(name, ':.:~'))
end

function _G.my_tabline()
  local s = ''
  for i = 1, vim.fn.tabpagenr '$' do
    s = s .. '%' .. i .. 'T' -- Tab page number for mouse clicks
    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end

    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = buflist[winnr]
    local name = vim.fn.bufname(bufnr)
    local modified = vim.fn.getbufvar(bufnr, '&modified') == 1 and ' [+]' or ''

    s = s .. ' ' .. i .. ': ' .. format_path(name) .. modified .. ' '
  end
  s = s .. '%#TabLineFill#%T'
  return s
end

vim.opt.tabline = '%!v:lua.my_tabline()'
