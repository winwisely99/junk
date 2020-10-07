# Google Disco

This will be part of the standard binary. You just run it in Discovery mode
- Its DB will be some google highly HA one.



URL format of a Service: 001.chat.alpha.domain.com

For each Service, it should register itself the Disco server to tell it the endpoint its running from.
When there are many instance of a Service, the system disco service tell all other instances about each other.

Clients can then get the Endpoint(s) from the discover server of each Service instance.


https://github.com/googleapis/google-api-go-client/tree/master/google-api-go-generator/internal/disco
https://mholt.github.io/json-to-go/

github.com/googleapis/gnostic
https://github.com/googleapis/gnostic/tree/master/plugins

https://github.com/googleapis/gnostic-grpc