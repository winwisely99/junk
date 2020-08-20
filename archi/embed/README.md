# Embed

If we embed then we need to provide a Protobuf based layer to:
- Networking
- DB
- data PUB SUB and RPC
- image file upload and download.

## Why ?

- Removes the need for Envoy, GRPC and GRPC-Web
	- We can still use Protobufs and its code gen to good things.

- Has its own JWT Server and Store.

- Can do messaging and RPC patterns.
	- Images / Blobs can use File chunking.

- Much less resource use. SO is faster on smaller devices.

Example
- https://github.com/jerson/flutter-openpgp

## Hosting

https://www.pulumi.com/docs/intro/cloud-providers/hcloud/
https://github.com/pulumi/pulumi-hcloud


- k3 powered cloud: https://www.civo.com/blog/kube100-is-here

- scenarios for k3s: https://thenewstack.io/how-rancher-labs-k3s-makes-it-easy-to-run-kubernetes-at-the-edge/
	- Looks like it fits our usage perfectly but not for ONPremise
	- OnPremise needs to be able to run on a Desktop without docker.

- Use Terraform to rollout k3s
	- https://github.com/xunleii/terraform-module-k3s
	- suppots hertzner and apparently works really well.

- There is NO ENvoy, but only Traefik, so the dockers must hold the Envoy OR we dont use GRPC-Web

- I think there is no CSI, Rook ? 

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


