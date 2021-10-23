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

M. runPython = function (args)
    M.urls = {}
    local stdin = uv.new_pipe(false)
    local stdout = uv.new_pipe(false)
    local stderr = uv.new_pipe(false)
    local pythonVenvPath = vim.env.VIRTUAL_ENV

    local function extractURLS(input_data)
        return table.concat(input_data)
    end

    local function showViritualText()
        ui.setVirtualText(extractURLS(M.urls), args.rowNo)
    end

    local pythonPath =  pythonVenvPath .. "/bin/python"
    handle, pid = uv.spawn(pythonPath, {
        args = {"/home/pulsar17/Projects/inkwebupgrade/try.py", args.viewName},
        stdio = {stdin, stdout, stderr},
    }, vim.schedule_wrap(function ()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stdin:close()
        handle:close()
        showViritualText()
        end)
    )
    --print(handle, pid)
    uv.read_start(stdout, onread)
    uv.read_start(stderr, onread)
end
return M
