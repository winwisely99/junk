# https://github.com/caddyserver/xcaddy

# NOTE: Must build from master and build with master. Go 1.5 thing.

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/caddyserver/xcaddy
LIB_TAG=v0.1.5
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data

LIB_XBIN=$(LIB_BIN_FSPATH)/xcaddy-$(GO_OS)-$(GO_ARCH)
LIB_BIN=$(LIB_BIN_FSPATH)/caddy-$(GO_OS)-$(GO_ARCH)

#CADDY_CORE_VERSION=v2.1.1
CADDY_CORE_VERSION=master
PLUGIN_ROUTE53_VERSION=v1.0.2

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
	@echo CADDY_CORE_VERSION : $(CADDY_CORE_VERSION)
	@echo PLUGIN_ROUTE53_VERSION : $(PLUGIN_ROUTE53_VERSION)
	
	@echo 
	

dep:
	git clone https://$(LIB).git $(LIB_FSPATH)
dep-tag: dep
	cd $(LIB_FSPATH) && git fetch --all --tags --prune && git checkout tags/$(LIB_TAG)
dep-delete:
	rm -rf $(LIB_FSPATH)
vscode-add:
	code --add $(LIB_FSPATH) --reuse-window


### Build XCADDY
build:
	mkdir -p $(LIB_BIN_FSPATH)
	cd $(LIB_FSPATH)/cmd/xcaddy && go build -o $(LIB_XBIN) .
	
build-delete:
	rm -rf $(LIB_BIN_FSPATH)

## Build CADDY

xcaddy-build:
	# force master
	$(LIB_XBIN) build master \
		--with "github.com/caddy-dns/route53@${PLUGIN_ROUTE53_VERSION}" \
		--output $(LIB_BIN)

xcaddy-build-tag:
	# Build Caddy server from source
	#xcaddy build

	# Build Caddy with a specific module
	#xcaddy build --with <module_name>

	# Build and run Caddy for a development plugin in the current directory
	#xcaddy run

	# Build and run Caddy for a development plugin using a specific Caddy config
	#xcaddy run --config <path_to_file>

	$(LIB_XBIN) build $(CADDY_CORE_VERSION) \
		--with "github.com/caddy-dns/route53@${PLUGIN_ROUTE53_VERSION}" \
		--output $(LIB_BIN)

xcaddy-print:
	$(LIB_XBIN) --version
	$(LIB_XBIN) list-modules

caddy-run:
	$(LIB_BIN) run
