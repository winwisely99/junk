# https://github.com/kinvolk/lokomotive

## LIB
LIB_NAME=lokomotive
LIB=github.com/kinvolk/$(LIB_NAME)
LIB_BRANCH=master
LIB_TAG=v0.1.0
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=lokoctl
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)

## GOOS
GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)

GIT_VERSION	:= $(shell git describe --tags)

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## print
	@echo
	@echo $(OS)
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_BRANCH: $(LIB_TAG)
	@echo LIB_FSPATH: $(LIB_FSPATH)

	@echo
	@echo LIB_BIN_NAME: $(LIB_BIN_NAME)
	@echo LIB_BIN_FSPATH: $(LIB_BIN_FSPATH)
	@echo

	@echo
	@echo GO_OS: $(GO_OS)
	@echo GO_ARCH: $(GO_ARCH)
	@echo

git-clone:
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
git-clone-master: git-clone ## git-clone-master
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
git-clone-tag: git-clone ## git-clone-tag
	cd $(LIB_FSPATH) && git checkout tags/$(LIB_TAG)
	cd $(LIB_FSPATH) && git status
git-pull:
	cd $(LIB_FSPATH) && git pull
git-clean:
	rm -rf $(LIB_FSPATH)

code:
	code $(LIB_FSPATH)

os-dep: ## os-dep



ifeq ($(GO_OS), windows)
	# install 
	scoop install docker
else 
	@echo procedding with install
ifeq ($(GO_OS), linux)
	# linux
	@echo Detected Linux
	
endif
ifeq ($(GO_OS), darwin)
	@echo Detected Darwin
	# docker for cross compile
	# the client
	brew install docker
	# the dmg
	brew cask install docker
endif
endif

build: ## build
	# builds into GO BIN
	# found from their make file
	cd $(LIB_FSPATH) && make update-assets


ifeq ($(GO_OS), windows)
	@echo Windows is not supported.
else 
	@echo procedding with install
ifeq ($(GO_OS), linux)
	# linux
	@echo Detected Linux
	cd $(LIB_FSPATH) && CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build \
                -mod=vendor \
                -ldflags "-X github.com/kinvolk/lokomotive/pkg/version.Version=`git describe --tags --always` -extldflags '-static'" \
                -buildmode=exe \
                -o $(LIB_BIN_FSPATH) \
                github.com/kinvolk/lokomotive/cmd/lokoctl
endif
ifeq ($(GO_OS), darwin)
	# darwin
	@echo Detected Darwin
	cd $(LIB_FSPATH) && CGO_ENABLED=0 GOOS=darwin GO111MODULE=on go build \
                -mod=vendor \
                -ldflags "-X github.com/kinvolk/lokomotive/pkg/version.Version=`git describe --tags --always` -extldflags '-static'" \
                -buildmode=exe \
                -o $(LIB_BIN_FSPATH) \
                github.com/kinvolk/lokomotive/cmd/lokoctl
endif
endif

build-clean: ## build-clean
	rm $(LIB_BIN_FSPATH)

## LOK (lok)

lok-apply: ## lok-apply
	$(LIB_BIN_NAME) cluster apply --lokocfg $(PWD)/baremetalcluster.lokocfg

lok-destroy: ## lok-destroy
	$(LIB_BIN_NAME) cluster destroy --lokocfg $(PWD)/baremetalcluster.lokocfg