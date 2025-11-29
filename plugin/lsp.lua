vim.pack.add {
  'https://github.com/williamboman/mason.nvim',
}

require('mason').setup()

vim.pack.add {
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}

local formatters = {
  'eslint_d',
  'prettierd',
  'stylelint-lsp',
  'stylua',
}

require('mason-tool-installer').setup {
  ensure_installed = vim.tbl_extend('force', formatters, {
    -- 'cspell',
    -- 'css-lsp',
    -- 'css-variables-language-server',
    -- 'ember-language-server',
    -- 'emmet-ls',
    -- 'glint',
    -- 'html-lsp',
    -- 'json-lsp',
    -- 'lua-language-server',
    -- 'marksman',
    -- 'pyright',
    -- 'spectral-language-server',
    -- 'typescript-language-server',
    -- 'yaml-language-server',
  }),
  auto_update = true,
  run_on_start = true,
}
