.DEFAULT_GOAL       := help
VERSION             := v0.0.0
TARGET_MAX_CHAR_NUM := 20

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

GKE_ZONE ?= europe-west3-a
GKE_REGION ?= europe-west3

.PHONY: help gcloud-setup gke-setup gke-create gke-vars
	
## Show help
help:
	@echo ''
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)


# Follow these sections on README file
# - Create a Google Cloud Account
# - Create a Project
# then run these commands:
#  $ make gke-setup
#  $ make gke-create
#  $ make gke-vars

check-env:
ifndef GKE_PROJECT
	$(error define GKE_PROJECT environment variable)
endif
ifndef GKE_EMAIL
	$(error define GKE_EMAIL environment variable)
endif

## gcloud install
gcloud-setup:
	@curl https://sdk.cloud.google.com | bash
	@gcloud init

## GKE configuration
gke-setup: check-env gcloud-setup
	@gcloud projects add-iam-policy-binding ${GKE_PROJECT} --member user:${GKE_USER} --role roles/iam.serviceAccountKeyAdmin
	@mkdir -p ~/.getcouragenow/
	@gcloud config set project ${GKE_PROJECT}
	@gcloud iam service-accounts create ${GKE_PROJECT}-sa
	@gcloud services enable container.googleapis.com
	@gcloud projects add-iam-policy-binding ${GKE_PROJECT} --member serviceAccount:${GKE_PROJECT}-sa@${GKE_PROJECT}.iam.gserviceaccount.com --role roles/container.admin --role roles/storage.admin
	@gcloud iam service-accounts keys create ~/.getcouragenow/${GKE_PROJECT}.json --iam-account ${GKE_PROJECT}-sa@${GKE_PROJECT}.iam.gserviceaccount.com 

## GKE cluster initialize
gke-create: check-env
	@gcloud container clusters create ${GKE_PROJECT} --zone ${GKE_ZONE}
	@gcloud compute addresses create ${GKE_PROJECT}-static-ip --region ${GKE_REGION}

## GKE cluster variables
gke-vars:
	@echo "GKE_PROJECT: "
	@echo "\t ${GKE_PROJECT}"
	@echo "GKE_IP: " 
	@echo "\t $$(gcloud compute addresses describe ${GKE_PROJECT}-static-ip --region ${GKE_REGION} | grep "address:" | cut -d ':' -f2)"
	@echo "GKE_EMAIL: "
	@echo "\t ${GKE_PROJECT}-sa@${GKE_PROJECT}.iam.gserviceaccount.com"
	@echo "GKE_KEY: "
	@echo $$(cat  ~/.getcouragenow/${GKE_PROJECT}.json | base64 -w0)

## GKE ingress setup
gke-ingress-setup:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/cloud-generic.yaml
	@kubectl --namespace ingress-nginx patch svc ingress-nginx -p "{\"spec\": {\"loadBalancerIP\": \"$$(gcloud compute addresses describe ${GKE_PROJECT}-static-ip --region ${GKE_REGION} | grep "address:" | cut -d ':' -f2)\"}}"
