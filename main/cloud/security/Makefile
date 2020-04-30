

# https://github.com/nuts-foundation/nuts-event-octopus

LIB_NAME=nuts-event-octopus
LIB=github.com/nuts-foundation/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

GO111MODULE=on


#SAMPLE_NAME=stocks
#SAMPLE_NAME=draggable_borderless
SAMPLE_NAME=texture_tutorial

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

git-clone: ## git-clone
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
git-pull:
	cd $(LIB_FSPATH) && git pull
git-clean:
	rm -rf $(LIB_FSPATH)

code:
	code $(LIB_FSPATH)

dep:
	# for docs
	# must update path too.
	#brew install sphinx-doc
	# export PATH="/usr/local/opt/sphinx-doc/bin:$PATH"

	# download draw.io app
	# https://github.com/jgraph/drawio-desktop/releases

	
doc:
	
	cd $(LIB_FSPATH)/docs && make 

build:
	cd $(LIB_FSPATH) && make
	cd $(LIB_FSPATH) && go build .

run:
	cd $(LIB_FSPATH) && go run .