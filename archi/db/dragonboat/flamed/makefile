# https://github.com/mkawserm/flamed

# https://github.com/mkawserm/flamed/blob/master/pkg/pb/flamed.proto
# - bleve mapping


# https://github.com/mkawserm/dodod is the bleve main
# https://github.com/mkawserm/bdodb is super smart as Bleve moved to using Moss.
# https://github.com/mkawserm/pasap is a fantastic way to encrypt the DB.

LIB_BIN=flamed/bin

print:
	@echo LIB_BIN : $(LIB_BIN)

dep:
	git clone https://github.com/mkawserm/flamed.git
dep-delete:
	rm -rf flamed

make-run:
	# works !!!
	cd flamed && make run-server

### Build 

proto-build:
	# makes WASM thing.
	cd flamed && make protobuf

go-build:
	# works for AMD and ARM :)
	cd flamed && make build-all


### RUN
	

cli-config:
	cd flamed/bin && ./flamed config create --help

server-run: 
	--notify-commit true --node-id 1 --storage-path /tmp/data1 --http-server-address 0.0.0.0:8081 --raft-address 0.0.0.0:63001 --grpc-server-address 0.0.0.0:9091 --log-level debug


