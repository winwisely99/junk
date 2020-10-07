# https://github.com/dgraph-io/badger


GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB_NAME=badger
LIB=github.com/dgraph-io/$(LIB_NAME)
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data
LIB_BIN=$(LIB_BIN_FSPATH)/$(LIB_NAME)-$(GO_OS)-$(GO_ARCH)

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

build:
	mkdir -p $(LIB_BIN_FSPATH)
	cd $(LIB_FSPATH)/badger && go build -o $(LIB_BIN) .
	chmod +x $(LIB_BIN)

build-delete:
	rm -rf $(LIB_BIN_FSPATH)


### RUN



bench-run:
	# config start
	$(LIB_BIN) benchmark read --dir $(LIB_DATA_FSPATH)/lsm --vlog-dir $(LIB_DATA_FSPATH)/vlog


