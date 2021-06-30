import ballerina/io;

class IntegrationVerifier {
    *Verifier;

    function canProcess(string res) returns boolean|error {
        // error if res is app but sub type is foo, i.e. "app:Webhook"

        string[*] resources = ["Webhook", "Manual", "Integration Draft", "Schedule", "Email"];
        return  !(resources.indexOf(res) is ());
    }

    function isQuotaAvailable(string orgId, string res, Tier tier) returns boolean|error {
        io:println("Integration Verfifier");
        // actual backend ("Integration" | "Webhook Manual Integration Draft|Schedule|Email")
        // actual backend
        return true;
    }
    
}