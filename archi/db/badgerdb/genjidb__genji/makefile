
LIB_NAME=genji
LIB=github.com/genjidb/$(LIB_NAME) 
LIB_VERSION=v0.7.1
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_FSPATH=$(PWD)/bin/$(LIB_NAME)-cli
LIB_DATA_FSPATH=$(PWD)/data

print:
	@echo
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo
	@echo LIB_BIN_FSPATH: $(LIB_BIN_FSPATH)
	@echo LIB_DATA_FSPATH: $(LIB_DATA_FSPATH)
	@echo
dep:
	## install on go bin
	git clone https://$(LIB) $(LIB_FSPATH)
dep-tag: dep
	 #go
	cd $(LIB_FSPATH) && git fetch --all --tags --prune
	cd $(LIB_FSPATH) && git checkout tags/$(LIB_VERSION)
dep-delete:
	rm -rf $(LIB_FSPATH)

vscode-add:
	code --add $(LIB_FSPATH) --reuse-window


cli-build:
	cd $(LIB_FSPATH)/cmd/genji && go build -o $(LIB_BIN_FSPATH) .
	chmod +x $(LIB_BIN_FSPATH)
cli-run:
	#mkdir -p $(LIB_DATA_FSPATH)
	#$(LIB_BIN_FSPATH) -h
	#genji --useBadger true --dbpath $(LIB_DATA_FSPATH)

cli:
	genji --badger mydb
run:
	# delete DB files
	rm -rf mydb
	mkdir mydb

	go run main.go
run-delete:
	rm -rf mydb
