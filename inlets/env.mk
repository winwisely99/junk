# https://github.com/inlets/inlets
LIB_NAME=inlets
LIB=github.com/inlets/$(LIB_NAME)
LIB_BRANCH=master
LIB_TAG=2.6.1
LIB_FSPATH=$(GOPATH)/src/$(LIB)

GO111MODULE=on

SAMPLE_NAME=
SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE_NAME)

CLOUD_PROJECT_ID=winwisely-cloudrun-inlets
CLOUD_PROJECT_URL=????

