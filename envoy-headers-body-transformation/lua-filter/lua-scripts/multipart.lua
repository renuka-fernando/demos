function envoy_on_request(request_handle)
    request_handle:logInfo("Hello REQ PATH Lua1")
    local request_headers = request_handle:headers()
    local request_headers_table = {}
    for key, value in pairs(request_headers) do
        request_handle:logInfo("Lua1 Request Headers: " .. key .. "->" .. value)
        request_headers_table[key] = value
    end
    request_handle:logInfo("Body Len: " .. request_handle:body():length())
    local request_body = request_handle:body():getBytes(0, request_handle:body():length())
    request_handle:logInfo("Lua1 Request Body: " .. request_body)

    request_headers_table[":method"] = "POST"
    request_headers_table[":path"] = "/multipart"
    request_headers_table[":authority"] = "mediation_service"
    local _, mediation_response_body_str = request_handle:httpCall(
        "mediation_service",
        request_headers_table,
        request_body,
        100000,
        false
    )
end