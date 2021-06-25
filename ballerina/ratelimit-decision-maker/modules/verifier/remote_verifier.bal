import ballerina/io;

class RemoteApp {
    *Verifier;

    function canProcess(string res) returns boolean {
        return "Custom" == res;
    }

    function isQuotaAvailable(int orgId, string res) returns boolean {
        io:println("Integration Verfifier");
        return true;
    }
    
}