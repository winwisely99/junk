# from: https://github.com/nolte/gitea-helm-chart/tree/develop

# help
.DEFAULT_GOAL       := help
VERSION             := v0.0.0
TARGET_MAX_CHAR_NUM := 20

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

# boilerplate
export REPOSITORY=bootstrap
#include boilerplate/cgn/git/Makefile
#include boilerplate/lyft/docker_build/Makefile
#include boilerplate/lyft/golang_test_targets/Makefile


# remove the "v" prefix
VERSION ?= $(shell echo $(TAGGED_VERSION) | cut -c 2-)

.PHONY: help build fmt lint test release-tag release-push

HELM_URL=https://jfelten.github.io/helm-charts/charts

CLOUD_PROJECT_ID=winwisely-cloudrun-form

# URL created from cloud-deploy
CLOUD_PROJECT_URL=????

## Show help
help:
	@echo 'Provides a gitea cloud hosting.'
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Print
print: 

	@echo
	@echo VERSION: $(VERSION)
	@echo HELM_URL: $(HELM_URL)
	@echo CLOUD_PROJECT_ID: $(CLOUD_PROJECT_ID)
	@echo CLOUD_PROJECT_URL: $(CLOUD_PROJECT_URL)
	@echo

## Add it to the local helm
helm-dep:
	helm repo add jfelten $(HELM_URL)
	
## Remove from helm
helm-del:
	helm delete gitea --purge
helm-list:
	helm list

## helm it locally
helm-local:
	helm install --name gitea --namewspace tools .

## helm install
helm-install:
	helm install -- values custom_values.yaml --name gitea --namespace gittea jfelten/gitea

### local

## lcloud-print
lcloud-print:
	#minikube start
	kubectl cluster-info
	kubectl get nodes
	#kubectl describe node



### cloud

## cloud-auth
cloud-auth:
	gcloud auth login
	gcloud config set project $(CLOUD_PROJECT_ID)

	gcloud config set run/region europe-west1

## cloud-open
cloud-open:
	# run
	open https://console.cloud.google.com/run?project=$(CLOUD_PROJECT_ID)
	# container
	open https://console.cloud.google.com/cloud-build/builds?project=$(CLOUD_PROJECT_ID)
	# store
	open https://console.cloud.google.com/storage/browser?project=$(CLOUD_PROJECT_ID)

## cloud-build
cloud-build:
	echo $(CLOUD_PROJECT_ID)
	cd $(LIB_FSPATH) && gcloud builds submit --tag gcr.io/$(CLOUD_PROJECT_ID)/identicon-generator

## cloud-deploy
cloud-deploy:
	cd $(LIB_FSPATH) && gcloud beta run deploy --image gcr.io/$(CLOUD_PROJECT_ID)/identicon-generator --platform managed

## cloud-client-get
cloud-client-get:
	# Change to use a HTTP Request that hits the API running on the cloud
	# Request needs to be a Http Form post
	curl $(CLOUD_PROJECT_URL)/identicon/generate?name=joe1

