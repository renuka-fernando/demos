function getActionHeaderKey(header,action)
    local action_len = string.len(action)
    if string.sub(header,1,action_len)==action then
        return true, string.sub(header,action_len+1,string.len(header)+1)
    end
    return false, nil
end

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

    local x_wso2_context_key = "x-wso2-context"
    request_headers_table[x_wso2_context_key .. "-method"] = request_headers_table[":method"]
    request_headers_table[x_wso2_context_key .. "-path"] = request_headers_table[":path"]
    request_headers_table[":method"] = "POST"
    request_headers_table[":path"] = "/handlerequest"

    local mediation_headers, mediation_body = request_handle:httpCall(
        "ballerina_service",
        request_headers_table,
        request_body,
        100000,
        false
    )
    request_handle:logInfo("Lua1: Done Mediation HTTP Call")
    request_handle:logInfo("Lua1: Mediation body: " .. mediation_body)

    local content_length = request_handle:body():setBytes(mediation_body)
    request_handle:headers():replace("content-length", content_length)

    local x_add = "x-wso2-add-"
    local x_remove = "x-wso2-remove-"

    -- local actions = {
    --     ["x-wso2-add-"] = request_handle:headers():add,
    --     ["x-wso2-remove-"] = request_handle:headers():remove,
    -- }
    
    for k, v in pairs(mediation_headers) do
        -- for act_str, act in pairs(actions) do
        --     local action_len = string.len(act_str)
        --     local updated_key = getActionHeaderKey(k, act_str)
        --     if updated_key then
        --       act(updated_key,v)
        --       break
        --     end
        -- end

        local is_action, updated_key = getActionHeaderKey(k, x_add)
        if is_action then
            request_handle:headers():add(updated_key,v)
        else
            is_action, updated_key = getActionHeaderKey(updated_key, x_remove)
            if is_action then
                request_handle:headers():remove(k)
            end
        end
    end
end

function envoy_on_response(response_handle)
    response_handle:logInfo("Bye Lua1")
end
