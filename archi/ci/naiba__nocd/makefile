# https://github.com/naiba/nocd

CWD:=$(shell echo `pwd`)

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/naiba/nocd
LIB_TAG=0.3.0
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data

LIB_BIN=$(LIB_BIN_FSPATH)/nocd-$(GO_OS)-$(GO_ARCH)

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

### NGROK

ngrok-run:
	ngrok http 8000
	# Gte the URL its uses and adjust in Github and the app.ini config.

### Github

github-open:
	# https://8ccddf2f1a59.ngrok.io/oauth2/callback
	open https://github.com/getcouragenow/junk/settings/hooks/

### BUILD
build:
	# builds for my OS
	mkdir -p $(LIB_BIN_FSPATH)
	cd $(LIB_FSPATH)/cmd/web && go build -o $(LIB_BIN)	
build-delete:
	rm -rf $(LIB_BIN_FSPATH)
build-embed:
	# https://github.com/gin-gonic/examples/tree/master/assets-in-binary
	# dep it to global go bin.
	go get github.com/jessevdk/go-assets-builder
	go-assets-builder -h

build-run:
	# copy local config in
	mkdir -p $(LIB_FSPATH)/cmd/web/conf
	cp $(PWD)/app.ini $(LIB_FSPATH)/cmd/web/conf/app.ini

	cd $(LIB_FSPATH)/cmd/web && go run .


## RUN

run:
	$(LIB_BIN)
run-test1:
	cd test1 && ./webhook