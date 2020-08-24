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
	- Or just put in a higher level layr like Yorkie, basd onthe Change events

github.com/asdine/genji
- users: https://github.com/Megalithic-LLC/emaild
- SQL and KV
- NO replication,but maybe can use dragonboat https://github.com/lni/dragonboat as i suggest here: https://github.com/genjidb/genji/issues/155

github.com/lni/dragonboat
- users: https://github.com/search?q=lni%2Fdragonboat%2Fv3&type=Code


https://github.com/mattn/go-sqlite3
- NOT pure golang, but rock solid.



https://github.com/canonical/go-dqlite/blob/master/cmd/dqlite-demo/dqlite-demo.go
- DQLite is Sqlite with WAL raft based replication.
- Users:
	- https://github.com/lxc/lxd/blob/master/lxd/main.go#L8
		- https://github.com/lxc/lxd/tree/master/lxd/cluster
	- https://github.com/paulstuart/dqlited
		- Nice wrapper that wrpas alot of the boilerplate for us.
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






