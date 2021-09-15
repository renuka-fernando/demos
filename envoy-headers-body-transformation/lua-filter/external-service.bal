import ballerina/http;
import ballerina/io;
import ballerina/lang.array;
import ballerina/xmldata;
import ballerina/lang.value;
// import ballerina/lang.runtime;

listener http:Listener securedEP = new(9090,
    secureSocket = {
        key: {
            certFile: "certs/ca.crt",
            keyFile: "certs/ca.key"
        }
    }
);

service / on securedEP {
    resource function post handlerequest(http:Caller caller, http:Request request) returns error? {
        io:println("backend is called");
        
        foreach string key in request.getHeaderNames() {
            string val = check request.getHeader(key);
            io:println(`Headers: ${key} -> ${val}`);
        }

        string payload = check request.getTextPayload();
        io:println("received payload: " + payload);

        json payloadJson = check value:fromJsonString(payload);
        json bodyBase64Json = check payloadJson.body;
        byte[] bodyBytes = check array:fromBase64(bodyBase64Json.toString());
        string bodyStr = check 'string:fromBytes(bodyBytes);
        json bodyJson = check value:fromJsonString(bodyStr);

        io:println("Decoded Payload.Body");
        io:println(bodyJson);
        
        xml? xmlData = check xmldata:fromJson(bodyJson);
        io:println("xmlData:");
        io:println(xmlData);

        string respBody;
        if xmlData is xml {
            respBody = xmlData.toString();
        } else {
            respBody = "<hello>ERROR</hello>";
        }

        string respBodyStr = array:toBase64(respBody.toBytes());
        json respPayload = {
            body: respBodyStr,
            headersToAdd: {
                newHeader: "new val"
            },
            headersToReplace: {
                "content-type": "application/xml"
            }
        };
        
        http:Response resp = new;
        resp.setPayload(respPayload.toJsonString());
        
        check caller->respond(resp);
   }

    resource function post req(@http:Payload string payload) returns string {
        io:println("backend is called");
        // runtime:sleep(30);
        io:println("received payload: " + payload);
        return "{\"name\": \"Alice\"}";
    }
}
