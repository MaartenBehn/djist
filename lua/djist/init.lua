--
-- Copyright 2021, Ishaan Arora (ishaanarora1000@gmail.com)
--
-- This file is part of the software djist.
--
-- djist is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- djist is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with djist.  If not, see <http://www.gnu.org/licenses/>.
--

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
