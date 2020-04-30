# git clone https://cobalt-analytics.googlesource.com



.DEFAULT_GOAL:=help
SHELL:=/bin/bash


LIB_NAME=micro
LIB=github.com/micro/$(LIB_NAME)
LIB_BRANCH=master
LIB_TAG=v1.14.0
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)


help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## Print
	# info is standard. error and warming also work.
	$(info )
	$(info Variables - )


	$(info LIB_NAME: 		$(LIB_NAME))
	$(info LIB: 			$(LIB)) 
	$(info LIB_BRANCH: 		$(LIB_BRANCH))
	$(info LIB_FSPATH: 		$(LIB_FSPATH))
	$(info LIB_BIN_NAME: 	$(LIB_BIN_NAME))
	$(info LIB_BIN_FSPATH: 	$(LIB_BIN_FSPATH)) 

	$(info )
	$(info MAKE_IMPORT: 	$(MAKE_IMPORT)) 

	$(info )
	$(info SAMPLE_NAME: 	$(SAMPLE_NAME))
	$(info SAMPLE_FSPATH: 	$(SAMPLE_FSPATH)) 
	$(info )


##@ Git

hack:


	git clone  https://fuchsia.googlesource.com/cobalt

git-print: ## Git Print
	cd $(LIB_FSPATH) && git status
git-clone: ## Git Clone
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
	cd $(LIB_FSPATH) && git checkout tags/$(LIB_TAG)
	

	cd $(LIB_FSPATH) && git status
git-pull: ## Git pull
	cd $(LIB_FSPATH) && git pull
git-clean: ## Git clean
	rm -rf $(LIB_FSPATH)
git-code: ## Git clean
	code $(LIB_FSPATH)



##@ Run

run: ## Run
	$(LIB_BIN_FSPATH) -h

build: ## Build
	# easiest to just install to gobin
	cd $(LIB_FSPATH) && go build -o $(LIB_BIN_FSPATH) $(LIB_FSPATH)/main.go
	chmod +x $(LIB_BIN_FSPATH)
	$(MAKE) build-list
build-clean: ## Build clean
	rm -f $(LIB_BIN_FSPATH)
	$(MAKE) build-list
build-list: ## Build list
	stat $(LIB_BIN_FSPATH)

### micro

# Proxy all calls through the network
export MICRO_PROXY=go.micro.network
m:
	micro --version
m-run:
	# runs everything locally
	micro

m-list:
	# List nodes
	micro network nodes

	# List services
	micro network services

	# List routes
	micro network routes

	# Peer graph
	micro network graph







