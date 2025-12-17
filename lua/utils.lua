local M = {}

--- Match a list of items against a pattern, respecting wildoptions setting
--- @param list table List of strings to match against
--- @param pattern string Pattern to match
--- @return table Filtered list of matching items
function M.match_with_wildoptions(list, pattern)
  -- Check if fuzzy matching is enabled in wildoptions
  local wildoptions = vim.opt.wildoptions:get()
  local use_fuzzy = vim.tbl_contains(wildoptions, 'fuzzy')

  if use_fuzzy then
    return vim.fn.matchfuzzy(list, pattern)
  else
    -- Use matchstrlist for substring matching (returns list of items containing pattern)
    local matches = vim.fn.matchstrlist(list, pattern)
    -- matchstrlist returns table with {idx, text}, extract just the text
    return vim.tbl_map(function(item)
      return list[item.idx]
    end, matches)
  end
end

return M
