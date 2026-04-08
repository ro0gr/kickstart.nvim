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

  local function strip_trailing_slashes(path)
    if path == '/' then
      return path
    end

    return (path:gsub('/+$', ''))
  end

  local function normalize_path(path)
    return strip_trailing_slashes(vim.fs.normalize(path))
  end

  local function relative_to_root(path, root)
    path = normalize_path(path)
    root = normalize_path(root)

    if path == root then
      return ''
    end

    if root == '/' then
      return path:sub(2)
    end

    if path:sub(1, #root + 1) == root .. '/' then
      return path:sub(#root + 2)
    end
  end

  local function shorten_home(path)
    return vim.fn.pathshorten(vim.fn.fnamemodify(path, ':~'))
  end

  local function format_relative_path(path, root, suffix)
    path = normalize_path(path)
    local relative = relative_to_root(path, root)
    if relative == nil then
      return shorten_home(path) .. suffix
    end

    if relative == '' then
      return './'
    end

    return './' .. vim.fn.pathshorten(relative) .. suffix
  end

  local cwd = normalize_path(vim.fn.getcwd())

  -- Handle protocols (oil://, fugitive://, etc.)
  local proto, path = name:match '^(%w+)://(.*)$'
  if proto then
    if proto == 'oil' then
      return format_relative_path(path, cwd, '/')
    end

    if proto == 'fugitive' then
      -- Fugitive tab names point at the repo's .git dir; use the repo root for
      -- cwd checks and display so tabs collapse to a stable "fugitive" label.
      local repo = path:match '^(.-)/%.git//' or path:match '^(.-)/%.git$' or path
      repo = normalize_path(repo)
      if relative_to_root(cwd, repo) ~= nil then
        return 'fugitive'
      end

      return 'fugitive://' .. shorten_home(repo) .. '/'
    end

    local p_short = proto:sub(1, 1) .. '///'
    local suffix = path:match '(/+)$' or ''
    local clean_path = normalize_path(path)
    local shortened = shorten_home(clean_path)
    return p_short .. shortened .. suffix
  end

  return format_relative_path(name, cwd, '')
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
    local name = vim.api.nvim_buf_get_name(bufnr)
    local modified = vim.fn.getbufvar(bufnr, '&modified') == 1 and ' [+]' or ''

    s = s .. ' ' .. i .. ': ' .. format_path(name) .. modified .. ' '
  end
  s = s .. '%#TabLineFill#%T'
  return s
end

vim.opt.tabline = '%!v:lua.my_tabline()'
