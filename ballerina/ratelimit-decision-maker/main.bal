import ballerina/io;
import ratelimit_decision_maker.verifier;

public function main() {
    io:println(verifier:isQuotaAvailable("renukafernando", "Custom"));
}
