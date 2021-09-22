function envoy_on_request(request_handle)
    request_handle:logInfo("Global Lua: Hello")
    local content_length_from_header = request_handle:headers():get("content-length") 
    request_handle:logInfo("content length from header: " .. content_length_from_header)
    request_handle:logInfo("content length from body length: " .. request_handle:body():length())
    local request_body = request_handle:body():getBytes(0, request_handle:body():length())
    request_handle:logInfo("BODY")
    request_handle:logInfo(request_body)

    local content_length = request_handle:body():setBytes(request_body)
    request_handle:logInfo("content length from response body length: " .. content_length)
    request_handle:headers():replace("content-length", content_length)
    request_handle:logInfo("DONE")
end

function envoy_on_response(response_handle)
    response_handle:logInfo("Global Lua: Bye")
end
