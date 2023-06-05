local ls = require "luasnip"
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

ls.add_snippets("all", {
    snip({
        trig = "codeempty",
        namr = "markdown_code_empty",
        dscr = "Create empty markdown code block",
    }, {
        text "``` ",
        insert(1, "Language"),
        text { "", "" },
        insert(2, "Content"),
        text { "", "```", "" },
        insert(0),
    }),

    snip({
        trig = "cpp",
        namr = "markdown_cpp",
        dscr = "Create empty markdown C++ code block",
    }, {
        text {"```cpp", ""},
        insert(1, "Content"),
        text { "", "```", "" },
        insert(0),
    }),
})
