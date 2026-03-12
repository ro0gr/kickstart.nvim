vim.pack.add {
  'https://github.com/stevearc/conform.nvim',
}

require('conform').setup {
  log_level = vim.log.levels.DEBUG,
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true, json = true }
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 2500,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    json = { 'fixjson' },
    markdown = { 'prettierd' },
    javascript = { 'eslint_d', 'prettierd' },
    javascriptreact = { 'eslint_d', 'prettierd' },
    typescript = { 'eslint_d', 'prettierd' },
    typescriptreact = { 'eslint_d', 'prettierd' },
    css = { 'stylelint', 'prettierd' },
    scss = { 'stylelint', 'prettierd' },
    handlebars = { 'prettierd' },
  },

  formatters = {
    prettierd = {
      require_cwd = true,
    },
    eslint_d = {
      require_cwd = true,
      append_args = { '--rule', 'no-debugger: 0', '--rule', 'no-console: 0' },
    },
  },
}
