# https://github.com/hetznercloud/cli 
CWD:=$(shell echo `pwd`)

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/hetznercloud/cli
LIB_TAG=v1.19.1
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data

LIB_BIN_NAME=hcloud
LIB_BIN=$(LIB_BIN_FSPATH)/$(LIB_BIN_NAME)

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
	# direnv
	# Use the URLS to find te latest download on github and just curl it down.
	#https://github.com/direnv/direnv
	# https://api.github.com/repos/direnv/direnv/releases/latest
	# https://api.github.com/repos/direnv/direnv/releases/assets/24662593
	# https://github.com/direnv/direnv/releases/download/v2.22.0/direnv.darwin-amd64
	curl -L https://github.com/direnv/direnv/releases/download/v2.22.0/direnv.darwin-amd64 --output $(LIB_BIN_FSPATH)/direnv
	chmod +x $(LIB_BIN_FSPATH)/direnv

	# copy to gobin
	cp  $(LIB_BIN_FSPATH)/direnv $(GOPATH)/bin/direnv
	which direnv

	# setup: https://github.com/direnv/direnv/blob/master/docs/hook.md#setup
	code ~/.zshrc

	# then configure: https://github.com/hetznercloud/cli#configure-hcloud-using-environment-variables
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
	cd $(LIB_FSPATH)/cmd/hcloud && go build -o $(LIB_BIN) .

	# also put global
	cp $(LIB_BIN) $(GOPATH)/bin/hcloud
	which hcloud
build-delete:
	rm -rf $(LIB_BIN_FSPATH)
	rm $(GOPATH)/bin/hcloud


export  dnstoken=43FRQFTkLNoVlP8CpjzXGGkGRtCoeOXd
export 	apitoken=8t0zsoidutysqkTVt4vCZuAY8r3dygSLX7o8IxGcEI6Pu4C2wXCFdLW28v2x9MZd

run:
	$(LIB_BIN_NAME) context create joe-project
	$(LIB_BIN_NAME) server-type list

