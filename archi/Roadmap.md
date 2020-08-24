# Roadmap

## Packages Phases

### Stage 1

Web App
- Web site built with existing Flutter bits
- 100% Read ONLY.
	- No Auth or Authz needed.
- Envoy and GPC-web
	- Must get Envoy and Lets Encrypt working.
	- Try to get Improbable working so we dont need envoy.
		- will make it easy to do the Lets Encrypt then also !!
- Data calls are GRPC
- Blob calls are HTTP calls.
- Golang Server does
	- Auth and Authz. Is passed through by Envoy
- White listing
	- Check the URL the call is from  and only return data they own.
	- Assume not other changed needed.

Native App
- Native only.
- Requires Singing and local CI, etc.
- Envoy and GRPC
	- Can do the required
- No DB. So much be connected to work.
- No Golang. Not needed since NO DB and not holding ANY data.
- Data calls
	- Uses GRPC for all IO to Server.
	- We can code gen both sides.
- Blob calls
	- Uses HTTP
- Envoy not needed because no Web
- Auth and Authz done at golang level
	- Requires JWT stuff on both sides though.


### Stage 2

Make the App Read only when offline.

- Add a client side cache.
- Will need cache for data and blobs.
- Change client calls to hit cache and do pass through calls to Server.
- Change relay logic on Server


### Stage 3

Make the App Read / Write when offline

- Add a client side DB or KV store.
- Add CRDT style logic
- All Modules must be changed to support CRDT Ops style. Lots of work.


### Ideal Deployment topology

If we can make the Golang main server a single binary then Orgs can deploy the app as a Service to their laptops, and do nothing else.

Gateway (ours)
- All traffic flows through this.
- We hold all the users public keys.
- We do all the real auth, but cant see any of the data because its all encrypted against their own Client private keys.
- We can do the auth though because we are running the TLS Certs and so can see the URLS they are hitting.
- We run a TCP Tunnel for Each Orgs laptop ( or Server )
- Because the Gateway and Tunnel are stateless then its very easy to run this as Services on any cloud.
- SO a user that is a member of many Orgs
	- they connect to our gateway
	- We hold a tunnel connection to all their Orgs backend
		- As messages come through we intermix them corectly.
- This Archi makes using NATS between Us and the Org Servers really compelling because everything is Async, and so the connectivity issues between Us and the Org servers are much more stable.

Tunnel (on ours and theirs)
- Candidate:
	- https://github.com/jpillora/chisel
		- https://github.com/sumitkolhe/kintocli
			- Has AUTH
		- https://github.com/ryotarai/mallet/
		
Daemonisation ( on theirs)
- Will be needed for Orgs to run the binaries reliably.
- Candidates
	- https://github.com/takama/daemon
		- Has proper suppot for MAC and Windows


Backend ( on theirs)
- Run by Orgs
- Needs to run as a single binary
- GRPC with embedded
	- NATS
	- DB ( one that does CDC)
	- All data if encrypted against the users own private key.

## Biz roadmap 

1. No Web App

- Just Client Web. See Below.

- App is for Native (Desktop and Mobile)

2. Web App

- The Native App works on the Web also.


## Tech Roadmap

### CI / CD

Get CI and CD working on our own hardware. See the CI folder...

Make it much easier to do the signing and also gets us off Github if we want also.

Will take a few weeks to get this setup.

### Client Web

- Web is just a static AMP HUGO site.
- News and Directory Services ( Orgs and their projects ).
- When a user sees a Project they like the like will open the App to the enrollment section.
	- This is exactly how Telegram works.
	- Force SignIn / SignUP in First before enrollment is MUCH less work.
		- After then redirect back to Enrollment for the Project they picked.

OR

- Make it a Flutter App and reuse the Layer one stuff we have now
	- Easy to have a video.
	- Can do enrollment, and at the put into a Protobuf file, and conconvert to JSON and then base64, and add to the URL to open the app
	- When app apps
		- It opens at the Project Page ( due to deep link), extracts the base64 data
		- Checks if user is signed up, and takes them through signup if needed.
		- Then saves the enrollment of that user to the Projects
		- Then saves the base64 to the Backend.

- Tech 
	- Will not need envoy because we dont need auth or GRPC, sicne we are using base64 URL encoding.
	- SO just plain golang Server.


### Client App


Lots of work here to clean up things.

- Signin, Signup, Accounts
- Telegram like Folders side view mapping to Projects.
- Kanban, and setting a global context on a KanBan Issue, doing mutations in Modules and then flagging the Kanban Issue Context as off.
	- How best to do this in terms of UX.
- Lots of other unknowns....

### Client to have a DB or NOT

If we DONT have a DB:

UX
- Cant do anything unless connected.
- If people get busted there is no data on the client.

Tech
- Still Need all the same Server stuff.
- Client is now much simpler because there is not DB.
- Can use only GPRC for Client and Server

If we do have a DB:

UX
- Can View data offline
- Cant do updates until we get CRDT working or other complex stuff which takes time.


Tech
- Really need to decide if we use a golang embed approach or not.
- For Offline edits, Would  want the Golang embed to do this level of complexity.
	- But maybe can do it at Flutter Layer.... No libs out there right now.
- Requires properties
	- Must support full encryption.
	- Must emit events to Fluter Views on changes
	- Must have pagination
	- Must have query pass through to also query Server, because client cant hold ALL the data.
- Flutter Candidates
	- https://github.com/simolus3/moor
		- Full SQL
		- Fires change events to Flutter Views
		- BUT needs query pass through to also query Server, because client cant hold ALL the data.
		- https://github.com/vitusortner/floor
			- wraps moor with better code gen.
- Golang Candidates
	- https://github.com/genjidb/genji
		- Not tested at all yet, and very new.
	- BoltDB
		- Works but very raw.

- Also need to cache blobs too then ( images, pgs, maybe videos)
	- Exact same requirements as for DB basically.



### Client to have Golang Embed Or NOT

If we DONT use a golang embed
- 100% Flutter
- Have to have a Flutter dev all the time for almost anything and they need to be highly competent.
- If we dont have a DB, then its less work for the flutter side though.


If we DO have a golang embed
- Alot of setup work to get it working
	- Web will be really hard later. Android and Desktop not too hard.
- Its golang on both Server and Client, and so we can code it much easier.
- Flutter Devs ONLY have to do GUI and nothin they cant handle.
- Networking is all golang.
	- Can use NATS directly or wrap with GRPC. Ether way we must use Protobufs.
	- Can add exotic networking later for gateway to help hide the Server also.
- DB
	- Golang
		- Is all golang ( can use badger or genji)
			https://github.com/genjidb/genji
		- DB change event of Materialised Views fires change event, so they can update their Flutter Views.
			- Genji does NOT have this, and might be hard to add.
	- Flutter
		- Could use Moor Flutter DB also. https://github.com/simolus3/moor
		- Means that networking layer would pass everything to Flutter layer, and flutter guys woudl do all logic, which i really DONT want.


Later to get this working on Web, will require compiling with WASM using the standard golang compile OR the New TinyGO compiler.
- There are working examples of this already with FLutter and Golang working together. It does work.
- Db is the hardest part. 

LOE
- Get GoMobile stack compiling
	- May require experimentation but is API to Flutter is Protobufs also will be OK i expect.
- Signing and CD, etc etc will take time to get going.

### Server in general

ONLY pure binaries with Consul running globally for discovery.
Secrets in Consul.
No docker, k8, etc. KISS. Scale by just booting another server

### Server - Web

Hugo Server
- Needs autoCert TLS that maps to storage somewhere.

Or 

Flutter Web served from a golang sever.

### Server - Gateway

Gateway Server allows SignUp / SignIn, etc See Security doc.

This is essentially stateless and calls into the DB Servers below.

API Choices
- GRPC
	- Can gen all for Client IF we dont use embeddeding
		- If we use embedded then some custom stuff has to be done which is risky and takes time.
	- Needs Envoy if you want to have a Web App.



### Server - DB


Clients need a real DB to hold stuff and not just a Relay Server.

When a client moves to a new device, we need to start from nothing and so get all their Subscriptions and then query the DB Server for data for each "Room"
Once they have caught UP, then they can just stay up to date via the Relay Server.

We also need a standard DB for lots of other RPC stuff.

Logic choices:

Because the Server needs to Store data encrypted the data actually comes from the Relay Server subscription.
All we do is have a Server process subscribe to all Rooms and save all mutations into the Table.
- CUD ( Create, Update, Delete) is the Message types.
- Create is just added to the table, Update, modifyies an existing row in the table, Delete deletes an existing row in the table.

The opposite is also possible, where we do CDC off the Database.
- All mutations hit the DB, and then the CUD events are emitted and then sent into the Relay Server.
- This is MUCH more robust in my opinion. Its also a classic pattern.
- It also allows us to do pass through queries more easilly from the Client.
- For TIDB we need to make a CDC adapter for NATS. Its basically the same as this: https://github.com/pingcap/ticdc/blob/master/kafka_consumer/main.go


- SQL Server
	- TIDB

### Server - Blobs

This is needed to hold the Images, Video and any other files.

Traditionally this would be a HTTP API or GRPC API. 
There is also an option for using NATS, where the files are chunked as 512 kb. 
- All this depends on what other Architectural choices are made though.


Candidates

- SeaweedFS
- Minio

### Server - Relay

Relay Server holds the updates to be pushed out to the Clients.

We also Need presense and Notifications Server with this !!! 

Candidates

Its hard to know for sure until we try.

- Make our own
	- Wrap NATS with GRPC. THis is what we have so far with envoy fronting it on k8.

- NATS
	- Mature
	- Has Websockets API now, and so can built a Native Client in Flutter or Golang that uses it. 
		- LOW is quite high though.
	- Has NO Flutter Clients.
	- HAs Golang client, so we can try embeding it for native.

- LiftBridge 
	- Not mature.
	- HAS GRPC API.
		- So can also make strongly typed Client API perhaps, and get lots of goodies.
	 - Golang client: https://github.com/liftbridge-io/go-liftbridge/
	 	- Can try to cross compile for Embedding
	- Flutter Client
		- Does not exist so we have to build our own. Because its GRPC, its not that hard.
- Many others but cant list everything here...

