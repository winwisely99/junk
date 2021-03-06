# https://github.com/nats-io/nats-server/tree/v2.1.2
LIB_NAME=nats-server
LIB=github.com/nats-io/$(LIB_NAME)
LIB_BRANCH=master
LIB_TAG=v2.1.2
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_NAME=$(LIB_NAME)
LIB_BIN_FSPATH=$(GOPATH)/bin/$(LIB_BIN_NAME)

GO111MODULE=on

SAMPLE_NAME=
SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE_NAME)

CLOUD_PROJECT_ID=
CLOUD_PROJECT_URL=

