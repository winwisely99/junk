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

	@echo VERSION: $(VERSION)
	@echo

## Add it to the local helm
dep:
	helm repo add jfelten https://jfelten.github.io/helm-charts/charts
	
## Remove from helm
dep-del:
	helm delete gitea --purge
list:
	helm list

## Install it locally
install-local:
	helm install --name gitea --namewspace tools .

## Install default
install-default:
	helm install -- values custom_values.yaml --name gitea --namespace gittea jfelten/gitea
