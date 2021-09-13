import ballerina/http;
import ballerina/io;
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
        string payload = check request.getTextPayload();
        
        foreach string key in request.getHeaderNames() {
            string val = check request.getHeader(key);
            io:println(`Headers: ${key} -> ${val}`);
        }

        io:println("received payload: " + payload);

        http:Response resp = new;
        resp.setHeader("x-wso2-add-shape", "plain");
        resp.setPayload(string `Hello, ${payload}!`);
        
        check caller->respond(resp);
   }

    resource function post req(@http:Payload string payload) returns string {
        io:println("backend is called");
        // runtime:sleep(30);
        io:println("received payload: " + payload);
        return "{\"name\": \"Alice\"}";
    }
}
