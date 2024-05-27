return {
  'b0o/SchemaStore.nvim',
  opts = {},
  config = function()
    require('lspconfig').jsonls.setup {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,
}
