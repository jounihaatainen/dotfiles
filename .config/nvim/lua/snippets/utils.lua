local ls = require("luasnip")
local d = ls.dynamic_node
local i = ls.insert_node
local sn = ls.snippet_node

local M = {}

-- M.insert_node_with_filename = function(pos, args)
--   d(pos, function(_, snip)
--     return sn(nil, {
--       i(1, vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")),
--     })
--   end, args)
-- end

return M
