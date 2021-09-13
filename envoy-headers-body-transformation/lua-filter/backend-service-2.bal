import ballerina/http;
// import ballerina/io;
// import ballerina/lang.runtime;
service / on new http:Listener(9091) {
    resource function get lua() returns string {
        return "Backend response with LUA";
    }
    resource function get without() returns string {
        return "Backend response WITHOUT LUA";
    }
}
