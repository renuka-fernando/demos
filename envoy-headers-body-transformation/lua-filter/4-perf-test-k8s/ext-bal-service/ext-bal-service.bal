import ballerina/http;
import ballerina/log;

listener http:Listener ep = new (9090);

service / on ep {

    resource function post handlerequest(http:Caller caller, http:Request request) returns error? {
        log:printInfo("mediation service is called");

        json payloadJson = check request.getJsonPayload();
        string bodyBase64 = check payloadJson.body;
        json respPayload = {
            body: bodyBase64,
            headersToAdd: {
                helloWorldNewHeader: "Hello World"
            },
            headersToRemove: ["additional"],
            headersToReplace: {
                "replace-this": "correct value"
            }
        };

        http:Response resp = new;
        resp.setJsonPayload(respPayload);
        check caller->respond(resp);
    }

    resource function post handlerequest\-simple(http:Caller caller, http:Request request) returns error? {
        log:printInfo("mediation service (simple) is called");
        string payloadTxt = check request.getTextPayload();

        http:Response resp = new;
        resp.setTextPayload(payloadTxt);
        check caller->respond(resp);
    }
}
