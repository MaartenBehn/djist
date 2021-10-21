local M = {}
local nodes = require('djist.nodes')
local ts_utils = require('nvim-treesitter.ts_utils')
local bridge = require('djist.pybridge')
local ui = require('djist.ui')

M.show = function ()
    local view, viewBody = nodes.getViewNodes()
    print(ts_utils.get_node_text(view)[1])
    local viewName = ts_utils.get_node_text(view)[1]
    local sRow, _, _, _ = viewBody:range()
    local urls = bridge.runPython(viewName)
    print(vim.inspect(urls))
    --local urls = bridge.urls or {}
    ui.setVirtualText(tostring(urls), sRow)
end
M.show()
return M
