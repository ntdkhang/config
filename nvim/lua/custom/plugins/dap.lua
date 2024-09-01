return {
    "mfussenegger/nvim-dap",
    config = function()
        local xcodebuild = require("xcodebuild.integrations.dap")

        -- TODO: change it to your local codelldb path
        local codelldbPath = os.getenv("HOME") .. "/.config/codelldb-x86_64-darwin/extension/adapter/codelldb"

        xcodebuild.setup(codelldbPath)

        vim.keymap.set("n", "<leader>xr", xcodebuild.build_and_debug, { desc = "Build & Debug" })
        vim.keymap.set("n", "<leader>xB", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>x.", xcodebuild.terminate_session, { desc = "Terminate Debugger" })
        -- vim.keymap.set("n", "<leader>B", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })

        -- vim.keymap.set("n", "<leader>dd", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
        -- vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
        -- vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
    end,
}
