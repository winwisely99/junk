# github.com/yvesjordan06/btp-flutter

LIB_NAME=dart_mercure
LIB=github.com/wallforfry/$(LIB_NAME)
LIB_BRANCH=feature-flutterweb
LIB_TAG=v0.37.0
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)

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

os-dep:
# TODO: Maybe best to move this to the general bootstrapper ?
ifeq ($(OS),Windows_NT)
	# install 
	scoop install docker
else 
	UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	# linux
	#apt install libglfw
endif
ifeq ($(UNAME_S),Darwin)
	# glfw
	# mac
	brew install glfw
	# docker for cross compile
	# the client
	brew install docker
	# the dmg
	brew cask install docker
endif
endif

### FLU

flu-config: ## flu-config
	flutter channel beta
	flutter upgrade

flu-web-run: ## flu-web-run
	flutter config --enable-web
	cd $(SAMPLE_FSPATH) && flutter run -d chrome

flu-web-build: ## flu-web-build
	flutter config --enable-web
	cd $(SAMPLE_FSPATH) && flutter build web

flu-mob-run: ## flu-mob-run
	cd $(SAMPLE_FSPATH) && flutter run -d all

flu-desk-run: ## flu-desk-run
	
	cd $(SAMPLE_FSPATH) && hover init
	cd $(SAMPLE_FSPATH) && hover run






