-- TODO: try another plugin to be able to switch between models of different providers
-- Consider using:
-- - https://github.com/zbirenbaum/copilot.lua
-- - https://github.com/copilotlsp-nvim/copilot-lsp

vim.pack.add { 'https://github.com/github/copilot.vim' }

vim.g.copilot_node_command = vim.g.node_host_prog

vim.keymap.set('i', '<M-S-W>', '<Plug>(copilot-accept-word)')
