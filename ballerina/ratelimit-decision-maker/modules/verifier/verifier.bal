import ballerina/io;

type Verifier object {
    function canProcess(string res) returns boolean;
    function isQuotaAvailable(string orgId, string res) returns boolean;
};

public type Tier record {|
    int apiQuota;
    int serviceQuota;
    int integrationQuota;
|};

Verifier[] v;

public function isQuotaAvailable(string orgId, string res) returns boolean {
    boolean found = false;
    foreach Verifier x in v {
        if x.canProcess(res) {
            // we can get tier from here or inside this function
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
    v = [new ServiceVerifier(), new IntegrationVerifier(), new RemoteAppVerifier()];
}
