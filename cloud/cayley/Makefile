

# https://github.com/cayleygraph/cayley


LIB_NAME=cayley
LIB=github.com/cayleygraph/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)

# Not needed for this proj, but left for others
SAMPLE_NAME=examples/hello_bolt
SAMPLE_GOPATH=$(LIB)/$(SAMPLE_NAME)
SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE_NAME)

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
	@echo SAMPLE_NAME: $(SAMPLE_NAME)
	@echo SAMPLE_GOPATH: $(SAMPLE_GOPATH)
	@echo SAMPLE_FSPATH: $(SAMPLE_FSPATH)
	@echo

git-clone: ## git-clone
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
git-pull: ## git-pull
	cd $(LIB_FSPATH) && git pull
git-clean: ## git-clean
	rm -rf $(LIB_FSPATH)

code: ## code
	code $(LIB_FSPATH)

dep: ## dep
	# depth for looking at dependencies
	# installs to go bin
	go get github.com/KyleBanks/depth/cmd/depth

depth:
	#cd $(SAMPLE_FSPATH) && depth $(SAMPLE_GOPATH)
	cd $(SAMPLE_FSPATH) && depth .

lib-local-install: ## lib-local-install
	cd $(LIB_FSPATH)/cmd/ko && go build -o $(LIB_BIN_FSPATH) . 


sam-local-build: ## sam-local-build
	cd $(SAMPLE_FSPATH) && hugo
	ls -al $(SAMPLE_FSPATH)/public
sam-local-run: local-build ## sam-local-run
	cd $(SAMPLE_FSPATH) && hugo server -F
sam-local-open: ## sam-local-open
	cd $(SAMPLE_FSPATH) && open http://localhost:1313/about
