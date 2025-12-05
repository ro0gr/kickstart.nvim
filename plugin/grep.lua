-- grep
if vim.fn.executable 'rg' == 1 then
  vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.o.grepformat = '%f:%l:%c:%m'
end

vim.cmd 'cabbrev sg grep'
vim.cmd 'cabbrev sga grepadd'
vim.cmd 'cabbrev sgw grep -w'
vim.cmd 'cabbrev sgaw grepadd -w'
vim.cmd 'cabbrev sgt grep -F'
