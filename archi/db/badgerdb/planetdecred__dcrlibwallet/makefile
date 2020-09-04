# https://github.com/planetdecred/dcrlibwallet


GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB_NAME=dcrlibwallet
LIB=github.com/planetdecred/$(LIB_NAME)
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

	cd $(LIB_FSPATH) && go mod download && go mod vendor
	#export GO111MODULE=off

	# android
	#cd $(LIB_FSPATH) && gomobile bind -target=android
	# ios
	cd $(LIB_FSPATH) && gomobile bind -target=ios
	cp -R $(LIB_FSPATH)/Dcrlibwallet.framework $(LIB_BIN_FSPATH)
	
build-delete:
	rm -rf $(LIB_BIN_FSPATH)


### RUN

run:
	# config start
	$(LIB_BIN) config create --file-path $(LIB_DATA_FSPATH)/configx.?


