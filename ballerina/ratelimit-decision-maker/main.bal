import ballerina/io;
import ratelimit_decision_maker.verifier;

public function main() {
    io:println(verifier:IsQuotaAvailable(1, "API"));
}
