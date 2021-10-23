local M = {}
local nodes = require('djist.nodes')
local ts_utils = require('nvim-treesitter.ts_utils')
local bridge = require('djist.pybridge')

M.showViewURLS = function ()
    local view, viewBody = nodes.getViewNodes()
    print(ts_utils.get_node_text(view)[1])
    local viewName = ts_utils.get_node_text(view)[1]
    local sRow, _, _, _ = viewBody:range()
    bridge.runPython({viewName=viewName, rowNo=sRow})
end

return M
