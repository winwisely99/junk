# db-cache

In top of the DB and in memory cache speeds up reads

https://github.com/dgraph-io/ristretto
- Looks like easily the best on the benchmarks
- ristretto is part of BadgerDB itself, so because we run embedded its almost pointless using ristretto, if we run BadgerDB anyway.

https://github.com/kevburnsjr/microcache
- production quality
- caches HTTP level

https://github.com/godaddy/asherah
- Server and DB in one
- Focus in one encryption of data AND Memory
- Server is 100% grpc : https://github.com/godaddy/asherah/tree/master/server
- Backend: https://github.com/godaddy/asherah/tree/master/go
- Example: https://github.com/godaddy/asherah/tree/master/samples/go/referenceapp
	- Can be in any other lang
- App Encryption: https://github.com/godaddy/asherah/tree/master/go/appencryption
	- https://github.com/godaddy/asherah/blob/master/go/appencryption/session.go
		- Entry point showing Memory cache encrypted
	- metastore is needed and can be local or SQL
