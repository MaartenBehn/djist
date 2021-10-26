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
local uv = vim.loop
local ui = require('djist.ui')

local function onread(err, data)
    assert(not err, err)
    --if data then
        --local vals = vim.split(data, "\n")
        --for _, d in pairs(vals) do
            --if d == "" then goto continue end
            --table.insert(M.urls, d)
            --::continue::
        --table.insert(M.urls, data)
        --end
    --end
    if data then
        table.insert(M.urls, data)
    end
end

local function onerr(err, data)
    assert(not err, err)
    -- Ignore errors for now
end

local function getPythonScript()
    local script = vim.api.nvim_get_runtime_file('**/djist/scripts/', false)[1]
    if script == '' then
        error('Could not find the Python script. It should be inside <runtimedir>/djist/scripts/ where runtimedir is a directory present in the runtimepath.')
    end
    return script .. 'get_urls.py'
end

M.runPython = function (args)
    M.urls = {}
    local stdout = uv.new_pipe(false)
    local stderr = uv.new_pipe(false)
    local pythonVenvPath = vim.env.VIRTUAL_ENV

    local function extractURLS(input_data)
        return table.concat(input_data)
    end

    local function showViritualText()
        ui.setVirtualText(extractURLS(M.urls), args.rowNo)
    end

    local pyScript = getPythonScript()

    local pythonPath =  pythonVenvPath .. "/bin/python"
    handle, pid = uv.spawn(pythonPath, {
        args = {pyScript, args.viewName},
        stdio = {nil, stdout, stderr},
    }, vim.schedule_wrap(function ()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()
        showViritualText()
        end)
    )

    uv.read_start(stdout, onread)
    uv.read_start(stderr, onerr)
end

return M
