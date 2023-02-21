local M = {}

M.add_snippets = function()
  require("snippets.all").add_snippets()
  require("snippets.csharp").add_snippets()
  require("snippets.lua").add_snippets()
  require("snippets.markdown").add_snippets()
  require("snippets.sh").add_snippets()
end

return M
