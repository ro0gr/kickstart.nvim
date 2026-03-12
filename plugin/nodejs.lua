----- Node.js host configuration -----
local function get_node_handle()
  local handle = io.popen 'cd $HOME && mise which node 2>/dev/null || asdf which node 2>/dev/null || which node'
  if handle == nil then
    print 'Warning: Could not open a shell to detect Node.js path. Plugins requiring Node.js may not work.'
    return
  end

  local node_path = handle:read('*a'):gsub('\n', '')
  handle:close()
  return node_path
end

local node_path = get_node_handle()
if node_path ~= '' then
  vim.g.node_host_prog = node_path
else
  print 'Warning: Could not detect Node.js path. Plugins requiring Node.js may not work.'
end
