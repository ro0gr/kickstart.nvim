return {
  'hoob3rt/lualine.nvim',
  event = 'VimEnter',
  config = function()
    local function if_int_to_hex(maybe_rgb)
      if type(maybe_rgb) == 'number' then
        return string.format('#%06x', maybe_rgb)
      end
      return maybe_rgb
    end

    local cwd_hl = vim.api.nvim_get_hl(0, { name = 'Title' })

    require('lualine').setup {
      -- extensions = { 'oil' },
      extensions = { 'fugitive', 'quickfix', 'lazy', 'mason' },

      sections = {
        lualine_b = {
          {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
            end,
            color = {
              fg = if_int_to_hex(cwd_hl.fg),
              bg = if_int_to_hex(cwd_hl.bg),
              gui = 'bold',
            },
          },

          'branch',
          'diff',
          'diagnostics',
        },
        lualine_c = {
          {
            'filename',
            path = 1,
          },
        },
      },
    }
  end,
}
