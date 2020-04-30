.DEFAULT_GOAL       := help
VERSION             := v0.0.0
TARGET_MAX_CHAR_NUM := 20

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

GKE_ZONE ?= europe-west3-a
GKE_REGION ?= europe-west3

.PHONY: help yugabyte-setup yugabyte-connect-ysql yugabyte-connect-ycql redis-cli yedis-benchmark
	
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


## yugabyte install
yugabyte-setup:
	@helm repo add yugabytedb https://charts.yugabyte.com
	@helm repo update
	@helm search repo yugabytedb/yugabyte
	@kubectl create namespace yugabyte
	@helm install yugabyte yugabytedb/yugabyte --namespace yugabyte --wait
	@helm status yugabyte -n yugabyte
	@kubectl get pods --namespace yugabyte
	@kubectl get services --namespace yugabyte
	@helm history yugabyte -n yugabyte

## yugabyte connect
# Yes needed
yugabyte-connect-ysql:
	@kubectl exec -n yugabyte -it yb-tserver-0 /home/yugabyte/bin/ysqlsh -- -h yb-tserver-0.yb-tservers.yugabyte

## yugabyte connect ycql
# NOT NEEDED !
yugabyte-connect-ycql:
	@kubectl exec -n yugabyte -it yb-tserver-0 /home/yugabyte/bin/cqlsh yb-tserver-0.yb-tservers.yugabyte

## redis cli
# YES needed
redis-cli:
	@kubectl --namespace yugabyte run redis-cli -it --image redis --command -- redis-cli -h yb-tserver-service

## redis benchmark
yedis-benchmark:
	@kubectl --namespace yugabyte run redis-benchmark --generator=run-pod/v1 -it --image redis --command -- redis-benchmark -h yb-tserver-service