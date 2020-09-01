# https://github.com/mkawserm/flamed

# https://github.com/mkawserm/flamed/blob/master/pkg/pb/flamed.proto
# - bleve mapping

# His old stuff that is part of flamed now:
# https://github.com/mkawserm/dodod is the bleve main
# https://github.com/mkawserm/bdodb is super smart as Bleve moved to using Moss.
# https://github.com/mkawserm/pasap is a fantastic way to encrypt the DB.

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/mkawserm/flamed
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data
LIB_BIN=$(LIB_BIN_FSPATH)/flamed-$(GO_OS)-$(GO_ARCH)

print:
	@echo
	@echo GO_OS : $(GO_OS)
	@echo GO_ARCH : $(GO_ARCH)
	@echo GIT_VERSION : $(GIT_VERSION)
	@echo
	@echo
	@echo LIB : $(LIB)
	@echo LIB_FSPATH : $(LIB_FSPATH)
	@echo LIB_BIN_FSPATH : $(LIB_BIN_FSPATH)
	@echo LIB_DATA_FSPATH : $(LIB_DATA_FSPATH)
	@echo LIB_BIN : $(LIB_BIN)

dep:
	git clone https://$(LIB).git $(LIB_FSPATH)
dep-delete:
	rm -rf $(LIB_FSPATH)
vscode-add:
	code --add $(LIB_FSPATH) --reuse-window


### Build 

proto-build:
	# not workng.
	cd $(LIB_FSPATH) && make protobuf

go-build:
	# works for AMD and ARM :)
	cd $(LIB_FSPATH) && make build-all
	mkdir -p $(LIB_BIN_FSPATH)
	cp -R $(LIB_FSPATH)/bin/ $(LIB_BIN_FSPATH)
go-build-delete:
	rm -rf $(LIB_BIN_FSPATH)


### RUN
	
cli-config:
	#$(LIB_BIN) config create --help

	# config start
	$(LIB_BIN) config create --file-path $(LIB_DATA_FSPATH)/configx.?
	

server-run: 
	$(LIB_BIN) run server --notify-commit true --node-id 1 --storage-path $(LIB_DATA_FSPATH)/data1 --http-server-address 0.0.0.0:8081 --raft-address 0.0.0.0:63001 --grpc-server-address 0.0.0.0:9091 --log-level debug


