if vim.g.neovide then
  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5

  vim.g.neovide_scale_factor = 1.2

  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set('n', '<D-=>', function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set('n', '<D-->', function()
    change_scale_factor(1 / 1.25)
  end)
end

return {}
