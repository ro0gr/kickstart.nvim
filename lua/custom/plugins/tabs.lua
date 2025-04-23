vim.cmd 'cab tq tabclose'
vim.cmd 'cab te tabedit %:p:h'
vim.cmd 'cab tw tabedit $PWD'
vim.cmd 'cab tr TabRename'
vim.cmd 'cab tm tabmove'

-- Stack based tabs
--
-- By default when ckosing a tab, it will switch to the next one
-- So, say, if I open a new tab, then close it, I'll end up in a tab which is
-- different from the one I was in initially. This is not the behavior I want.
--
-- It looks like the simpliest way to achieve this is to move open a new tab
-- before the current one each time tabnew or tabedit is called.
vim.api.nvim_create_autocmd('TabNew', {
  callback = function()
    vim.cmd 'tabmove -1'
  end,
})

return {
  {
    'nanozuki/tabby.nvim',
    -- event = 'VimEnter', -- if you want lazy load, see below
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('tabby').setup {
        preset = 'tab_only',
      }
    end,
  },
}
