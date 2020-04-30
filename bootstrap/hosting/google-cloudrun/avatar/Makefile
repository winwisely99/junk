# see: https://bartfokker.com/posts/cloud-run/
# code: https://github.com/barthr/Identicon/tree/feature/identicon-library


LIB_NAME=Identicon
LIB=github.com/barthr/$(LIB_NAME)
LIB_BRANCH=feature/identicon-library
LIB_FSPATH=$(GOPATH)/src/$(LIB)

GO111MODULE=on

CLOUD_PROJECT_ID=winwisely-cloudrun


help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## print
	@echo
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_FSPATH: $(LIB_FSPATH)
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


### cloud

cloud-auth:
	gcloud auth login
	gcloud config set project $(CLOUD_PROJECT_ID)

	gcloud config set run/region europe-west1
cloud-open:
	# run
	open https://console.cloud.google.com/run?project=$(CLOUD_PROJECT_ID)
	# container
	open https://console.cloud.google.com/cloud-build/builds?project=$(CLOUD_PROJECT_ID)
	# store
	open https://console.cloud.google.com/storage/browser?project=$(CLOUD_PROJECT_ID)
cloud-build:
	echo $(CLOUD_PROJECT_ID)
	cd $(LIB_FSPATH) && gcloud builds submit --tag gcr.io/$(CLOUD_PROJECT_ID)/identicon-generator
cloud-deploy:
	cd $(LIB_FSPATH) && gcloud beta run deploy --image gcr.io/$(CLOUD_PROJECT_ID)/identicon-generator --platform managed

# URL from cloud-deploy
CLOUD_PROJECT_URL=https://identicon-generator-ts4lgtxcbq-ew.a.run.app

cloud-client-get:
	# works
	curl $(CLOUD_PROJECT_URL)/identicon/generate?name=joe1



### local

export PORT=8080
local-serve:
	# works
	cd $(LIB_FSPATH)/cmd/api && go run .

local-client-get:
	# works
	cd $(LIB_FSPATH)/cmd/cli && go run . -name joe
	


