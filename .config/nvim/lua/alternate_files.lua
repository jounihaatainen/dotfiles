local M = {}

M._extensions_patterns_for_alternate_files = nil

M.default_extension_patterns = function()
  return {
    ["razor"] = "razor.cs",
    ["razor.cs"] = "razor",
    ["h"] = { "c", "cc", "cpp", "cxx", "m" },
    ["hpp"] = { "cpp", "cxx" },
    ["c"] = "h",
    ["cc"] = "h",
    ["cpp"] = { "h", "hpp" },
    ["cxx"] = { "h", "hpp" },
    ["m"] = "h",
  }
end

M.setup = function(extensions_patterns_for_alternate_files)
  M._extensions_patterns_for_alternate_files = extensions_patterns_for_alternate_files
end

M.open_alternate_file = function()
  if M._extensions_patterns_for_alternate_files == nil then
    error("Patterns for alternate files has not been set. Have you called require('alternate_files').setup(...)?")
    return
  end

  local current_filename = vim.api.nvim_buf_get_name(0)
  local extension = nil

  for ext, _ in pairs(M._extensions_patterns_for_alternate_files) do
    if string.match(current_filename, ext .. "$") then
      extension = ext
    end
  end

  if extension == nil then
    print("No alternate extensions configured for extension '" .. vim.fn.fnamemodify(current_filename, ':e') .. "'")
    return
  end

  local candidate_extensions = M._extensions_patterns_for_alternate_files[extension]
  local filename = current_filename:gsub("%." .. extension .. "$", "")
  local alternate_filename = nil

  if type(candidate_extensions) == "string" then
    if vim.fn.filereadable(filename .. "." .. candidate_extensions) == 1 then
      alternate_filename = filename .. "." .. candidate_extensions
    end
  elseif type(candidate_extensions) == "table" then
    for _, ext in ipairs(candidate_extensions) do
      if vim.fn.filereadable(filename .. "." .. ext) == 1 then
        alternate_filename = filename .. "." .. ext
        break
      end
    end
  elseif type(candidate_extensions) == "function" then
    if vim.fn.filereadable(candidate_extensions(current_filename)) == 1 then
      alternate_filename = candidate_extensions(current_filename)
    end
  end

  if alternate_filename == nil or vim.fn.filereadable(alternate_filename) == 0 then
    print("No alternate file found for file '" .. current_filename .. "'")
    return
  end

  vim.cmd("e " .. alternate_filename)
end

return M
