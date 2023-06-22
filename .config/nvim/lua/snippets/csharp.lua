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
local utils = require("snippets.utils")

-- Extract parameter list from C# logger template string
-- For example for string:
--    "val1 = {Value1}, val2 = {Value2}"
-- function returns:
--    { sn(nil, { i(1, { "Value1" }), i(2, { "Value2" }) } }
local cs_logger_template_string_to_nodes = function(args)
  local template = args[1][1]
  if template == nil then
    return sn(nil, t(""))
  end
  local params = {}
  local index = 1
  for match in template:gmatch("{([^%s]+)}") do
    table.insert(params, t(", "))
    table.insert(params, i(index, { match }))
    index = index + 1
  end
  return sn(nil, params)
end

local snippets = {
  s({ trig="cls", name="Class definition", dscr="Insert class definition" }, {
    c(1, { --TODO: Skip this if line already contains access level
      t("public "),
      t("private "),
      t("internal "),
    }),
    t("class "),
    d(2, function(_, snip)
      return sn(nil, {
        i(1, vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")),
      })
      end, { 1 }),
    t(" "),
    c(3, {
      t({ "", "{" }),
      sn(nil, {
        t(": "),
        i(1, "ParentTypeName"),
        t({ "", "{" }),
      }),
    }),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  s({ trig="ctor", name="Class constructor", dscr="Insert class constructor" }, {
    c(1, { --TODO: Skip this if line already contains access level
      t("public "),
      t("protected "),
      t("private "),
      t("internal "),
    }),
    -- i(2, "ClassName"), -- TODO: Take class name from filename or even better using tree-sitter
    d(2, function(_, snip)
      return sn(nil, {
        i(1, vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")),
      })
      end, { 1 }),
    t({ "", "{" }),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  s({ trig="fn", name="Function definition", dscr="Insert function definition" }, {
    c(1, { --TODO: Skip this if line already contains access level
      t({"public "}),
      t({"private "}),
      t({"protected "}),
      t({"internal "}),
    }),
    c(2, {
      i(nil, {"ReturnType"}),
      t({"void"}),
      t({"async Task"}),
      t({"string"}),
      t({"int"}),
      t({"double"}),
      t({"boolean"}),
    }),
    t({" "}),
    i(3, {"FunctionName"}),
    t({"("}), i(4, "FunctionParameters"), t({")"}),
    t({ "", "{",}),
    t({ "", "\t"}),
    i(0),
    t({"", "}"})
  }),

  s({ trig="prop", name="Insert property", dscr="Insert class property definition" }, {
    c(1, { --TODO: Skip this if line already contains access level
      t({"public"}),
      t({"private"}),
      t({"protected"}),
      t({"internal"}),
    }),
    t({" "}),
    i(2, {"Type"}),
    t({" "}),
    i(3, {"Name"}),
    t({" "}),
    c(4, {
      t({"{ get; set; }"}),
      t({"=> "}),
      t({"{ get; init; }"}),
      t({"{ get; private set; }"}),
      t({"{ get; }"}),
    }),
    i(0),
  }),

  s({ trig="if", name="If statement", dscr="Insert if statement" }, {
    t({"if ("}),
    i(1, {"expression"}),
    t({")"}),
    t({ "", "{",}),
    t({ "", "\t"}),
    i(0),
    t({"", "}"})
  }),

  s({ trig="tryc", name="Try-catch statement", dscr="Insert a try-catch statement" }, {
    t({"try"}),
    t({"", "{"}),
    i(1, {"expression_to_try"}),
    t({"", "}"}),
    t({"", "catch ("}),
    i(2, {"exception_handling_code"}),
    t({")"}),
    t({ "", "{",}),
    t({ "", "\t"}),
    i(0),
    t({"", "}"})
  }),

  -- s({ trig="if", name="If statement", dscr="Insert if statement" },
  --   fmta([[
  --   if (<>)
  --   {
  --       <>
  --   }
  --   ]], {
  --     i(1, "expression"),
  --     i(2, "code"),
  --   })
  -- ),

  s({ trig="fori", name="Simple for loop", dscr="Insert simple for loop" }, {
    t({"for (int "}),
    i(1, "i"),
    t({" = 0; "}),
    r(1),
    t({" < "}),
    i(2, "upper_bound"),
    t("; "),
    r(1),
    t("++)"),
    t({ "", "{",}),
    t({ "", "\t"}),
    i(0),
    t({"", "}"})
  }),

  s({ trig="fore", name="Foreach statement", dscr="Insert foreach statement" }, {
    t({"foreach ("}),
    c(1, {
      sn(nil, {
        i(1, "ItemType"),
        t(" "),
        i(2, "ItemName"),
      }),
      sn(nil, {
        t("var "),
        i(1, "ItemName"),
      }),
    }),
    t({" in "}),
    i(2, {"Source"}),
    t({")"}),
    t({ "", "{",}),
    t({ "", "\t"}),
    i(0),
    t({"", "}"})
  }),

  s({ trig="Select", name="Linq Select call", dscr="Insert Linq Select call" }, {
    t({"Select("}),
    i(1, "param"),
    t(" => "),
    rep(1),
    i(2),
    t({")"}),
    i(0)
  }),

  s({ trig="log", name="Log with Logger", dscr="Insert Logger.Log* call" }, {
    i(1, {"Logger"}),
    t("."),
    c(2, {
      t("LogDebug"),
      t("LogInformation"),
      t("LogWarning"),
      t("LogError"),
      t("LogTrace"),
      t("LogCritical"),
    }),
    t("(\""),
    i(3, {"message"}),
    t({"\""}),
    d(4, cs_logger_template_string_to_nodes, { 3 }),
    t(");"),
    i(0),
  }),

  s({ trig="writeln", name="Console.WriteLine(\"...\")", dscr="Write a message to console (Console.WriteLine(\"...\"))" }, {
    t("Console.WriteLine(\""),
    i(1, "message"),
    t({"\");"}),
    i(0),
  }),

  s({ trig="writeln$", name="Console.WriteLine($\"...\")", dscr="Write a templated message to Console (Console.WriteLine($\"...\"))" }, {
    t("Console.WriteLine($\""),
    i(1, "template message"),
    t({"\");"}),
    i(0),
  }),

  s("ternary", {
    i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
  }),
}

local M = {}

M.add_snippets = function(opts)
  opts = vim.tbl_deep_extend("force", { key = "cs", default_priority = 1000 }, opts or {})
  ls.add_snippets("cs", snippets, opts)
end

return M

