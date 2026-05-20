-- Sibling file navigation
-- [f - previous sibling file in current directory
-- ]f - next sibling file in current directory

local M = {}

-- Get the directory of the current buffer
---@return string Directory path
local function get_current_dir()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name == '' then
    return vim.fn.getcwd()
  end
  return vim.fn.fnamemodify(buf_name, ':h')
end

-- Get all regular files in the directory of the current file
---@return table List of file paths (filenames only)
local function get_sibling_files()
  local dir = get_current_dir()
  
  -- Use vim.loop.fs_scandir to iterate over directory contents
  local files = {}
  local handle = vim.loop.fs_scandir(dir)
  
  if not handle then
    return files
  end
  
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    
    -- Skip directories and special files
    if type == 'file' then
      -- Skip hidden files (starting with .) for now
      if not name:sub(1, 1):match('%.') then
        table.insert(files, name)
      end
    end
  end
  
  -- Sort alphabetically
  table.sort(files)
  
  return files, dir
end

-- Find the current file in the sibling list
---@param files table List of sibling files
---@return number|nil Index of current file in the list (1-based)
local function find_current_file_index(files)
  local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
  
  for i, name in ipairs(files) do
    if name == current_file then
      return i
    end
  end
  
  return nil
end

-- Navigate to sibling file at given index
---@param files table List of sibling files
---@param dir string Directory path
---@param index number 1-based index in the files list
local function navigate_to_sibling(files, dir, index)
  if not files or #files == 0 then
    vim.notify('No sibling files found', vim.log.levels.WARN)
    return
  end
  
  if index < 1 or index > #files then
    vim.notify('No more sibling files', vim.log.levels.WARN)
    return
  end
  
  local file = files[index]
  local filepath = dir .. '/' .. file
  
  -- Check if file exists and is readable
  if vim.fn.filereadable(filepath) == 1 then
    vim.cmd.edit(filepath)
  else
    vim.notify('Cannot read file: ' .. filepath, vim.log.levels.ERROR)
  end
end

-- Navigate to previous sibling file
function M.prev_sibling()
  local files, dir = get_sibling_files()
  local current_index = find_current_file_index(files)
  
  if not current_index then
    vim.notify('Current file not found in directory', vim.log.levels.WARN)
    return
  end
  
  local prev_index = current_index - 1
  if prev_index < 1 then
    prev_index = #files  -- wrap around to end
  end
  
  navigate_to_sibling(files, dir, prev_index)
end

-- Navigate to next sibling file
function M.next_sibling()
  local files, dir = get_sibling_files()
  local current_index = find_current_file_index(files)
  
  if not current_index then
    vim.notify('Current file not found in directory', vim.log.levels.WARN)
    return
  end
  
  local next_index = current_index + 1
  if next_index > #files then
    next_index = 1  -- wrap around to beginning
  end
  
  navigate_to_sibling(files, dir, next_index)
end

-- Setup keymaps
function M.setup()
  vim.keymap.set('n', '[f', M.prev_sibling, { desc = 'Previous sibling file', silent = true })
  vim.keymap.set('n', ']f', M.next_sibling, { desc = 'Next sibling file', silent = true })
end

-- Auto-setup when loaded
M.setup()

return M
