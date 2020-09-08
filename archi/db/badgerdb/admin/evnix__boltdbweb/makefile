LIB=github.com/evnix/boltdbweb
LIB_FSPATH=$(GOPATH)/src/$(LIB)

DATA_FSPATH=/Users/apple/workspace/go/src/github.com/joe-getcouragenow/junk/archi/db/badgerdb/genjidb__genji/mydb
dep:
	fit clone https://$(LIB) $(LIB_FSPATH)
dep-del:
	rm -rf $(LIB_FSPATH)
run:
	# boltdbweb --db-name=<DBfilename>[required] --port=<port>[optional] --static-path=<static-path>[optional]
	cd $(LIB_FSPATH) && go run . --db-name=$(DATA_FSPATH)