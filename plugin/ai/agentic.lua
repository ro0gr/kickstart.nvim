vim.pack.add {
  'https://github.com/carlos-algms/agentic.nvim',
  -- { src = 'https://github.com/ro0gr/agentic.nvim', version = 'feat/execution-notifications' },
}

local agentic = require 'agentic'

local function notify_ghostty(message, tabpage)
  local title = 'Agentic'
  local cwd = vim.fn.getcwd(-1, tabpage or 0)
  local project = vim.fn.fnamemodify(cwd, ':t')
  -- Format: [project] Agentic: message
  local payload = string.format('[%s] %s: %s', project, title, message)
  local osc9 = string.format('\27]9;%s\7', payload)
  vim.api.nvim_ui_send(osc9)
end

agentic.setup {
  provider = 'mistral-vibe-acp',

  hooks = {
    on_response_complete = function(data)
      if data.success then
        notify_ghostty('Response finished', data.tab_page_id)
      else
        local err_msg = 'Error'
        if type(data.error) == 'table' and data.error.message then
          err_msg = 'Error: ' .. data.error.message
        elseif type(data.error) == 'string' then
          err_msg = 'Error: ' .. data.error
        end
        notify_ghostty(err_msg, data.tab_page_id)
      end
    end,

    on_request_permission = function(data)
      local tool_call = type(data.request) == 'table' and data.request.toolCall or nil
      local label = tool_call and (tool_call.title or tool_call.kind) or 'Agent action'
      notify_ghostty('Permission required: ' .. label, data.tab_page_id)
    end,
  },

  keymaps = {
    widget = {
      switch_model = {
        '<M-m>', -- Switch model
        mode = { 'n', 'v', 'i' },
      },
    },

    prompt = {
      submit = {
        {
          '<C-s>',
          mode = { 'n', 'v', 'i' },
        },
      },
    },
  },
}

-- focus the prompt input or close the chat if already focused
vim.keymap.set({ 'n', 't', 'i' }, '<M-a>', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local was_in_insert = vim.api.nvim_get_mode().mode == 'i'

  agentic.open() -- open chat of gain focus

  if vim.api.nvim_get_current_buf() == current_buf and was_in_insert then
    -- if the buffer didn't change, it means we were already in the chat,
    -- so let's treat this as a toggle
    agentic.close()
  end
end, { desc = 'Toggle [a]gentic' })

vim.keymap.set({ 'v' }, '<M-a>', function()
  return agentic.add_selection()
end, { expr = true, desc = 'Add range to agentic([A]I)' })

-- get method names(sub_commands) from the agentic var keys
local sub_commands = vim.tbl_keys(agentic)

vim.api.nvim_create_user_command('Agentic', function(opts)
  -- trim each arg
  local args = vim.tbl_map(function(arg)
    return vim.trim(arg)
  end, opts.fargs)

  -- check if the first arg is a known sub_command
  if vim.tbl_contains(sub_commands, args[1]) then
    agentic[args[1]]() -- call the corresponding function
    return
  end
end, {
  nargs = '*',
  range = true,
  complete = function(arg_lead)
    if arg_lead == '' then
      return sub_commands
    end

    return require('utils').match_with_wildoptions(sub_commands, arg_lead)
  end,
})

vim.cmd 'cabbr ag Agentic'
vim.cmd 'cabbr agp Agentic switch_provider'

vim.g.autoread = true
