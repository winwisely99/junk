# RTL ( Real Time Communication)

Each Org runs their own Relay Server for the RTL.

We use the works "Relay Server" from nwo on in this doc...

Modules that use this are all Layer 2 in our Architecture
- things like Cal, Chat, Docs, etc etc

The idea is that each Org holds the data for Its users.
- The data can be encrypted by the client and so the RTL Server has no idea what the data really is.

NATS is the obvious way to do this, but its a framework.
Recently NATS has gotten most of the functionality we need.
- A Org Relay Server then is essentially a "Leaf Node" in NATS terminology
	- doc: https://docs.nats.io/nats-server/configuration/leafnodes
- We wont get HA Persistence unless we install Postresql though !!! SHIT !!

SimpleIOT looks like a very good fit, and the dev is nice
https://github.com/simpleiot/simpleiot
- Here is his due diligence where you can see it all.
	- https://github.com/simpleiot/simpleiot/issues/62
- GUI is ELM. 
	- We can use it for Testing at least.
- Types is based on Protobufs, and so then easy to use with Flutter
- AUthZ model is correct for us: https://github.com/simpleiot/simpleiot/blob/master/data/data.go#L5
- DB is Bolt DB: https://github.com/simpleiot/simpleiot/blob/master/db/db.go
	- Has AUthZ model in there which works for us because the Its a Org Server.


## ion

obvious.... 

## sora

https://github.com/hakobera/go-sora

- uses nhooyr.io/websocket ( websocket that can do wasm) && github.com/pion/webrtc/v2 ( webrtc)
- docs: https://sora.shiguredo.jp/support#sora-before

- management and config: https://www.sakura.ad.jp/services/imageflux/livestreaming/
	- https://github.com/imageflux-jp/livestreaming-beta-doc/blob/master/api.md
	- doc: https://translate.google.com/translate?sl=auto&tl=en&u=https%3A%2F%2Fsora-doc.shiguredo.jp%2Fsafari

- sdk
	- https://github.com/shiguredo/momo
		- the core c ++
	- https://github.com/shiguredo/sora-js-sdk
		- web
	- https://github.com/shiguredo/sora-android-sdk
		- android
	- https://github.com/shiguredo/sora-ios-sdk
		- ios