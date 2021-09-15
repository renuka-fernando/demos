import ballerina/http;
import ballerina/io;
// import ballerina/lang.array;
// import ballerina/xmldata;
// import ballerina/lang.runtime;

listener http:Listener ep = new(9080
    // secureSocket = {
    //     key: {
    //         certFile: "certs/ca.crt",
    //         keyFile: "certs/ca.key"
    //     }
    // }
);

service / on ep {
    resource function post post(http:Caller caller, http:Request request) returns error? {
        io:println("backend is called");
        
        foreach string key in request.getHeaderNames() {
            string val = check request.getHeader(key);
            io:println(`Headers: ${key} -> ${val}`);
        }

        string payload = check request.getTextPayload();
        io:println("received payload: " + payload);

        http:Response resp = new;
        resp.setPayload("hello from ballerina backend");
        
        check caller->respond(resp);
   }

    resource function post req(@http:Payload string payload) returns string {
        io:println("backend is called");
        // runtime:sleep(30);
        io:println("received payload: " + payload);
        return "{\"name\": \"Alice\"}";
    }
}
