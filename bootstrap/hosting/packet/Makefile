LIB_BIN=$(GOPATH)/bin/packet-cli
LIB=github.com/packethost/packet-cli

dep:
	go get github.com/packethost/packet-cli
	go build -o 




# SOURCE
# https://github.com/packethost/packet-cli


LIB_NAME=packet-cli
LIB=github.com/packethost/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN=$(GOPATH)/bin/$(LIB_BIN_NAME)

print:
	@echo
	@echo LIB_NAME: $(LIB_NAME)
	@echo LIB: $(LIB)
	@echo LIB_BRANCH: $(LIB_BRANCH)
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo

git-print:
	cd $(LIB_FSPATH) && git status
git-clone:
	mkdir -p $(LIB_FSPATH)
	cd $(LIB_FSPATH) && cd .. && rm -rf $(LIB_NAME) && git clone ssh://git@$(LIB).git
	cd $(LIB_FSPATH) && git checkout $(LIB_BRANCH)
git-pull:
	cd $(LIB_FSPATH) && git pull
git-clean:
	rm -rf $(LIB_FSPATH)

code:
	code $(LIB_FSPATH)

run:
	$(LIB_BIN)
build:
	cd $(LIB_FSPATH) && go build -o $(LIB_BIN)


