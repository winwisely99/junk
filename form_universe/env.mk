# https://github.com/leonardarnold/form_universe
LIB_NAME=form_universe
LIB=github.com/leonardarnold/$(LIB_NAME)
LIB_BRANCH=master
LIB_TAG=v2.1.2
LIB_FSPATH=$(GOPATH)/src/$(LIB)


GO111MODULE=on

SAMPLE_NAME=
SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE_NAME)

CLOUD_PROJECT_ID=
CLOUD_PROJECT_URL=

