import ballerina/io;
import ratelimit_decision_maker.verifier;

// rate limiter gRPC service calls here.
public function main() returns error? {
    // resouce can be "app::Custom" or we have to have two, variables
    // we can also define some optional attributes variable.
    // can we use any data type: https://ballerina.io/learn/by-example/any-type.html
    // org id: string or get int from DB?
    boolean quotaAvailable = check verifier:isQuotaAvailable("renukafernando", "Custom");
    io:println(quotaAvailable);
}
