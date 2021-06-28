import ballerina/io;

class RemoteAppVerifier {
    *Verifier;

    function canProcess(string res) returns boolean {
        return "Custom" == res;
    }

    function isQuotaAvailable(string orgId, string res) returns boolean {
        io:println("Remote Verfifier");
        return true;
    }
    
}