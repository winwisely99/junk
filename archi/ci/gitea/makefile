# https://github.com/go-gitea/gitea

CWD:=$(shell echo `pwd`)

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/go-gitea/gitea
LIB_TAG=v1.12.3
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data

LIB_BIN=$(LIB_BIN_FSPATH)/gitea-$(GO_OS)-$(GO_ARCH)/gitea

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
	# builds for my OS
	mkdir -p $(LIB_BIN_FSPATH)/webhook-$(GO_OS)-$(GO_ARCH)
	cd $(LIB_FSPATH) && $(MAKE) deps && go build -o $(LIB_BIN)

build-all:
	# builds for all OS's
	cd $(LIB_FSPATH) && $(MAKE) all

	mkdir -p $(LIB_BIN_FSPATH)
	cp -R $(LIB_FSPATH)/build/* $(LIB_BIN_FSPATH)
	
build-delete:
	rm -rf $(LIB_BIN_FSPATH)

## RUN

run:
	$(LIB_BIN)
run-test1:
	cd test1 && ./webhook