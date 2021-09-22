import ballerina/http;
import ballerina/io;
import ballerina/lang.array;
import ballerina/log;
import ballerina/xmldata;
import ballerina/lang.value;

listener http:Listener ep = new (9090);

service / on ep {

    resource function post handlerequest(http:Caller caller, http:Request request) returns error? {
        log:printInfo("mediation service is called");
        
        // print headers
        foreach string key in request.getHeaderNames() {
            string val = check request.getHeader(key);
            io:println(`Headers: ${key} -> ${val}`);
        }

        json|error jsonBody = requestToJson(request);

        string respBody;
        if jsonBody is json {
            xml?|error xmlData = xmldata:fromJson(jsonBody);
            if xmlData is xml {
                respBody = xmlData.toString();
            } else if xmlData is () {
                respBody = "<root>nil</root>";
                log:printInfo("Xml data is nil");
            } else {
                log:printError("Error while converting to XML", xmlData);
                respBody = "<error>mediation error</error>";
            }
        } else {
            log:printError("Error while converting request body to json", jsonBody);
            respBody = "<error>mediation error</error>";
        }

        byte[] respBodyBytes = respBody.toBytes();
        string respBodyStr = array:toBase64(respBodyBytes);
        json respPayload = {
            body: respBodyStr,
            headersToAdd: {
                helloWorldNewHeader: "Hello World"
            },
            headersToReplace: {
                "content-type": "application/xml"
            }
        };

        http:Response resp = new;
        resp.setJsonPayload(respPayload);
        check caller->respond(resp);
    }
}

function requestToJson(http:Request request) returns json|error {
    json payloadJson = check request.getJsonPayload();
    string bodyBase64 = check payloadJson.body;
    byte[] bodyBytes = check array:fromBase64(bodyBase64);
    string bodyStr = check 'string:fromBytes(bodyBytes);
    return value:fromJsonString(bodyStr);
}
