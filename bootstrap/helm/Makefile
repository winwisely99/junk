MK=minikube kubectl

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## print
	@echo Helm !!
	@echo https://helm.sh/docs/intro/quickstart/

	@echo $(MK)

os-dep: ## os-dep
 
	#brew install kubectl
	#which kubectl
	# using $(MK) instead

	# minikube
	# https://kubernetes.io/docs/tasks/tools/install-minikube/
	brew install minikube
	which minikube

	brew install helm 
	which helm

	go install github.com/roboll/helmfile
	which helmfile

	# draft - SEEMS DEAD THESE DAYS

### Kubernetes

kub-start: ## kub-start
	minikube start --vm-driver=virtualbox

kub-status: ## kub-status
	minikube status

## Helm

hel-conf: ## hel-conf
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/
hel-conf-list: ## hel-conf-list
	helm search repo stable
hel-ls:	# hel-ls
	helm ls