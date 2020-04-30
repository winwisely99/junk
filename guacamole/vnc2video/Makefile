

# https://github.com/amitbet/vnc2video


LIB_NAME=vnc2video
LIB=github.com/amitbet/$(LIB_NAME)
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
	# none. its all in golang

os-docker-up: ## os-docker
	# a guacd server and a sample headless linux with a VNC server
	cd $(LIB_FSPATH) && docker-compose up -d

os-docker-down: ## os-docker
	# a guacd server and a sample headless linux with a VNC server
	cd $(LIB_FSPATH) && docker-compose down -d


LIB_BIN_CLIENT_NAME=$(LIB_BIN_NAME)-client
LIB_BIN_CLIENT_FSPATH=$(LIB_BIN_FSPATH)/$(LIB_BIN_CLIENT_NAME)

LIB_BIN_PROXY_NAME=$(LIB_BIN_NAME)-proxy
LIB_BIN_PROXY_FSPATH=$(LIB_BIN_FSPATH)/$(LIB_BIN_PROXY_NAME)

LIB_BIN_SERVER_NAME=$(LIB_BIN_NAME)-server
LIB_BIN_SERVER_FSPATH=$(LIB_BIN_FSPATH)/$(LIB_BIN_SERVER_NAME)
build: ## build
	# into the GO BIN

	# client
	cd $(LIB_FSPATH)/example/client && go build -o $(LIB_BIN_CLIENT_FSPATH)
	which $(LIB_BIN_CLIENT_FSPATH)

	# proxy
	cd $(LIB_FSPATH)/example/proxy && go build -o $(LIB_BIN_PROXY_FSPATH)
	which $(LIB_BIN_PROXY_FSPATH)

	# server
	cd $(LIB_FSPATH)/example/server && go build -o $(LIB_BIN_SERVER_FSPATH)
	which $(LIB_BIN_SERVER_FSPATH)


CONF_VNC_IP=127.0.0.1
CONF_VNC_PORT=5901
run-client:
	$(LIB_BIN_CLIENT_FSPATH) $(CONF_VNC_IP):$(CONF_VNC_PORT)

run-proxy:
	# listens on 6900
	# httplog on 6060
	$(LIB_BIN_PROXY_FSPATH)

run-server:
	# listens on 5900
	$(LIB_BIN_SERVER_FSPATH)



