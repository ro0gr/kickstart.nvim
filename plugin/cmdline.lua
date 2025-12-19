-- Unsure whether it's ghostty related, but cursor gets barely visible in when I navigate in cmdline mode
-- so making it block to be more visible
vim.opt.guicursor:append 'ci-ve:block'

-- make sure that :find and gf search in subdirectories
vim.opt.path = '.,**'

-- Enhanced command-line completion
vim.opt.wildoptions:append 'fuzzy'
vim.opt.wildmode = 'noselect:lastused,full'
vim.opt.pumborder = 'rounded'

-- Accept best match in wildmenu when pressing Enter
vim.keymap.set('c', '<CR>', function()
  -- If wildmenu is active it means nothing is selected.
  if vim.fn.wildmenumode() == 1 then
    -- Select first item then accept
    return '<C-n><CR>'
  else
    return '<CR>'
  end
end, { expr = true, desc = 'Accept best match in wildmenu' })
