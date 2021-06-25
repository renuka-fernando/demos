import ballerina/io;

type Verifier object {
    function canProcess(string res) returns boolean;
    function isQuotaAvailable(int orgId, string res) returns boolean;
};

Verifier[] v;

public function IsQuotaAvailable(int orgId, string res) returns boolean {
    boolean found = false;
    foreach Verifier x in v {
        if x.canProcess(res) {
            return x.isQuotaAvailable(orgId, res);
        }
    }

    // this is not being rate limited
    io:println("NOT");
    return true;
}

function init() {
    v = [new Service(), new Integration(), new RemoteApp()];
}
