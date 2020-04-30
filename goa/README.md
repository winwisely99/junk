# goa

v3 looks pretty good
- http
- grpc
	- Does not give a grpc proto from whcih we can gen from.
- boltdb store
- security
- swagger

docker
https://github.com/ThreeDotsLabs/nats-example
- for dev container

encoders
https://github.com/goadesign/examples/tree/master/encodings
- its availabel to you as a plugin

Usage 
- A muation comes in via goa, and we can then push it out over NATS / Watermill
- The push out can use the watermill ( https://github.com/ThreeDotsLabs/watermill-http)
	- they have a SSE handler and so we can sue that.
	- dart: https://github.com/dart-lang/sse

ALI also did push work.
https://github.com/ali-zohrevand/ashyanet-api



Traction
- finally is getting strong traction inside the repo and in being used

DB / Store
- https://github.com/goadesign/gorma
	- is NOT compat with v3 !! shit 
- https://github.com/vitessio/messages
- mySQL that scales

Search: https://github.com/search?l=Go&o=desc&q=goa.design%2Fgoa%2Fv3&s=indexed&type=Code
