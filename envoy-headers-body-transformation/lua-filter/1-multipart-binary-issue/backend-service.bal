import ballerina/http;
import ballerina/mime;
import ballerina/io;
import ballerina/log;

listener http:Listener ep = new (9080);

service / on ep {
    resource function post multipart(http:Caller caller, http:Request request) returns error? {
        http:Response response = new;

        var bodyParts = request.getBodyParts();
        if (bodyParts is mime:Entity[]) {
            foreach var part in bodyParts {
                io:println("Body part");
                io:println(part);
                var mediaType = check mime:getMediaType(part.getContentType());
                string baseType = mediaType.getBaseType();
                if mime:IMAGE_PNG == baseType {
                    byte[] byteArray = check part.getByteArray();
                    check io:fileWriteBytes("fooo.png", byteArray);
                    io:println("fooo.png saved.");
                } else if mime:APPLICATION_JSON == baseType {
                    json j = check part.getJson();
                    io:println("Read json");
                    io:println(j.toJsonString());
                }
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
