# https://github.com/prologic/gopherclient
LIB_NAME=gopherclient
LIB=github.com/prologic/$(LIB_NAME)
LIB_BRANCH=master
LIB_TAG=v0.1.1
LIB_FSPATH=$(GOPATH)/src/$(LIB)

# server (pd-server)
LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)


GO111MODULE=on




