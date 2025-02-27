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

    local function get_color(name, attr)
      local color = vim.api.nvim_get_hl_by_name(name, true)
      return string.format('#%06x', color[attr])
    end

    local cwd_hl = vim.api.nvim_get_hl(0, { name = 'Title' })

    -- Custom function to check if a macro is being recorded
    local function macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == '' then
        return ''
      else
        return 'Recording @' .. recording_register
      end
    end

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

          -- Add the macro recording indicator to lualine_c
          {
            macro_recording,
            color = { fg = get_color('WarningMsg', 'foreground'), gui = 'bold' },
          },
        },
      },
    }
  end,
}
