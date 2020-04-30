# https://github.com/kubeapps/kubeapps


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

dep:
	# docker, kubectl, etc etc ( see bootstrap) 
	# gcloud, kubectl, scaffold
	# VSCODE: https://cloud.google.com/code/docs/vscode/quickstart

	bs tools:iGofish
	gofish init
	gofish tank

	gofish list

	gofish search skaffold
	#bs sTools:iskaffold 

	gofish search minikube
	#bs sTools:iMinikube

	gofish search kubectl
	#bs sTools:iKubectl

	gofish search k9s
	#bs sTools:iKubectl
	gofish install k9s

	


## Smoke
smoke:
	# smoke test (https://kubernetes.io/docs/setup/learning-environment/minikube/#installation)
	minikube start
	kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.10
	kubectl expose deployment hello-minikube --type=NodePort --port=8080
	kubectl get pod

## Dep
dep-helm:
	

	helm repo add bitnami https://charts.bitnami.com/bitnami
	# Helm 2 command
	#helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
	# Helm 3 command
	kubectl create namespace kubeapps
	helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true