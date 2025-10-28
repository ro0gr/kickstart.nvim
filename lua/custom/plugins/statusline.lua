return {
  'hoob3rt/lualine.nvim',
  event = 'VimEnter',
  config = function()
    local function get_color(name, attr)
      local color = vim.api.nvim_get_hl_by_name(name, true)
      return string.format('#%06x', color[attr])
    end

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
