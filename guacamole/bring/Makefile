

# https://github.com/deluan/bring


LIB_NAME=bring
LIB=github.com/deluan/$(LIB_NAME)
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

build: ## build
	# into the GO BIN

	cd $(LIB_FSPATH)/sample && go build -o $(LIB_BIN_FSPATH)
	which $(LIB_BIN_FSPATH)

CONF_VNC_IP=10.0.0.11
CONF_VNC_PORT=5901
run-vnc:
	# ensure docer is running a linux deskop
	$(LIB_BIN_FSPATH) vnc $(CONF_VNC_IP) $(CONF_VNC_PORT)

CONF_RDP_PORT=3389
run-rdp:
	# ensure docer is running a linux deskop
	$(LIB_BIN_FSPATH) vnc $(CONF_VNC_IP) $(CONF_VNC_PORT)
	$(LIB_BIN_FSPATH) rdp `ipconfig getifaddr en0` $(CONF_RDP_PORT)

doc:
	@echo "Doc server address: http://localhost:6060/pkg"
	cd $(LIB_FSPATH) && godoc -http=:6060
release:
	cd $(LIB_FSPATH) && $(MAKE) release



