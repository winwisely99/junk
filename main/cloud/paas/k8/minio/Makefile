.DEFAULT_GOAL       := help
VERSION             := v0.0.0
TARGET_MAX_CHAR_NUM := 20

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: help minio-setup
	
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


## minio install
minio-setup:
	@kubectl apply -f ingress.yaml
	@kubectl apply -f minio-operator.yaml
	@kubectl apply -f minioinstance.yaml
	@export ACCESS_KEY=$$(openssl rand -base64 32)
	@export SECRET_KEY=$$(openssl rand -base64 32)
	@kubectl create secret generic minio-creds-secret --from-literal=accesskey='$$ACCESS_KEY' --from-literal=secretkey='$$SECRET_KEY'

minio-keys:
	@echo "\naccess key: "
	@kubectl get secret minio-creds-secret -o yaml | grep accesskey | cut -d':' -f2 | tr -d ' ' | base64 -d
	@echo "\nsecret key: "
	@kubectl get secret minio-creds-secret -o yaml | grep secretkey | cut -d':' -f2 | tr -d ' ' | base64 -d