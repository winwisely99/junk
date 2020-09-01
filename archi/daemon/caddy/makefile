# https://github.com/caddyserver/caddy


GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/caddyserver/caddy
LIB_TAG=v2.1.1
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data
LIB_BIN=$(LIB_BIN_FSPATH)/caddy-$(GO_OS)-$(GO_ARCH)

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
dep-tag: dep
	cd $(LIB_FSPATH) && git fetch --all --tags --prune && git checkout tags/$(LIB_TAG)
dep-delete:
	rm -rf $(LIB_FSPATH)
vscode-add:
	code --add $(LIB_FSPATH) --reuse-window


### Build 
build-cross:
	# will need this.

build:
	mkdir -p $(LIB_BIN_FSPATH)

	cd $(LIB_FSPATH)/cmd/caddy && go build -o $(LIB_BIN) -trimpath -ldflags="-w -s" -v .
	
	#cp -R $(LIB_FSPATH)/cmd/caddy/ $(LIB_BIN_FSPATH)

	# rename to GOOS and ARCH
go-build-delete:
	rm -rf $(LIB_BIN_FSPATH)
run-build:
	$(LIB_BIN) build <version>
run:
	$(LIB_BIN) --version
	$(LIB_BIN) list-modules
	$(LIB_BIN) run
