CWD:=$(shell echo `pwd`)
BUILD_DIR:=$(CWD)/build
BUILD_OS:=`go env GOOS`
BUILD_OS_ARCH:=`go env GOARCH`
BUILD_OS_GOPATH=`go env GOPATH`

# https://github.com/nats-io/nats-account-server.git

# NS: Nats Server
NS_NAME=nats-server/
NS_BIN=ns
NS_VERSION=v2.1.7
NS_FSPATH=$(CWD)/nats-server

# NJS: https://github.com/nats-io/jetstream
NJS_NAME=jetstream/
NJS_BIN=js
NJS_VERSION=v0.0.18
NJS_FSPATH=$(CWD)/jetstream

# NAS: nats-account-server
NATS_ACC_SER_NAME=nats-account-server
NATS_ACC_SER_BIN=nas
NATS_ACC_SER_VERSION=v0.8.4
NATS_ACC_SER_FSPATH=$(CWD)/nats-account-server

# https://github.com/nats-io/nsc
# Used to manage the nats accounts.
NSC_NAME=nsc
NSC_BIN=nas
NSC_VERSION=v0.4.10
NSC_FSPATH=$(CWD)/nsc


print:
	@echo
	@echo BUILD_DIR: $(BUILD_DIR)
	@echo BUILD_OS: $(BUILD_OS)
	@echo BUILD_OS_ARCH: $(BUILD_OS_ARCH)
	@echo BUILD_OS_GOPATH: $(BUILD_OS_GOPATH)
	@echo

	@echo
	@echo NATS_ACC_SER: $(NATS_ACC_SER_NAME)
	@echo NATS_ACC_SER_BIN: $(NATS_ACC_SER_BIN)
	@echo NATS_ACC_SER_VERSION: $(NATS_ACC_SER_VERSION)
	@echo NATS_ACC_SER_FSPATH: $(NATS_ACC_SER_FSPATH)
	@echo

	@echo
	@echo NSC_NAME: $(NSC_NAME)
	@echo NSC_BIN: $(NSC_BIN)
	@echo NSC_VERSION: $(NSC_VERSION)
	@echo NSC_FSPATH: $(NSC_FSPATH)
	@echo

### TOOLS

dep-tools:
	# goreleaser
	git clone https://github.com/goreleaser/goreleaser
	cd goreleaser && git checkout v0.141.0
	cd goreleaser && go get ./...
	cd goreleaser && go build -o goreleaser .
	goreleaser --version
dep-tools-delete:
	rm -rf goreleaser


### NATS

dep-tag:
	git clone https://github.com/nats-io/nats-server.git
	cd nats-server && git checkout $(NS_VERSION)

	git clone https://github.com/nats-io/jetstream
	cd jetstream && git checkout $(NJS_VERSION)

	git clone https://github.com/nats-io/nats-account-server.git
	cd nats-account-server && git checkout $(NATS_ACC_SER_VERSION)

	git clone https://github.com/nats-io/nsc.git
	cd nats-account-server && git checkout $(NSC_VERSION)
dep-master:
	git clone https://github.com/nats-io/nats-server.git
	git clone https://github.com/nats-io/jetstream
	git clone https://github.com/nats-io/nats-account-server.git
	git clone https://github.com/nats-io/nsc.git
dep-clean:
	rm -rf nats-account-server
	rm -rf nsc


ns-build:
	cd $(NS_FSPATH) && go build -o $(BUILD_DIR)/ns . 
ns-release:
	cd $(NS_FSPATH) && goreleaser --snapshot --rm-dist --skip-validate --skip-publish --parallelism 12
	cd $(NS_FSPATH) && cp $(BUILD_DIR)/ns_$(BUILD_OS)_$(BUILD_OS_ARCH)/* $(BUILD_OS_GOPATH)/bin
ns-run:
	# run so it works with jetstream
	# 0.0.0.0:4222
	$(BUILD_DIR)/ns -js -sd $(BUILD_DIR)/data/ns
	

njs-build:
	cd $(NJS_FSPATH) && go build -o $(BUILD_DIR)/njs . 
njs-release:
	cd $(NJS_FSPATH) && goreleaser release --snapshot --config .goreleaser.yml
	# If needed later..
	#cd $(NJS_FSPATH) && goreleaser release --snapshot --config .goreleaser-nightly.yml
	# copy onto standard build so we can try it locally.
	cp $(NJS_FSPATH)/dist/nats_darwin_amd64/nats $(BUILD_DIR)/njs
	


nas-build:
	cd $(NATS_ACC_SER_FSPATH) && make update
	cd $(NATS_ACC_SER_FSPATH) && go build -o $(BUILD_DIR)/nas .
nas-release:
	cd $(NATS_ACC_SER_FSPATH) && make release
	cd $(NATS_ACC_SER_FSPATH) && cp $(BUILD_DIR)/nsc_$(BUILD_OS)_$(BUILD_OS_ARCH)/* $(BUILD_OS_GOPATH)/bin
nas-run:
	$(BUILD_DIR)/nas
nas-open:
	open 127.0.0.0.1:4222


nsc-build: 
	cd $(NSC_FSPATH) && go build -o $(BUILD_DIR)/nsc .

nsc-release:
	cd $(NSC_FSPATH) && make install

# mac
CONFIG_FPATH=/Users/apple/.nsc/nats

#cli docs: https://nats-io.github.io/nsc/

nsc-init:
	$(BUILD_DIR)/nsc init
nsc-config-delete:
	rm -rf $(CONFIG_FPATH)
nsc-config-open:
	code $(CONFIG_FPATH)





