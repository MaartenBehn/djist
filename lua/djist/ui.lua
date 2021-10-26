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
M.setVirtualText = function (text, lineNo)
    vim.api.nvim_buf_set_virtual_text(0, 0, lineNo, {{text, 'Comment'}}, {})
end
return M
