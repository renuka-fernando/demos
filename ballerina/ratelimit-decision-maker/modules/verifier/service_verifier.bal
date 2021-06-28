import ballerina/io;

class ServiceVerifier {
    *Verifier;

    function canProcess(string res) returns boolean {
        string[*] resources = ["API", "Service Draft"];
        return  !(resources.indexOf(res) is ());
    }

    function isQuotaAvailable(string orgId, string res) returns boolean {
        io:println("Service Verfifier");
        return false;
    }
    
}