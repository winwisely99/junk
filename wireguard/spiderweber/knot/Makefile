
# https://github.com/spiderweber/knot

LIB_NAME=knot
LIB=github.com/spiderweber/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=wg-server
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)

GO111MODULE=on

CLOUD_PROJECT_ID=winwisely-wireguard


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

git-clone:
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
	# none

build:
	cd $(LIB_FSPATH) && go build -o $(LIB_BIN_FSPATH) .
run:
	$(LIB_BIN_FSPATH)
docker-build:
	cd $(LIB_FSPATH) && chmod +x *.sh
	cd $(LIB_FSPATH) && ./.docker-build.sh
docker-run:
	
docker-deploy:
	# where 
	

export KO_DOCKER_REPO=gcr.io/triggermesh
ko-dep:
	GO111MODULE=on go get github.com/google/ko/cmd/ko
	ko version

ko-build:
	# cp config in
	mkdir -p $(LIB_FSPATH)/config
	cp ./config/deploy.yaml $(LIB_FSPATH)/config
	# build it
	cd $(LIB_FSPATH) && ko apply -f config/



