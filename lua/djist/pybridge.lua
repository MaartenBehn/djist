local M = {}
local uv = vim.loop

E_SUCCESS = 0

local handle, pid
local data = {}

local stdin = uv.new_pipe(false)
local stdout = uv.new_pipe(false)
local stderr = uv.new_pipe(false)

-- Close write ends of stdout and stderr as a safety precaution
uv.shutdown(stdout)
uv.shutdown(stderr)

local function extractURLS(input_data)
    local urls = vim.split(table.concat(input_data), '%c')
    return urls
end

local function onRead(err, chunk)
    assert(not err, err)
    --print(chunk)
    if (chunk) then
        table.insert(data, chunk)
    else
        -- There is no more data to read
        M.urls = extractURLS(data)
    end
end
local function onshutdown(err)
  if err == "ECANCELED" then
    return
  end
  --uv.close(handle, function() return end)
end

local function onExit(code, signal)
    print(code)
    if code ~= E_SUCCESS then
        error("Error running the Python script.")
    end
end

M.runPython = function(viewName)
    local pythonVenvPath = vim.env.VIRTUAL_ENV
    if not pythonVenvPath then
        error("Could not find the virtual environment. Have you sourced the activate script?")
    end

    local pythonPath =  pythonVenvPath .. "/bin/python"

    handle, pid = uv.spawn(pythonPath, {
        args = {"/home/pulsar17/Projects/inkwebupgrade/try.py"},
        stdio = {stdin, stdout, stderr},
    }, onExit)

    uv.read_start(stdout, onRead)
    uv.write(stdin, viewName)
    uv.shutdown(stdin, onshutdown)
    return data
end

return M
