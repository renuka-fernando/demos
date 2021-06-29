import ballerina/io;

type Verifier object {
    function canProcess(string res) returns boolean|error;
    function isQuotaAvailable(string orgId, string res) returns boolean|error;
};

public type Tier record {|
    int apiQuota;
    int serviceQuota;
    int integrationQuota;
|};

// we can use a map instead of an array, and remove canProcess() function
// but if we have canProcess(), verifiers can introduce its own logic.
Verifier[] v;

public function isQuotaAvailable(string orgId, string res) returns boolean|error {
    boolean found = false;
    foreach Verifier x in v {
        boolean ok = check x.canProcess(res);
        if ok {
            // we can get tier from here or inside this function
            // if there are no multiple resources called at once (multiple verifiers) we can call it inside verifier.
            // otherwise we can call it here and pass tier to verifier.
            return x.isQuotaAvailable(orgId, res);
        }
    }

    // this is not being rate limited
    io:println("NOT");
    return true;
}

public function getTeir(int orgId) returns Tier {
    return {
        apiQuota: 3,
        serviceQuota: 7,
        integrationQuota: 5
    };
}

function init() {
    v = [
        new ServiceVerifier(),
        new IntegrationVerifier(),
        new RemoteAppVerifier()
    ];
}
