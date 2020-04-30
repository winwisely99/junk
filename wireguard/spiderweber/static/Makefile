LIB_BIN_FSPATH=$(PWD)/bin/static

print: ## print
	@echo
	@echo LIB_BIN_FSPATH: $(LIB_BIN_FSPATH)
	@echo

build:
	GOOS=darwin GOARCH=amd64 go build -o $(LIB_BIN_FSPATH)-darwin .
	GOOS=linux GOARCH=amd64 go build -o $(LIB_BIN_FSPATH)-linux .
run:
	$(LIB_BIN_FSPATH)
