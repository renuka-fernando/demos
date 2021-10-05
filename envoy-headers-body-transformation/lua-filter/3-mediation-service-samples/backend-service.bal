import ballerina/http;
import ballerina/io;

listener http:Listener ep = new (9080);

service / on ep {
    resource function post transform(http:Caller caller, http:Request request) returns error? {
        io:println("backend is called");

        foreach string key in request.getHeaderNames() {
            string val = check request.getHeader(key);
            io:println(`Headers: ${key} -> ${val}`);
        }

        xml xmlPayload = check request.getXmlPayload();
        io:println("Received Payload");
        io:println(xmlPayload);

        http:Response resp = new;
        resp.setXmlPayload(xmlPayload);

        check caller->respond(resp);
    }

    resource function post without(http:Caller caller, http:Request request) returns error? {
        io:println("backend is called");

        http:Response resp = new;
        resp.setTextPayload("Hello");

        check caller->respond(resp);
    }
}
