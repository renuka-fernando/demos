import ballerina/io;

class ServiceVerifier {
    *Verifier;

    function canProcess(string res) returns boolean|error {
        // error if res is app but sub type is foo, i.e. "app::foo"

        string[*] resources = ["API", "Service Draft"];
        return  !(resources.indexOf(res) is ());
    }

    function isQuotaAvailable(string orgId, string res, Tier tier) returns boolean|error {
        io:println("Service Verfifier");
        return false;
    }
    
}