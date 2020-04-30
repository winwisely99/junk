

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)

GIT_VERSION	:= $(shell git describe --tags)

DOCS_FSPATH=$(PWD)/docs

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## print
	@echo
	@echo GO_OS: $(GO_OS)
	@echo GO_OS: $(GO_ARCH)
	@echo

	@echo
	@echo GIT_VERSION: $(GIT_VERSION)
	@echo GIT_OTHER: $(shell git describe --all)
	@echo

	@echo
	@echo DOCS --
	@echo DOCS_FSPATH: $(DOCS_FSPATH)
	@echo

.PHONY: docs-container
docs-container: ##docs-container
	docker run --rm hello-world >/dev/null
	docker build -t m3db-docs docs

# NB(schallert): if updating this target, be sure to update the commands used in
# the .buildkite/docs_push.sh. We can't share the make targets because our
# Makefile assumes its running under bash and the container is alpine (ash
# shell).
.PHONY: docs-build
docs-build: docs-container ##docs-build
	docker run -v $(DOCS_FSPATH) --rm m3db-docs "mkdocs build -e docs/theme -t material"

.PHONY: docs-serve
docs-serve: docs-container ##docs-serve
	docker run -v $(DOCS_FSPATH) -p 8000:8000 -it --rm m3db-docs "mkdocs serve -e docs/theme -t material -a 0.0.0.0:8000"

.PHONY: docs-deploy
docs-deploy: docs-container ##docs-deploy
	docker run -v $(DOCS_FSPATH) --rm -v $(HOME)/.ssh/id_rsa:/root/.ssh/id_rsa:ro -it m3db-docs "mkdocs build -e docs/theme -t material && mkdocs gh-deploy --force --dirty"

.PHONY: docs-validate
docs-validate: docs_test ##docs-validate
	./bin/docs_test

.PHONY: docs-test
docs-test: ##docs-test
	@echo "--- Documentation validate test"
	make docs-validate
	@echo "--- Documentation build test"
	make docs-build