# Map (string-to-string dictionary) of key value pairs shared in Request and Response flow

#
public type Context record {};

public type HandleRequest_RequestBody record {
    # Map (string-to-string dictionary) of key value pairs of headers
    Headers headers?;
    # Base64 encoded body
    Body body?;
    # Map (string-to-string dictionary) of key value pairs shared in Request and Response flow
    Context context?;
};

# Map (string-to-string dictionary) of key value pairs of headers

#
public type Headers record {};

# Array of header keys

#
# + string - Array of header keys
public type HeaderKeys string[];

# Base64 encoded body

#
public type Body string;

public type HandleResponse_RequestBody record {
    # Map (string-to-string dictionary) of key value pairs of headers
    Headers headersToAdd?;
    # Array of header keys
    HeaderKeys headersToRemove?;
    # Map (string-to-string dictionary) of key value pairs of headers
    Headers headersToReplace?;
    # Base64 encoded body
    Body body?;
    # Map (string-to-string dictionary) of key value pairs shared in Request and Response flow
    Context context?;
};
