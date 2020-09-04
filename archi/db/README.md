# DB 

We need to get this right as its the biggest risk point.

Properties we need:

- All golang. SO we can cross compile easily
- Can be embedded, so that Orgs can easily run the system with the GRPC on top as a Service.
- SQL and KV queries.
- Can store images and have buckets.
- Auth and AuthZ can be managed higher app at the Application level.
- Has change events for Data and file buckets
	- Need this to be able update clients with change over Message queue.
- Replication: Need this so we can do replication of Server data, so that we can run in 3 different Data centers
	- This removes a whole clash of errors.
	- Dont need backup and restore, but simply snapshot to S3, so that before any upgrade we can snapshot.
- Client Replication:
	- Would be even better if can do style CRDT replication. ( e.g Fossil: https://fossil-scm.org/home/doc/trunk/www/concepts.wiki#workflow )
	- Or just put in a higher level layer like Yorkie, basd onthe Change events


## HA Story

This design avoids needing any Load Balancer, which is a SPOF and costly also.

The main binary can run as different Service Types. Easy to do via start up flag.
- This allows us to essentially shard the system and so scale at that granularity. We know its easy to shard our domain because it is very simple domain model.
- So we only have ONE binary for the whole system, but when they start up they act as a Service type.

So every server instance in the system has a Global public DNS entry.
- When they boot they register automatically on Cloudflare 
	- Easy with this: https://github.com/textileio/textile/blob/master/dns/dns.go
	- We use Cloudflare because Google Domains does NOT allow on the fly Domain name alterations from a API.

So and Example is:
- https://001.users.alpha.exampledomain.com
- <serviceid>.<servicetype>.<versionchannel>.examplecoman.com

"versionchannel" can be
- alpha
- beta
- stable


The 2 followers can run on a Different DC, and so give us HA that is resident to global network disruption, which happens a few times a year.
- So we can run in shitty DC's that are not multi honed.
- Its going to be a little slower but its fine.

We then run a Global Endpoint discovery system on Google ( global bucket with their LB in front, and a simple go binary ) that simply records which is the Master endpoint for each Service.
- This must be linked to the RAFT system so that it is told when a new Master is elected.
- This binary Runon on Google is the exact same binary we deplyo everywhere, but running as a Disco and using only a bucket.
- called: https://disco.exampledomain.com
	- We can hold the endpoints for alpha, beta and stable on it.

The Clients then need to know the Endpoint for a Service and when it changes. They look to the Google Endpoint system.
- All we do is use the PUB SUB system to send them an update when the last one changes.
- When they starup they always ask it.
- Mutations go to Master and Queries go to Followers
	- lowers load on Master drastically.
- Clients hold data and blob caches also which lowers load.
- We can use a Protobuf to hold all that info



## CI / CD Story

The CI folder has the CI code already. See Webhook folder.
- It can run on a Mac at anyone'ss house and sign all the code and so not leak any Secrets to the world.

The binaries are designed to look at a Server for updates. They poll once a minute.
Now thats fine, but it will mean outages and non deterministic updates.

So, we augment it with a basic controller, that is a bit like NATS.

The Google global disco system is the perfect thing to us, because its the only thing presumed to be always up.
It can do:
1. Staggered updates for a service.
2. Shifting a version channel to a new version, such as upgrading alpha from v1.1.4 to v1.2.0

A CLI or Web Admin can be easily added to this.

Staggered updates logic ( very fuzzy still !!!):
- Check how many of a instances of service there are. Typically 3
- Broadcast a "HOLD and wait" to connected clients. So they hold while we upgrade for 1 second.
- Tell each Server to update
- Broadcast a "Service updated to all clients.





## LIBS
Awesome GO Storage !!

https://githublists.com/lists/gostor/awesome-go-storage


github.com/asdine/genji
- users: 
	- https://github.com/Megalithic-LLC/emaild
	- NO Others, and so genjo is still way too risky !!
- SQL and KV
- NO replication,but maybe can use dragonboat https://github.com/lni/dragonboat as i suggest here: https://github.com/genjidb/genji/issues/155
- HUGE problem is that NO one is using it yet, so risky....



https://github.com/mattn/go-sqlite3
- NOT pure golang, but rock solid.
- Will get some problems with cross compile since its not sure go.


https://github.com/canonical/go-dqlite/blob/master/cmd/dqlite-demo/dqlite-demo.go
- DQLite is Sqlite with WAL raft based replication.
- Users:
	- https://github.com/lxc/lxd/blob/master/lxd/main.go#L8
		- https://github.com/lxc/lxd/tree/master/lxd/cluster
	- https://github.com/paulstuart/dqlited
		- Nice wrapper that wraps alot of the boilerplate for us.
		- also has SQLite helpers: https://github.com/paulstuart/sqlite, But i think we will use Moors in Flutter
	- https://github.com/rancher/kine
		- WELL supported
		- Supported dqlite and go-sqlite with one API :)
		- Has GRPC API, with watch, BUT all calls are ONLY KV based - Cant do SQL calls.
		- Backup tool: https://github.com/ktsakalozos/go-migrator/blob/master/main.go

		

https://github.com/rqlite/rqlite
- similar to dqlite....
- NO Chnage Feed possible... I checked 

https://github.com/synw/sqlcool#changefeed


https://github.com/prologic/bitcask
- embedded
- Used in Production and i knwo the dev very well.

https://github.com/prologic/bitraft
- server with redis API.



Badger
- Solid
- Well used.
- Pure golang. No GCC needed or CGO.
- Has backup and snapshot
- Has raft ( so can be embedded or for a server)
- Change Feed ? https://godoc.org/github.com/dgraph-io/badger#DB.Subscribe
	- YES, can do it by key or ALL changes.
	- Example: https://github.com/dgraph-io/badger/blob/6d3f4b1767dbda3a1863145fed004283cbec70d9/badger/cmd/bank.go#L578
- Images. Yes but will make DB HUGE
	- SO write a simple thing to store a Folder/ File structure in Badger and put the file on disk
	- Put in the local Server file system, and then have a different worker replicate them to the many servers.
		- this way it works for embedded, and can easily then work for many servers situation.
- SQL
	- Nope. Maybe use genji on top ?

AuthZ rules
https://github.com/attestantio/dirk/tree/master/rules
- This looks pretty clean and uses badger.



## Replication

- If the single server falls over then we are screwed.
	- We need replication.
- Sharding
	- Will we blow the size limit on a server ?
	- Yes maybe in time we will. This is much more so if we store Files in badger DB
	- BUT Sharding Badger DB means that we need to maintain a Mapping DB
		- For each Type / Namespace we record the Server instance it exists in.
		- Then GRPC Server calls into another GRPC Server to get the data for that namespace.
		- Hell you could do this from the client !!
			- Client has a GRPC endpoint for each Namespace.
			- Its basically then a quasi microService setup.
			- But Because the client is flutter this could work really well.
			- ON boot of Servers, just need a Consul like discovery to say Server = GRPC namespace Y.


The bad boy that does this....
github.com/lni/dragonboat
- raft based replication thats fast.
- dev is really responsive too...
- users: https://github.com/search?q=lni%2Fdragonboat%2Fv3&type=Code
	- WOW alot of users. This is NOT beta ware...


https://github.com/mkawserm/flamed/blob/master/go.mod
- Has Badger, bleve and dragonboat & protobuf all in one !!!
- Basically exactly what we want.

pebble
- Cockroaches Next pure golang KV store
- Dragonboat uses it for Raft Store itself.
- Can we use this with Badger is the big question ????
- Will be important to ave robust CLI to manage this.
- Users
	- https://github.com/256dpi/turing
		- not used by anything else.


## SQL-Lite and MySQL

https://gorm.io/docs/v2_release_note.html
- New improved and clean

https://github.com/flike/kingbus
- supports Canal: https://github.com/alibaba/canal


TIdb
- MySQL compatible.
- Install and OPS: https://github.com/pingcap/tiup
- ChangeFeed: https://github.com/pingcap/ticdc
	- Need to tap it here: https://github.com/pingcap/ticdc/tree/master/kafka_consumer
	- Write our own consumer and then put onto NATS.
	






## SQL with Badger

- We onyl really currently have the Dashboard that needs it
- Must check if the Protobuf describing that can be used with badger to do full queries with pagination.


## File storage

- Use GRPC chunking for image upload and download
	- Give us a nice API.
- We can store the images inside Badger. It definitly works.
	- Will maybe slow down the DB, and will definityl make it bigger
	- But its VERY nice to unify the data and file storage into one single place 
	because there are way less moving pats and way less code to write and support.
- WIth the chunking, we can store the data in badger as chunks also
	- just need to record the mapping of the chunnks to the File so we can reconstruct
	- The BIG advantage is then when we need to sedn the file back to the Client, the file is ALREADY CHUNKED !!!
		- SO will be faster and much less complex.


https://github.com/codenoid/file.io/blob/master/fileio.go#L78
- He is putting the File into Badger as bytes array. 

https://github.com/danskeren/imgasm.com
- Uses Badger to hold a thumb, but uploads to backblaze for ever.
- Backblaze is cheap and forver, and returns a MD5 ID to get it again later.
- Works well and this is a smat way to solve store issues, because Files are the thing that kills you hosting your own stuff.

## Protocol buffs to Badger mapping

- If this works it will also  lower the amount of code quite a bit.
- Can use the Protobuf schema evolution, and update the data in the DB every time the Protobufs change.
	- What about migrations where the Protobufs have changed their actual structure ?
		- then we need the old and the new protobufs so we can pull the data out with the old and put it back in with the new, using a migration script coded in golang.
		- If this works its actually very robust. No SQL scripts etc floating around.
	


## Time Series data

- Will need is. 
- Check is Badger libs for Time Series exist.


## Message Queue

- Nats has limitations that i think will screw us. Dont have time to go into it here.
- I think we can use the Subscribe command of Badger, to make our own and have complete control

- users:
	- https://github.com/256dpi/quasar/blob/master/example/main.go
		- message pubsub build on it. Runs very high perf.
	- https://github.com/maarek/aves
		- event store with pub sub exposed over redis protocol.

## Search

Bleve based so we can do facets later.

Use the Subscription Badger API, to kick off reindexing. Simple and works.

- users
	- https://github.com/clintjedwards/basecoat/blob/master/search/search.go
		- Uses BoltDB
		- wow this is clean and impressive.
		- does CertMagic: https://github.com/clintjedwards/basecoat/blob/master/app/app.go#L67
		- does GRPC well with improbable.
		- uses old boltdb
	- https://github.com/rnkoaa/petclinic/tree/master/search
		- nice and simle. Not bad.
	- https://github.com/mkawserm/dodod/blob/master/database.go
		- uses Badger with scorch :)
			- this allows badger to be used: https://github.com/mkawserm/bdodb
			- this allows the search data to be encrypted: github.com/mkawserm/pasap
				- So each "room" can be encrypted against a key.
				- We can use this to protect all badger data in the Relay but also for he Gateway
					- at Gateway becaue its global, we have a master key.
		- uses reflection of OpenAPI to create Blevel Mapping.
			- https://github.com/mkawserm/dodod/blob/master/reflection.go
			- Can we do the same with Protobufs ? Yes but try to find a lib for it.


## S3 Storage

At some time your going to need to store stuff globally

- maybe its manifests to boot your environment.

Or maybe you want the option to store locally OR in a Cloud just in case.

https://github.com/dfuse-io/dstore
- S3 store that abstracts all of the s§ options including Minio or Local file.
- So can boot from local or remote file.
- Can also use it as a poor mans consul in a way but without notifications.
