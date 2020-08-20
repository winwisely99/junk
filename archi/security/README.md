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


### Gateway Server

Zero Trust based on NATS.

Auth
- Does basic username and password authentication (AUTH) to enter the system itself, so that we dont need to hold users telephone number.
	- This data is held by us and encrypted against a secret. It is federated to all our gateway servers.

Authz
- Provides multi level policy based AUTHZ, so that Orgs can set auth policies for users accessing certain Projects and Rooms.
	- What 2FA or other factors are used for this AUTHZ is still to be decided.

Holds the public keys of each user and room , so that:
- we can give those to other users to decrypt data originating from a users device.
- we can do AUTHZ on access to the Server APIs for messaging.

All data types are code generated from Protocolbuffers, so that:
- quick to develop
- schema evolution, so that clients not updated by the users can still interoperate with Servers.

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

We need a store and i would prefer to use a golang based one so that the Flutter devs dont have any ability to accidently put in non encrypted data.
Because it must compile to WASM there are few possibiliies, and so far its only https://github.com/genjidb/genji
- Because its golang we can easily make it work with only encrypted data.





