local utils = require('djist.utils')

local M = {}
M.setVirtualText = function (text, lineNo)
    vim.api.nvim_buf_set_virtual_text(0, 0, lineNo, {{text, 'Comment'}}, {})
end
M.setVirtualText("Cijaf", 7)
return M
