# https://git.sr.ht/~tsileo/blobstash/tree
# mirror: https://github.com/tsileo/blobstash

CWD:=$(shell echo `pwd`)

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/tsileo/blobstash
LIB_TAG=v1.19.1
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data

LIB_BIN_NAME_SERVER=blobstash
LIB_BIN_NAME_RESTORE=blobstash-s3-restore
LIB_BIN_NAME_UPLOAD=blobstash-uploader


export GO111MODULE=on

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
	@echo LIB_XBIN : $(LIB_XBIN)
	@echo LIB_BIN : $(LIB_BIN)

	@echo 
dep-os:
	# he uses go task to build
	# https://github.com/go-task/task

	#brew install go-task/tap/go-task

	OR

	# https://api.github.com/repos/go-task/task/releases/latest
	# https://github.com/go-task/task/releases/download/v3.0.0/task_darwin_amd64.tar.gz
	mkdir -p $(LIB_BIN_FSPATH)/tasktmp
	curl -L https://github.com/go-task/task/releases/download/v3.0.0/task_darwin_amd64.tar.gz --output $(LIB_BIN_FSPATH)/tasktmp/task.tar.gz
	cd $(LIB_BIN_FSPATH)/tasktmp && tar -xvf task.tar.gz
	cp $(LIB_BIN_FSPATH)/tasktmp/task $(LIB_BIN_FSPATH)/task
	rm -rf $(LIB_BIN_FSPATH)/tasktmp
	cp $(LIB_BIN_FSPATH)/task $(GOPATH)/bin/task
	which task


dep:
	git clone https://$(LIB).git $(LIB_FSPATH)
dep-tag: dep
	cd $(LIB_FSPATH) && git fetch --all --tags --prune && git checkout tags/$(LIB_TAG)
dep-delete:
	rm -rf $(LIB_FSPATH)
vscode-add:
	code --add $(LIB_FSPATH) --reuse-window


### BUILD

build:
	mkdir -p $(LIB_BIN_FSPATH)

	# server
	cd $(LIB_FSPATH) && go generate
	cd $(LIB_FSPATH) && go build -o $(LIB_BIN_FSPATH)/$(LIB_BIN_NAME_SERVER) .
	cp $(LIB_BIN_FSPATH)/$(LIB_BIN_NAME_SERVER) $(GOPATH)/bin/$(LIB_BIN_NAME_SERVER)
	which $(LIB_BIN_NAME_SERVER)

	# restore
	cd $(LIB_FSPATH)/cmd/blobstash-s3-restore && go build -o $(LIB_BIN_FSPATH)/$(LIB_BIN_NAME_RESTORE) .
	cp $(LIB_BIN_FSPATH)/$(LIB_BIN_NAME_RESTORE) $(GOPATH)/bin/$(LIB_BIN_NAME_RESTORE)
	which $(LIB_BIN_NAME_RESTORE)

	# upload
	cd $(LIB_FSPATH)/cmd/blobstash-uploader && go build -o $(LIB_BIN_FSPATH)/$(LIB_BIN_NAME_UPLOAD) .
	cp $(LIB_BIN_FSPATH)/$(LIB_BIN_NAME_UPLOAD) $(GOPATH)/bin/$(LIB_BIN_NAME_UPLOAD)
	which $(LIB_BIN_NAME_UPLOAD)

build-delete:
	rm -rf $(LIB_BIN_FSPATH)
	# restore
	rm $(GOPATH)/bin/$(LIB_BIN_NAME_RESTORE)
	rm $(GOPATH)/bin/$(LIB_BIN_NAME_UPLOAD)

run-genkey:
	cd $(LIB_FSPATH)/extras/genkey && go run .
	cp $(LIB_FSPATH)/extras/genkey/blobstash.key .
run-xbuild:
	cp $(LIB_FSPATH)/extras/cross_compile.sh $(LIB_FSPATH) cross_compile.sh
	cd $(LIB_FSPATH)/extras && chmod +x cross_compile.sh && ./cross_compile.sh


run:
	$(LIB_BIN_NAME_UPLOAD)

