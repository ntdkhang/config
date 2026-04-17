---@diagnostic disable: undefined-global
local M = {}

M.git = function()
  if vim.o.columns < 120 then
    return {
      layout = {
        box = "vertical",
        width = 0.9,
        height = 0.9,
        { win = "input", height = 1, border = "bottom" },
        { win = "list", height = 0.3, border = "bottom" },
        { win = "preview", title = "{preview}", border = true },
      },
    }
  else
    return {
      layout = {
        box = "horizontal",
        width = 0.9,
        height = 0.9,
        {
          box = "vertical",
          width = 0.3,
          border = true,
          title = "{title} {live} {flags}",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
        },
        { win = "preview", title = "{preview}", border = true },
      },
    }
  end
end

return M
