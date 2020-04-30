

# https://github.com/Megalithic-LLC/email-api


LIB_NAME=email-api
LIB=github.com/Megalithic-LLC/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print:
	@echo
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_FSPATH: $(LIB_FSPATH)

	@echo
	@echo LIB_BIN_NAME: $(LIB_BIN_NAME)
	@echo LIB_BIN_FSPATH: $(LIB_BIN_FSPATH)
	@echo

git-clone:
	# need flutter desktop :)
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
git-pull:
	cd $(LIB_FSPATH) && git pull
git-clean:
	rm -rf $(LIB_FSPATH)

code:
	code $(LIB_FSPATH)

os-dep: ## os-dep

BIN_SERVER=$(LIB_BIN_FSPATH)-server

build-print:
	@echo
	@echo BIN_SERVER: $(BIN_SERVER)
	


build: ## build
	# into the GO BIN

	#cd $(LIB_FSPATH) && go mod init

	# get deps
	cd $(LIB_FSPATH) && $(MAKE) compile

	# gen statics
	cd $(LIB_FSPATH) && $(MAKE) generate

	cd $(LIB_FSPATH)/cmd/on-prem-email-api && go build -o $(BIN_SERVER)
	which $(BIN_SERVER)

run:
	
	$(BIN_SERVER)

dep:
	brew install redis

	# vscode ext for SQL: https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools
	# code: https://github.com/mtxr/vscode-sqltools
	# docs: https://vscode-sqltools.mteixeira.dev/

### MYSQL

### REDIS

redis-cli:
	# help @server
	#redis-cli shutdown
redis:	
	redis-server

