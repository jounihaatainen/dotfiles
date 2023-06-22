local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local events = require("luasnip.util.events")

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local copy = function(args)
  return args[1]
end

local M = {}

M.add_snippets = function(opts)
  opts = vim.tbl_deep_extend("force", { key = "lua", default_priority = 1000 }, opts or {})
  ls.add_snippets("lua",  {
    s({ trig="fn local", name="Local function definition", dscr="Insert local function definition" }, {
      t("-- @param: "), f(copy, 2),
      t({"","local "}), i(1), t(" = function("),i(2,"fn param"),t({ ")", "\t" }),
      i(0),
      t({ "", "end" }),
    }),

    s({ trig="fn module", name="Module function definition", dscr="Insert module function definition" }, {
      t("-- @param: "), f(copy, 3), t({"",""}),
      i(1, "modname"), t("."), i(2, "fnname"), t(" = function("),i(3,"fn param"),t({ ")", "\t" }),
      i(0),
      t({ "", "end" }),
    }),
  }, opts)
end

return M

