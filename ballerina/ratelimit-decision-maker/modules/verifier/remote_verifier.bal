import ballerina/io;

class RemoteAppVerifier {
    *Verifier;

    function canProcess(string res) returns boolean|error {
        // error if res is app but sub type is foo, i.e. "app::foo"

        return "Custom" == res;
    }

    function isQuotaAvailable(string orgId, string res) returns boolean|error {
        io:println("Remote Verfifier");
        return true;
    }
    
}