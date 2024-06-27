return {
    "ThePrimeagen/harpoon",
    --[[
    config = function()
        local harpoon = require "harpoon"
        harpoon:setup()

        vim.keymap.set("n", "<space>a", function()
            harpoon:list():add()
        end)

        vim.keymap.set("n", "<space>eh", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)
        for _, idx in ipairs { 1, 2, 3, 4, 5 } do
            vim.keymap.set("n", string.format("<space>%d", idx), function()
                harpoon:list():select(idx)
            end)
        end
    end,
    ]]
}
