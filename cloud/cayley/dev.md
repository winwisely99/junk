# cayley

https://github.com/cayleygraph/cayley
- uses github.com/hidal-go/hidalgo
	- https://github.com/cayleygraph/cayley/blob/master/go.mod#L28
	- gives KV, Hierarchial KV or tuple SQL stores
	- agnostic ( google data store, badger, couch db other....)
		- couchDB: github.com/go-kivik/couchdb
			- https://github.com/hidal-go/hidalgo/blob/master/go.mod#L22
		- badger: github.com/dgraph-io/badger
			- https://github.com/hidal-go/hidalgo/blob/master/go.mod#L14
		- levelDB : github.com/syndtr/goleveldb
			- https://github.com/hidal-go/hidalgo/blob/master/go.mod#L50
- primary query language is graphql
	- https://github.com/cayleygraph/cayley/tree/master/query/graphql
	

https://github.com/direct-connect/go-dcpp
- gives P2P and C2S archi
- gives scripting
- uses https://github.com/hidal-go/hidalgo
	- https://github.com/direct-connect/go-dcpp/blob/master/go.mod#L10

	