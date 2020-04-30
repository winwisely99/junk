# Minikube make 
# include this in others as needed


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

## dep
dep:
	# docker, kubectl, etc etc ( see bootstrap) 
	# gcloud, kubectl, scaffold
	# VSCODE: https://cloud.google.com/code/docs/vscode/quickstart

	# bs is our bootsrap binary that we use to encapsulate everything so it can be used from dev and CI
	bs tools:iGofish
	gofish init
	gofish tank

	gofish list

	gofish search skaffold
	#bs sTools:iskaffold
	gofish install skaffold

	gofish search minikube
	#bs sTools:iMinikube
	gofish install minikube

	gofish search kubectl
	#bs sTools:iKubectl
	gofish install kubectl

	gofish search k9s
	#bs sTools:iKubectl
	gofish install k9s

	gofish search helm
	#bs sTools:iKubectl
	gofish install helm

	# Istio 1.5 has been tested with these Kubernetes releases: 1.14, 1.15, 1.16
	gofish search istioctl
	gofish install istioctl

	## gcloud has to be done via https://cloud.google.com/sdk/docs/downloads-interactive#mac
	# TODO add to bootstrap
	# then configure it: https://cloud.google.com/sdk/docs/quickstart-macos
	gcloud init
	gcloud config
	# winwisely99-gitea

## minikube-boot
minikube-boot:
	
	minikube start
	# for istio
	#minikube start --memory=16384 --cpus=4 --kubernetes-version=v1.14.2 

	#  for load balancing ( different terminal)
	minikube tunnel 

	# for dash ( different terminal)
	#minikube dashboard

	# Best to use kubectl via a proxy ( run in different terminal )
	kubectl proxy --port=8080

	# Set kubeconfig context ($HOME/.kube/config)
	#kubectl config view
	kubectl config get-contexts
	kubectl config use-context minikube

	## istioctl
	#istioctl dashboard
	#istioctl dashboard envoy ...

	kubectl cluster-info

## minikube-stop
minikube-stop:
	minikube tunnel --cleanup
	minikube stop


## minikube-smoke
minikube-smoke:
	# smoke test (https://kubernetes.io/docs/setup/learning-environment/minikube/#installation)

	kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.10
	kubectl expose deployment hello-minikube --type=NodePort --port=8080
	kubectl get pod


	
kind-smoke:

kind-smoke-cleanup:


## Dep
dep-helm:
	

	helm repo add bitnami https://charts.bitnami.com/bitnami
	# Helm 2 command
	#helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
	# Helm 3 command
	kubectl create namespace kubeapps
	helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true