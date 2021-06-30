import ballerina/io;

type Verifier object {
    function canProcess(string res) returns boolean|error;
    function isQuotaAvailable(string orgId, string res, Tier tier) returns boolean|error;
};

public type Tier record {|
    int apiQuota;
    int serviceQuota;
    int integrationQuota;
|};

// we can use a map instead of an array, and remove canProcess() function
// but if we have canProcess(), verifiers can introduce its own logic.
Verifier[] v;

// verify
public function isQuotaAvailable(string orgId, string res) returns boolean|error {
    boolean found = false;
    foreach Verifier x in v {
        boolean ok = check x.canProcess(res);
        if ok {
            Tier tier = getTeir(orgId);

            // return x.isQuotaAvailable(orgId, res, tier);
            return x.isQuotaAvailable(orgId, res, tier);
        }
    }

    // this is not being rate limited
    io:println("NOT");

    // return true;
    return error("Unsupported Verfier");
}

public function getTeir(string orgId) returns Tier {
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
