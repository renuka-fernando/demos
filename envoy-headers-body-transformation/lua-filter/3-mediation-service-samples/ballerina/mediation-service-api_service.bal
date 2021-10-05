import ballerina/log;
import  ballerina/http;

listener  http:Listener  ep0  = new (9090, config  = {host: "localhost"});

 service  /  on  ep0  {
        resource  function  post  handle\-request(@http:Payload  {} HandleRequest_RequestBody  payload)  returns  HandleResponse_RequestBody {
            log:printInfo("Called", (), {"payload": payload});
            return {
                headersToReplace: {
                    "content-type": "application/xml"
                },
                body: "PGhlbGxvPkZyb20gSW50ZXJjZXB0b3IgR28gU2VydmljZTwvaGVsbG8+Cg=="
            };
    }
        resource  function  post  handle\-response(@http:Payload  {} HandleRequest_RequestBody  payload)  returns  HandleResponse_RequestBody {
            log:printInfo("Called", (), {"payload": payload});
            return {
                headersToReplace: {
                    "content-type": "text/pain"
                },
                body: "RnJvbSBJbnRlcmNlcHRvciBCYWwgU2VydmljZSAtIFJlc3BvbnNlIEZsb3cK"
            };
    }
}
