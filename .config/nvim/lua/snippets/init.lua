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
local copy1 = function(args)
  return args[1]
end

-- Extract parameter list from  C# logger template string
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

return {
  all = {
    -- current date
    s({ trig="ymd", name="Current date", dscr="Insert the current date" }, {
      p(os.date, "%Y-%m-%d"),
    }),
  },

  cs = {
    s({ trig="cls", name="Class definition", dscr="Insert class definition" }, {
      c(1, {
        t("public "),
        t("private "),
        t("internal "),
      }),
      t("class "),
      i(2, "ClassName"),
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

    s({ trig="fn", name="Function definition", dscr="Insert function definition" }, {
      c(1, {
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

    s({ trig="if", name="If statement", dscr="Insert if statement" }, {
      t({"if ("}),
      i(1, {"Expression"}),
      t({")"}),
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

    s({ trig="conws", name="Console.WriteLine(\"...\")", dscr="Write a message to console (Console.WriteLine(\"...\"))" }, {
      t("Console.WriteLine(\""),
      i(1, "message"),
      t({"\");"}),
      i(0),
    }),

    s({ trig="conwt", name="Console.WriteLine($\"...\")", dscr="Write a templated message to Console (Console.WriteLine($\"...\"))" }, {
      t("Console.WriteLine($\""),
      i(1, "template message"),
      t({"\");"}),
      i(0),
    }),

    s("ternary", {
      i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
    }),
  },

  lua = {
    s({ trig="fn local", name="Local function definition", dscr="Insert local function definition" }, {
      t("-- @param: "), f(copy1, 2),
      t({"","local "}), i(1), t(" = function("),i(2,"fn param"),t({ ")", "\t" }),
      i(0),
      t({ "", "end" }),
    }),

    s({ trig="fn module", name="Module function definition", dscr="Insert module function definition" }, {
      t("-- @param: "), f(copy1, 3), t({"",""}),
      i(1, "modname"), t("."), i(2, "fnname"), t(" = function("),i(3,"fn param"),t({ ")", "\t" }),
      i(0),
      t({ "", "end" }),
    }),
  },

  markdown = {
    s({ trig = "link", name = "markdown_link", dscr = "Create markdown link [txt](url)", }, {
      t("["),
      i(1, "Text"),
      t("]("),
      i(2, "URL"),
      t(")"),
      i(0),
    }),
    s({ trig = "codewrap", name = "markdown_code_wrap", dscr = "Create markdown code block from existing text", }, {
      t("``` "),
      i(1, "Language"),
      t({ "", "" }),
      f(function(_, snip)
        local tmp = {}
        tmp = snip.env.TM_SELECTED_TEXT
        tmp[0] = nil
        return tmp or {}
      end, {}),
      t({ "", "```", "" }),
      i(0),
    }),
    s({ trig = "codeempty", name = "markdown_code_empty", dscr = "Create empty markdown code block", }, {
      t("``` "),
      i(1, "Language"),
      t({ "", "" }),
      i(2, "Content"),
      t({ "", "```", "" }),
      i(0),
    }),
  },

  sh = {
    s("shebang", {
      t { "#!/bin/sh", "" },
      i(0),
    }),
  },
}
