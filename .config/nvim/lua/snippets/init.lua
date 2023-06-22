local M = {}

M.add_snippets = function(opts)
  require("snippets.all").add_snippets(opts)
  require("snippets.csharp").add_snippets(opts)
  require("snippets.lua").add_snippets(opts)
  require("snippets.markdown").add_snippets(opts)
  require("snippets.sh").add_snippets(opts)
end

return M
