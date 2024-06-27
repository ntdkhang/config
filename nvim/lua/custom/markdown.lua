--[[
BufRead, BufEnter *.md :setlocal textwidth=100 fo+=a
]]

local markdowngroup = vim.api.nvim_create_augroup("MarkdownGroup", {
    clear = false -- without this, it create errors

})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.md" },
    command = [[setlocal textwidth=130 fo=want]],
    group = markdowngroup,
})
-- more on the fo=want:
-- [http://germaniumhq.com/2020/04/08/2020-04-08-Vim-Auto-Formatting-for-Asciidoc-and-Markdown/]
-- :help fo-table
