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

        string payload = check request.getTextPayload();
        io:println("Received Payload");
        io:println(payload);

        http:Response resp = new;
        resp.setXmlPayload(xml`<hello>Hello from bal service</hello>`);

        check caller->respond(resp);
    }
}
