.DEFAULT_GOAL       := help
VERSION             := v0.0.0
TARGET_MAX_CHAR_NUM := 20

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

SHELL := zsh

.PHONY: help nats-bench
	
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


## nats benchmark
nats-bench:
	@go get -v github.com/nats-io/stan.go
	@go build -o stan-bench $$GOPATH/src/github.com/nats-io/stan.go/examples/stan-bench/main.go
	@docker run --name postgres00 -d -e POSTGRES_PASSWORD=password -p 5432:5432 postgres
	@sleep 3
	@cat drop_postgres.db.sql | docker exec -i postgres00 psql -h 127.0.0.1 -U postgres
	@cat postgres.db.sql | docker exec -i postgres00 psql -h 127.0.0.1 -U postgres
	@docker run -d --link postgres00:postgres00 --name nats-streaming00 -p 4222:4222 -p 8222:32768 nats-streaming --store sql --sql_driver postgres --sql_source="user=postgres password=password host=postgres00 port=5432 sslmode=disable"
	@sleep 5
	# Publish only benchmark
	@./stan-bench -s "nats://127.0.0.1:4222" -np 100 -n 100000 -ms 256 foo

clean:
	@docker rm -f postgres00 || true
	@docker rm -f nats-streaming00 || true
	@rm -f nats-bench