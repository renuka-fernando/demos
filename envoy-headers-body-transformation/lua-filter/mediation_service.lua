local json = require "lib.json"
local base64 = require'lib.base64'
-- json library: https://github.com/rxi/json.lua
-- base64 library: https://github.com/iskolbin/lbase64


function envoy_on_request(request_handle)
    request_handle:logInfo("Hello Lua1")
    local request_headers = request_handle:headers()
    local request_headers_table = {}
    for key, value in pairs(request_headers) do
        request_handle:logInfo("Lua1 Request Headers: " .. key .. "->" .. value)
        request_headers_table[key] = value
    end
    local request_body = request_handle:body():getBytes(0, request_handle:body():length())

    request_handle:logInfo("Lua1 Request Body: " .. request_body)

    local mediation_request_body = {
        headers=request_headers_table,
        body=base64.encode(request_body)
    }

    local mediation_headers, mediation_response_body_str = request_handle:httpCall(
        "mediation_service",
        {
            [":method"] = "POST",
            [":path"] = "/handlerequest",
            [":authority"] = "mediation_service"
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

    -- for key, val in pairs(mediation_headers) do
    --     request_handle:headers():add(key, val)
    -- end
    
end

function envoy_on_response(response_handle)
--       -- Sets the content-length.
--   response_handle:headers():replace("content-length", 28)
--   response_handle:headers():replace("content-type", "text/html")

--   local last
--   for chunk in response_handle:bodyChunks() do
--     -- Clears each received chunk.
--     response_handle:logInfo(chunk:getBytes())
--     chunk:setBytes("")
--     last = chunk
--   end

--   last:setBytes("<html><b>Not Found<b></html>")
end
