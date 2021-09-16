import ballerina/log;
import ballerina/mime;

// The content logic that handles the body parts vary based on your requirement.
function handleContent(mime:Entity bodyPart) {
    // [Get the media type](https://docs.central.ballerina.io/ballerina/mime/latest/functions#getMediaType) from the body part retrieved from the request.
    var mediaType = mime:getMediaType(bodyPart.getContentType());
    if (mediaType is mime:MediaType) {
        string baseType = mediaType.getBaseType();
        if (mime:APPLICATION_XML == baseType || mime:TEXT_XML == baseType) {
            //[Extracts `xml` data](https://docs.central.ballerina.io/ballerina/mime/latest/classes/Entity#getXml) from the body part.
            var payload = bodyPart.getXml();
            if (payload is xml) {
                log:printInfo("XML Payload");
                log:printInfo(payload.toString());
            } else {
                log:printError(payload.message());
            }
        } else if (mime:APPLICATION_JSON == baseType) {
            //[Extracts `json` data](https://docs.central.ballerina.io/ballerina/mime/latest/classes/Entity#getJson) from the body part.
            var payload = bodyPart.getJson();
            if (payload is json) {
                log:printInfo("JSON Payload");
                log:printInfo(payload.toJsonString());
            } else {
                log:printError(payload.message());
            }
        } else if (mime:TEXT_PLAIN == baseType) {
            //[Extracts text data](https://docs.central.ballerina.io/ballerina/mime/latest/classes/Entity#getText) from the body part.
            var payload = bodyPart.getText();
            if (payload is string) {
                log:printInfo("Plain Text Payload");
                log:printInfo(payload);
            } else {
                log:printError(payload.message());
            }
        }
    }
}

function getContentDispositionForFormData(string partName)
                                    returns (mime:ContentDisposition) {
    mime:ContentDisposition contentDisposition = new;
    contentDisposition.name = partName;
    contentDisposition.disposition = "form-data";
    return contentDisposition;
}
