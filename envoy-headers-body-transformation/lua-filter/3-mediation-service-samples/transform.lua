local json = require "lib.json"
local base64 = require'lib.base64'
-- json library: https://github.com/rxi/json.lua
-- base64 library: https://github.com/iskolbin/lbase64

-- JSON to XML convertion
function envoy_on_request(request_handle)
    request_handle:logInfo("Hello Lua1")
    local request_headers = request_handle:headers()
    local request_headers_table = {}
    for key, value in pairs(request_headers) do
        request_handle:logInfo("Lua1 Request Headers: " .. key .. "->" .. value)
        request_headers_table[key] = value
    end
    local request_body = request_handle:body():getBytes(0, request_handle:body():length())
    -- request_handle:logInfo("Lua1 Request Body: " .. request_body)

    local mediation_request_body = {
        headers=request_headers_table,
        body=base64.encode(request_body)
    }

    local _, mediation_response_body_str = request_handle:httpCall(
        "mediation-service",
        {
            [":method"] = "POST",
            [":path"] = "/handle-request",
            [":authority"] = "mediation-service",
            ["content-type"] = "application/json",
            ["accept"] = "application/json",
        },
        json.encode(mediation_request_body),
        100000,
        false
    )
    request_handle:logInfo("Lua1: Done Mediation HTTP Call")
    request_handle:logInfo("Lua1: Mediation body: " .. mediation_response_body_str)

    local mediation_response_body = json.decode(mediation_response_body_str)
    local content_length = request_handle:body():setBytes(base64.decode(mediation_response_body.body))
    request_handle:headers():replace("content-length", content_length)

    if mediation_response_body.headersToAdd ~= nil then
        for key, val in pairs(mediation_response_body.headersToAdd) do
            request_handle:headers():add(key, val)
        end
    end
    if mediation_response_body.headersToReplace ~= nil then
        for key, val in pairs(mediation_response_body.headersToReplace) do
            request_handle:headers():replace(key, val)
        end
    end
end

function envoy_on_response(response_handle)
    response_handle:logInfo("Global Lua: Bye")

    local request_headers = response_handle:headers()
    local request_headers_table = {}
    for key, value in pairs(request_headers) do
        response_handle:logInfo("Lua1 Response Headers: " .. key .. "->" .. value)
        request_headers_table[key] = value
    end
    local request_body = response_handle:body():getBytes(0, response_handle:body():length())
    -- request_handle:logInfo("Lua1 Request Body: " .. request_body)

    local mediation_request_body = {
        headers=request_headers_table,
        body=base64.encode(request_body)
    }

    local _, mediation_response_body_str = response_handle:httpCall(
        "mediation-service",
        {
            [":method"] = "POST",
            [":path"] = "/handle-response",
            [":authority"] = "mediation-service",
            ["content-type"] = "application/json",
            ["accept"] = "application/json",
        },
        json.encode(mediation_request_body),
        100000,
        false
    )
    response_handle:logInfo("Lua1: Done Mediation HTTP Call")
    response_handle:logInfo("Lua1: Mediation body: " .. mediation_response_body_str)

    local mediation_response_body = json.decode(mediation_response_body_str)
    local content_length = response_handle:body():setBytes(base64.decode(mediation_response_body.body))
    response_handle:headers():replace("content-length", content_length)

    if mediation_response_body.headersToAdd ~= nil then
        for key, val in pairs(mediation_response_body.headersToAdd) do
            response_handle:headers():add(key, val)
        end
    end
    if mediation_response_body.headersToReplace ~= nil then
        for key, val in pairs(mediation_response_body.headersToReplace) do
            response_handle:headers():replace(key, val)
        end
    end
end