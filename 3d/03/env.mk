# https://github.com/zesage/flutter_earth

# https://github.com/zesage/flutter_cube

LIB_NAME=flutter_cube
LIB=github.com/zesage/$(LIB_NAME)
LIB_BRANCH=master
LIB_FSPATH=$(GOPATH)/src/$(LIB)

GO111MODULE=on

SAMPLE_NAME=planet
SAMPLE_FSPATH=$(LIB_FSPATH)/example/$(SAMPLE_NAME)

CLOUD_PROJECT_ID=winwisely-cloudrun-form

# URL created from cloud-deploy
CLOUD_PROJECT_URL=????
#CLOUD_PROJECT_URL=????https://identicon-generator-ts4lgtxcbq-ew.a.run.app