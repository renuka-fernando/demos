function envoy_on_request(request_handle)
    local body = ""
    request_handle:logInfo("Hello REQ PATH Lua1")
    for chunk in request_handle:bodyChunks() do
        os.execute("sleep 1")
        -- Clears each received chunk.
        request_handle:logInfo("REQ bodyChunks")
        request_handle:logInfo("REQ chunk length:" .. chunk:length())
        request_handle:logInfo(chunk:getBytes(0, math.min(10, chunk:length())))
        -- body = body .. chunk:getBytes(0, chunk:length())
    end
    request_handle:logInfo("Sedning Request chunks completed")
    -- os.execute("sleep 5")
    -- request_handle:logInfo("Concat body: " .. body)
end


function envoy_on_response(response_handle)
    for chunk in response_handle:bodyChunks() do
        -- Clears each received chunk.
        response_handle:logInfo("Response bodyChunks")
        response_handle:logInfo(chunk:getBytes(0, chunk:length()))
    end
end