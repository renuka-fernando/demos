import ballerina/http;
import ballerina/mime;
import ballerina/io;
import ballerina/log;

// import ballerina/lang.array;
// import ballerina/xmldata;
// import ballerina/lang.runtime;

listener http:Listener ep = new (9080
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
        io:println("Received Payload");
        io:println(payload);

        http:Response resp = new;
        resp.setPayload("hello from ballerina backend");

        check caller->respond(resp);
    }

    resource function post 'stream(http:Caller caller, http:Request request) returns error? {
        stream<byte[], io:Error?> streamer = check request.getByteStream();

        // check io:fileWriteBlocksFromStream(
        //                             "./received.txt", streamer);
        // check streamer.close();
        // check caller->respond("File Received!");

        io:Error? forEach = streamer.forEach(function (byte[] bodyBytes) {
            io:println("Receiving body bytes ------------------------------------------------");
            int min = 10;
            if bodyBytes.length() < min {
                min = bodyBytes.length();
            }
            io:println('string:fromBytes(bodyBytes.slice(0, min)));
        });
        check streamer.close();
        if forEach is error {
            log:printError("Error looping stream", forEach);
        }

        log:printInfo("Request streaming completed");
        http:Response response = new;
        response.setPayload("Done Streaming in Ballerina");
        var result = caller->respond(response);
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }

    resource function post multipart(http:Caller caller, http:Request request) returns error? {
        http:Response response = new;

        var bodyParts = request.getBodyParts();
        if (bodyParts is mime:Entity[]) {
            foreach var part in bodyParts {
                io:println("Body part");
                io:println(part);
            }
            response.setPayload(<@untainted> bodyParts);
        } else {
            log:printError(<string> bodyParts.message());
            response.setPayload("Error in decoding multiparts!");
            response.statusCode = 500;
        }
        var result = caller->respond(response);
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}
