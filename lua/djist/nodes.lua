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

local utils = require('djist.utils')
local M = {}
local bufNo = utils.getBufNo()
local lang = utils.getLang()

local function parseQuery()

    local query = [[
    (class_definition
    name: (identifier) @class_name) @class
    ]]

    local success, parsedQuery = pcall(function()
        return vim.treesitter.parse_query(lang, query)
    end)

    if not success then
        error('The buffer could not be parsed properly. Is it a Python file?')
    end
    return parsedQuery
end

local function parseBuffer()
    local parser = vim.treesitter.get_parser(bufNo, lang)
    local syntaxTree = parser:parse()
    return syntaxTree[1]:root()
end

local function isCursorInClass(sRow, eRow, cursorRow)
    sRow = sRow + 1
    eRow = eRow + 1
    if (cursorRow >= sRow) and (cursorRow <= eRow) then
        return true
    end
    return false
end

M.getViewNodes = function()
    local root = parseBuffer()
    local parsedQuery = parseQuery()
    local cursorRow = vim.api.nvim_win_get_cursor(0)[1]
    for _, capturedNodes, _ in parsedQuery:iter_matches(root, bufNo) do
        local klass, klassDefinition = capturedNodes[1], capturedNodes[2]
        local sRow, _, eRow, _ = klassDefinition:range()
        M.viewRowRange = {sRow, eRow}
        if isCursorInClass(sRow, eRow, cursorRow) then
            return klass, klassDefinition
        end
    end
end
--k, p = M.getViewNode()
--print(require('nvim-treesitter.ts_utils').get_node_text(p)[1])
--local url =  [[
--(call
--function: (identifier) @func
--arguments: (
    --argument_list
    --(call
        --function: (attribute
            --object: (identifier) @name
            --attribute: (identifier) @as))
    --) @arg)
--]]
--print(M.getViewName())
return M
