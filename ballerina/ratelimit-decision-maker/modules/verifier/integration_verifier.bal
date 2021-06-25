import ballerina/io;

class Integration {
    *Verifier;

    function canProcess(string res) returns boolean {
        string[*] resources = ["Webhook", "Manual", "Integration Draft", "Schedule", "Email"];
        return  !(resources.indexOf(res) is ());
    }

    function isQuotaAvailable(int orgId, string res) returns boolean {
        io:println("Integration Verfifier");
        return true;
    }
    
}