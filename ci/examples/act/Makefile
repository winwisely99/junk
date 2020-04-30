

# https://github.com/nektos/act
# Allows to run github actions locally by also uing docker liek ti does.
# This wil allow us to get the flutter desktop use the same approach locally and on github.

LIB_NAME=act
LIB=github.com/nektos/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

# Not needed for this proj, but left for others
SAMPLE_NAME=resources/website
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
	@echo SAMPLE_NAME: $(SAMPLE_NAME)
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

HUGO_VER=v0.59.1
dep: ## dep
	# assume git & golang is present
	#git clone --depth=1 -b $(HUGO_VER) https://github.com/gohugoio/hugo.git
	cd hugo &&go install --tags extended
	which hugo
dep-clean: ## dep-clean
	rm -rf hugo

lib-local-install: ## lib-local-install
	# gets the latest release of act
	cd $(LIB_FSPATH) && make installer
lib-local-build: ## lib-local-build
	# uses docker to run a github action of itself
	cd $(LIB_FSPATH) && make build

sam-local-build: ## sam-local-build
	cd $(SAMPLE_FSPATH) && hugo
	ls -al $(SAMPLE_FSPATH)/public
sam-local-run: local-build ## sam-local-run
	cd $(SAMPLE_FSPATH) && hugo server -F
sam-local-open: ## sam-local-open
	cd $(SAMPLE_FSPATH) && open http://localhost:1313/about
