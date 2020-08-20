# Security

End to End Encryption involves the following foundations.
- EOW: Encrypted Over the Wire.
- EAR: Encrypted At Rest.

## Deployment options

All Clients has Persistent state and a background worker, using the Service Worker pattern.

Web PWA
- Much harder to take down
Web View PWA
- Same as Web, but with easier usage as it creates a Desktop Icon
Native ( Desktop and mobile)
- Desktop

White label approach:
Deployment to Mobile requires a huge amount of hassle and you can be blocked.
Deployment to Desktop requires notary signing, and i am sure that can also eventually be blocked.
So "white label" based sales approach is not really a practical option due to the amount or work.

Defense from blocking:
We run on all platforms using the same code base, and this gives us some level of defense from being blocked, as we can at least advise users to only use Web.
- Web
	- requires ICANN ake down and NOT possible.
- Mobile
	- Android side loading is very possible.
	- IOS side loading is not possible.
- Desktop
	- Windows does not block
	- Apple will eventually start blocking i expect or at least making it a PITA for the user.


## Notifications

In general we can define 2 levels of Notifications architecturally:

- OS Notifications: When the app is asleep, you need to wake it up so the user can see the message(s).
- App Notifications: Once awake, the internal messaging system takes over.

With OS Notifications, we MUST send messages over Google, Apple and Microsoft servers.
- They can block us at any time.
- They can see the messages, hence why i suggest Sentinel Style messages.

Presence

On our clients and backend we run a presence sentinel system to know if a user has the App open and on which of their devices.
This allows us to:

- Decide if we need to send a OS Notification and to which device ( based on last presence beacons device ID)
- Then keep sending App Notifications to the correct device. When the user starts on a different device, the same messages will be sent so it catches up, but will not be App Notifications, but rather data subscriptions, where we know they have already seen the new Message previously.


Support Matrix:

- Web
	- Service Worker supports push messaging of OS Notifications, but is still immature and not widely supported.
	- Service Worker supports push messaging of App Notifications, and is usable but very new.
	- Webview may have better support, but not hopeful.
	- Summary: https://www.thinktecture.com/en/pwa/push-api/
		- Looks like we have to use the Google, Apple and Microsoft gateways to do wakeup ?
	- CanIUse matrix: https://caniuse.com/#feat=mdn-api_pushmanager

- Mobile
	- Must be sent via Apple and Google gateways. Support is good.
	- So best to send only a sentinel style message notification, just to open the app and then send real message with internal system.

- Desktop
	- We run a background Service, and our Servers can send the notifications to it.
	- This shows an OS level Notification, and then opens the app to the correct route using Deep linking.
	- So can use the same approach as with Desktop using a Sentinel style, and show the real message in the app itself.



## Network Layer

### DNS layer over port 53

Need to prevent leaking over the network to your ISP / DNS provider

Options are :

DoH: https://en.wikipedia.org/wiki/DNS_over_HTTPS
https://en.wikipedia.org/wiki/DNS_over_TLS
- Requires setup by user.
- Not possible on older android mobile.

Wireguard 
https://github.com/tailscale
- Keys to this are EAR against the OS password.
- We can embed this in the Mobile and Desktop client
- For Web, we cant and so would need the user to download a Desktop Client to use their desktop web browser


### DNS Hosting

Suggest we use Cloudflare, as they have a history of NOT removing actors that are activist.

Can also use non pubic static IP's then which is useful for Servers as well as Orgs running their own Gateway or Relay Servers.
https://github.com/jpillora/dynflare






### Network Transport

We use TLS 1.3 / HTTPS with Certs auto provisioned from Lets Encrypt.
Certs are stored centrally.

## Data Layer

Each User has a Private key on their IOT device. When they add new devices that key is transferred via QR Code.
- Stored Encrypted at Rest.

Each "Room", which is a point where users exchange data for each Module instance has a public key held by the Gateway. This allows to encrypt all data at Rest on the Client and Server.

## Servers

We are planning to use NATS as our main Server and Client Software.
Here are some doc links:
Security Audit: https://nats.io/blog/nats-security-update/

https://docs.nats.io/nats-server/configuration/gateways


Zero Trust based on NATS, so we have no access to the unencrypted data.

Security Model:
- Holds the Username and password and claims ( for AUTH and AUTHZ)
- Claims are meta data to model LDAP like schema, Roles, Policy
- LDAP
	- Orgs
		- Role for that org
	- Projects
		- Role for that project
	- Rooms ( maybe not needed i think as its over kill)
		- Role for a Room in a Project
- Roles ( attached to LDAP )
	- Owner
	- User
- Policy ( attached to LDAP )
	- 2FA via SMS
	- 2FA via WebAuthn
	- 2FA via Fido2
	- 2FA via Friend Intro
	- More can be added.

### JWT Server

This is where users and their rights are created and held securely.

Provides auth tokens to clients that can be used by the Server to check their access rights.

NATS Accounts Server is used.
- replicates to all nodes in the global cluster.

### Gateway Server

This is a generic golang Server.

Org and Project Home pages
- These are held here, and can be simple Hugo templates, allowing a static web server to advertise this.

News
- News using AMP or other can also be hosted here.

Auth & AuthZ enforcement
- User Login, Signup, Accont Management.
- The JWT token is provided by the Client, and so we dont need to talk to the NATS Accounts Server once the token is exchanged.

Authz Module
- Provides multi level policy based AUTHZ, so that Orgs can set auth policies for users accessing certain Projects and Rooms.


### Relay Server

This Server is responsible for relaying messages between users.
Needed so that offline Clients can send messages to each other.
Designed for very poor network connectivity using message queue with ACK.

NATS is used for this
- Data
- Images and files. These are chunked to a max of 512 kb.

AUTHZ enforced by the JWT token inherent in the NATS Architecture.

Holds the public keys of each room endpoint , so that:
- we can give those to other users to decrypt data originating from a users device.
- a user is only give the public key if they pass the Gateway Check level where Policy enforement occurs.

All data types are code generated from Protocolbuffers, so that:
- quick to develop
- schema evolution, so that clients not updated by the users can still interoperate with Servers.

### Tunnel Server

If an Org wishes to run their own Relay Server and / or Gateway Server ,but not expose it to the public internet, then we can easily run a Tunnel Server.

This tunnel is only a pass through with the Tunnels enforcing the TLS 1.3 encryption over the wire.
All other security functionality is enforced by the standard Relay Server itself.


- In the client software, the default to the Global Gateway Server, would need to be changed by each User in that org
- Or we could model that Org in our own gateway as having their own Gateway / Relay server, and so return to the Client the Tunnel Server URL.

What we do here is really down to the Use Cases that come up.

### DDOS Attacks

Google Project Shield has offered us free protection to the GCN domain.
This would protect Tunnel, Gateway an Relay Servers.

Fuzzing and honeypots. We could setup a honeypot also.


## Deployment

We do not use Kubernetes or Docker because:

- Each Server is just a single binary.
- Service Discovery and Config is 100% provided by Consul.
- NATS can do self discovery once booted, and just needs one of the nodes URL in order to find all other NATS nodes
- Less complexity speeds development and lowers security mistakes.
	- You can just boot a linux server anywhere, SSH the binary onto it, and run the boostrapper that is pat of the binary.
- Easy to make the binaries self updating with zero downtimes.
- Scales very well
	- A basic NATS Server can do 1 million messages a second, and so no vast scaling needs
- Volumes not needed
	- We can use the local disk of each NATS Server
- Monitoring and Telemetry are baked into NATS using Prometheus, so we do not need anything for this.
	- See: https://docs.nats.io/nats-server/configuration/monitoring
	- Easy to build HIgh level dashboards on top of this as its JSON. Even can build a FLutter Dashboard and let each Org manage this in the App if the User is a Admin for an Og.
- NATS can be public DMZ facing. No load balancer or application firewall is needed.
	- The NATS clients on each target discovers all NATS Servers.
- Much lower running costs.

NATS supports embedding and so we can embed NATS inside our own binary in order to add functionality easily.

NATS does support also running on Kubernetes with a Kubernetes Operator if we want to do it.
- We have found that Orgs cant techncially manage this, but they can run a few binaries on a Linux Server.



## Clients

We designed this to have 2 primary layers:
- GUI built with Flutter
- Logic built with golang.

### GUI

100% Flutter based with simple views and no logic.
Highest quality in the industry i would say.

### Logic 

Being build in golang allows:
- our devs to build both sides, as Flutter devs dont have the skills to handle complex apps like this.
- use advanced networking libraries.

Compiler targets for each client target are:
Web: gopherjs (WASM) or Tinygo (WASM). Tinygo is preferred but has sever limitation still ( see: https://tinygo.org/lang-support/stdlib/)
Desktop: naive golang compile
Mobile: GoMobile compiler
Embedded. Tinygo

The challenge at the moment is to modify the Nats golang client to work with Web. Issue: https://github.com/nats-io/nats.go/issues/588
- Not getting any uptake because the NATS team prefer to write clients is the targets own language. 

Store

We need a store and i would prefer to use a golang based one so that the Flutter devs dont have any ability to accidentally put in non encrypted data.
Because it must compile to WASM there are few possibilities, and so far its only https://github.com/genjidb/genji
- Because its golang we can easily make it work with only encrypted data.


## CI and CD

CI and CD are part of the security story because users need to know that the code they run is the same code intended.

Use Drone CI, so that we control all the CI.
We will need a Mac Mini and a Windows Intel NUC to build all Web, Desktop and Mobile targets.
Google, Apple and Microsoft signing keys can then be installed on these box.

Gitea can then be used for all Code, instead of github.
We can still use github if we want and then just mirror it to Gitea also.
See the Drone folder for details if curious....


## Self Updating

Because we dont use Kubernettes or docker we can simply use self updating binaries for the Servers.

https://github.com/jpillora/overseer


Clients can also use the same mechansim
https://github.com/sanbornm/go-selfupdate



