import ballerina/http;
import ballerina/io;
import ballerina/lang.array;
import ballerina/xmldata;
import ballerina/lang.value;
import ballerina/log;
import ballerina/mime;

// import ballerina/lang.runtime;

listener http:Listener ep = new (9090, 
    secureSocket = {
    key: {
        certFile: "certs/ca.crt",
        keyFile: "certs/ca.key"
    }
}
);

service / on ep {
    resource function post handlerequest_chunks(http:Caller caller, http:Request request) returns error? {
        stream<byte[], io:Error?> streamer = check request.getByteStream();
        io:Error? forEach = streamer.forEach(function(byte[] bodyBytes) {
            io:println("Receiving body bytes ------------------------------------------------");
            int min = 10;
            if bodyBytes.length() < min {
                min = bodyBytes.length();
            }
            io:println('string:fromBytes(bodyBytes.slice(0, min)));
        });
        check streamer.close();
        http:Response resp = new;
        resp.setPayload("DONE chunking");
        check caller->respond(resp);
    }

    resource function post handlerequest(http:Caller caller, http:Request request) returns error? {
        io:println("mediation service is called");

        // print headers
        foreach string key in request.getHeaderNames() {
            string val = check request.getHeader(key);
            io:println(`Headers: ${key} -> ${val}`);
        }

        // io:println("Received payload:");
        json payloadJson = check request.getJsonPayload();
        // io:println(payloadJson);
        json bodyBase64Json = check payloadJson.body;
        xml?|error xmlData = convertJsonToXml(bodyBase64Json);

        string respBody;
        if xmlData is xml {
            // io:println("xmlData:");
            // io:println(xmlData);
            respBody = xmlData.toString();
        } else {
            if xmlData is error {
                log:printError("Error while converting to XML", xmlData);
            }
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
        resp.setJsonPayload(respPayload);
        check caller->respond(resp);
    }

    resource function post multipart(http:Request request) returns http:Response|http:InternalServerError {
        http:Response response = new;
        // [Extracts bodyparts](https://docs.central.ballerina.io/ballerina/http/latest/classes/Request#getBodyParts) from the request.
        var bodyParts = request.getBodyParts();

        if (bodyParts is mime:Entity[]) {
            foreach var part in bodyParts {
                handleContent(part);
            }
            response.setPayload(bodyParts);
            return response;
        } else {
            log:printError(bodyParts.message());
            return {body: "Error in decoding multiparts!"};
        }
    }

}

function convertJsonToXml(json jsonVal) returns xml?|error {
    byte[] bodyBytes = check array:fromBase64(jsonVal.toString());
    string bodyStr = check 'string:fromBytes(bodyBytes);
    json bodyJson = check value:fromJsonString(bodyStr);

    xml? xmlData = check xmldata:fromJson(bodyJson);
    return xmlData;
}
