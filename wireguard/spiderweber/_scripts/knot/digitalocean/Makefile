
# digital ocean make control file
# TODO: make the pertinent variables as import file as things get stable.

# Variables

# CLI
LIB_NAME=doctl
LIB=github.com/digitalocean/$(LIB_NAME)
LIB_BRANCH=master
LIB_TAG=v1.36.0
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)

LIB_CONFIG_DARWIN=${HOME}/Library/Application\ Support/doctl/config.yaml
LIB_CONFIG_LINUX=${XDG_CONFIG_HOME}/doctl/config.yaml
LIB_CONFIG_WINDOWS=%LOCALAPPDATA%/doctl/config/config.yaml

# OS
GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)

# Project 
DIGITALOCEAN_CONTEXT=winwisely99
DIGITALOCEAN_SSH_FSPATH=/Users/apple/.ssh/winwisely99_digitalocean

DIGITALOCEAN_KNOT_SRV_NAME=winwisely99-vpn-knot
DIGITALOCEAN_KNOT_DOMAIN=winwisely99.knot.vpn.getcouragenow.org

#DIGITALOCEAN_SPIDER_SRV_NAME=winwisely99-vpn-spider

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## print
	@echo
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo

	@echo
	@echo LIB_BIN_NAME: $(LIB_BIN_NAME)
	@echo LIB_BIN_FSPATH: $(LIB_BIN_FSPATH)
	@echo

	@echo
	@echo LIB_CONFIG_DARWIN: $(LIB_CONFIG_DARWIN)
	@echo LIB_CONFIG_LINUX: $(LIB_CONFIG_LINUX)
	@echo LIB_CONFIG_WINDOWS: $(LIB_CONFIG_WINDOWS)
	@echo

	@echo
	@echo GO_OS: $(GO_OS)
	@echo GO_OS: $(GO_ARCH)
	@echo

	@echo
	@echo DIGITALOCEAN_CONTEXT: $(DIGITALOCEAN_CONTEXT)
	@echo DIGITALOCEAN_SSH_FSPATH: $(DIGITALOCEAN_SSH_FSPATH)
	@echo DIGITALOCEAN_KNOT_SRV_NAME: $(DIGITALOCEAN_KNOT_SRV_NAME)
	@echo DIGITALOCEAN_KNOT_DOMAIN: $(DIGITALOCEAN_KNOT_DOMAIN)
	@echo




git-clone: ## git-clone
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	#cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
	cd $(LIB_FSPATH) && git checkout tags/$(LIB_TAG)
git-status:
	cd $(LIB_FSPATH) && git status
git-pull:
	cd $(LIB_FSPATH) && git pull
git-clean:
	rm -rf $(LIB_FSPATH)
code:
	code $(LIB_FSPATH)

lib-build: ## lib-build
	# TODO: adjust for Windows later..
	cd $(LIB_FSPATH) && go build -o $(LIB_BIN_FSPATH) $(LIB_FSPATH)/cmd/doctl
	# check in filesystem
	ls -al $(GOPATH)/bin/$(LIB_BIN_NAME)*
	# check on path
	which $(LIB_BIN_NAME)

	doctl version

config: ## config
	# Useful to see what state the CLI is using.
ifeq ($(GO_OS), linux)
	@echo Linux detected

	code $(LIB_CONFIG_LINUX)
endif

ifeq ($(GO_OS), darwin)
	@echo Mac detected

	code $(LIB_CONFIG_DARWIN)
endif

ifeq ($(GO_OS), windows)
	@echo Windows detected
	code $(LIB_CONFIG_WINDOWS)
endif
	



## CONTEXT
context-create: ## context-create
	# create a new context for your account and map a DIGITALOCEAN_ACCESS_TOKEN to it.
	# Get your DIGITALOCEAN_ACCESS_TOKEN from: https://cloud.digitalocean.com/account/api/tokens
	# switch to this context when you want to work under that account.
	doctl auth init --context $(DIGITALOCEAN_CONTEXT)
context-list: ## context-list
	doctl auth list
context-set: ## context-set
	doctl auth switch --context $(DIGITALOCEAN_CONTEXT) 

## ACCOUNT
account-get: ## account-get
	doctl account get

## COMPUTE
comp-list: ## comp-list
	# show the servers up
	doctl compute droplet list
comp-connect: ## comp-connect
	# connect to a server over ssh
	doctl compute ssh $(DIGITALOCEAN_KNOT_SRV_NAME) --ssh-key-path $(DIGITALOCEAN_SSH_FSPATH)




