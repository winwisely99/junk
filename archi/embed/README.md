# Embed

This is about our need to embed some functionality in the Flutter clients ( web, mobile and Desktop),
because certain libs just dont exist in Dart.


If we embed then we need to provide a Protobuf based layer to:
- Networking
- DB
- data PUB SUB and RPC
- image file upload and download.
- crypto things.



## crypto

We need to sign messages locally, so that the Servers are only holding encrypted data,
and thus protecting users privacy

- https://github.com/jerson/flutter-openpgp
	- works on Web, Mobile and Desktop
	- Has been tested and works very well
	- Will need integration to main code but should be easy.


# Out of Scope

Everything below is out of scope because we decided to stick with Flutter doing everything else.

But the notes are below in case we want to pick it up again.

The reason for even attempting this is two fold:
1. Easier development because Flutter is just a View, with everything else being handled by golang
- So we are less reliant on Flutter Devs
2. Can change from Flutter to GIO, react or anything if need be
- Its not that we really would, but its very useful for future extensibility and future proofing.




## Networking 

NATS OR GRPC-web replaced to use Websockets that can work with WASM

Use this Websocket lib. https://godoc.org/nhooyr.io/websocket
See: https://godoc.org/nhooyr.io/websocket#pkg-subdirectories

Examples

https://github.com/vugu-examples/tinygo/blob/master/generate.go

https://github.com/elliotpeele/wasmws/blob/master/go.mod



## Hidden Servers.
Remote Dialer to Orgs Servers anywhere.
https://github.com/rancher/remotedialer



## Auth

Server: https://github.com/oauth2-proxy/oauth2-proxy

OIDC oAuth2 Provider: https://github.com/dexidp/dex/blob/master/Documentation/getting-started.md
- SO that users can auth against our own Server too.

middleware checker: https://github.com/auth0/go-jwt-middleware
- all golang code canse this



## Design / Stack

Flutter

- Only has View and View Routing
- Keeps the Flutter Devs only doing what they do best

Flutter Embed

- Golang code cross compiled to Web (tinygo compiler), Desktop (go compiler) and Mobile (gomobile compiler)
- Networking. nats.go lib used but:
	- Web, we need to adapt the nats.go lib to use Websockets. Not that NATS Server now fully suppots Websockets :)
	- Desktop / Mobile uses the standard nats.go lib.
- Messaging Patterns
	- PUB SUB, with a single connection.
	- File Upload and download using chunking.
- Security
	- Handles all Security aspects in tandem with the Server
- Persistance
	- Has a Database that works for Web and Native.
	- All changes to the DB Table rows emit an event to the Flutter layer, making it easy for them to update their views.


Flutter
- Now we can embed the golang and expose it using FFI
- Then Flutter just does Views and data calls and the golang embed handles all the other stuff like
	- Data calls
	- File upload, download
	- Security ( enforced by NATS Server itself )
	- Database using Genji.


## Other

https://github.com/simpleiot/simpleiot
- nice wrapper
- Has Twillo integration ( https://github.com/kevinburke/twilio-go), so can do SMS and Voice Messages.
	- For 2FA Security.
- Nice APi that matches our needs nicely: https://github.com/simpleiot/simpleiot/blob/master/docs/api.md


Wrap Consul with GRPC, so everything can use it. Much needed
https://github.com/mbobakov/grpc-consul-resolver

Run NAST and NATS Server embedded, so we can run other stuff with it. Much needed
https://github.com/influxdata/influxdb/tree/master/nats
- See cmd/launchd to see how to start it up and let others use it.


