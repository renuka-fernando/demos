import ballerina/io;
import ratelimit_decision_maker.verifier;

// rate limiter gRPC service calls here.
public function main() returns error? {
    // resouce can be "app::Custom" or we have to have two, variables
    // we can also define some optional attributes variable.
    // can we use any data type: https://ballerina.io/learn/by-example/any-type.html
    // org id: string or get int from DB?

    // we can get tier from here.

    // Tier tier = getTeir(orgId);
    // verifier:isQuotaAvailable(RequestOBject, Tier);
    boolean quotaAvailable = check verifier:isQuotaAvailable("renukafernando", "app::Custom");
    io:println("No Errors");
    io:println(quotaAvailable);
}
