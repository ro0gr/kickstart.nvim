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
    'css-lsp',
    'css-variables-language-server',
    'ember-language-server',
    -- 'emmet-ls',
    'glint',
    'html-lsp',
    'json-lsp',
    'lua-language-server',
    -- 'marksman',
    -- 'pyright',
    -- 'spectral-language-server',
    'yaml-language-server',
    'tsgo',
  }),
  auto_update = true,
  run_on_start = true,
}

vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
}

vim.lsp.enable 'tsgo'
vim.lsp.enable 'ember'
vim.lsp.enable 'css_variables'

vim.lsp.config('glint', {
  -- remove package.json, cause isn't really insufficient to identify a Glint project
  root_markers = { '.glintrc.yml', '.glintrc', '.glintrc.json', '.glintrc.js', 'glint.config.js' },
})
vim.lsp.enable 'glint'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('html', {
  capabilities = capabilities,
})
vim.lsp.enable 'html'

vim.lsp.config('cssls', {
  capabilities = capabilities,
})
vim.lsp.enable 'cssls'
--
vim.lsp.config('jsonls', {
  capabilities = capabilities,
})
vim.lsp.enable 'jsonls'

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          '${3rd}/luv/library',
          -- '${3rd}/busted/library'
        },
      },
    },
  },
})
vim.lsp.enable 'lua_ls'
