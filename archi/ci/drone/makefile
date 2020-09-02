CWD:=$(shell echo `pwd`)
BUILD_DIR:=$(CWD)/build
BUILD_OS:=`go env GOOS`
BUILD_OS_ARCH:=`go env GOARCH`
BUILD_OS_GOPATH=`go env GOPATH`

# https://github.com/drone/drone
# DRO: DRONE Server
DRO_NAME=drone
DRO_BIN_SERVER=dro-server
DRO_BIN_AGENT=dro-agent
DRO_BIN_CONTROLLER=dro-controller
DRO_VERSION=v1.9.0
DRO_FSPATH=$(CWD)/drone

# https://github.com/drone-runners/drone-runner-exec
# DRR
DRR_NAME=drone-runner-exec
DRR_BIN=drr
DRR_VERSION=v1.0.0-beta.9
DRR_FSPATH=$(CWD)/drone-runner-exec

# https://github.com/drone/drone-cli
# Drone CLI
DRC_NAME=drone-cli
DRC_BIN=dro-cli
DRC_VERSION=v1.2.2
DRC_FSPATH=$(CWD)/drone-cli

# GTE: https://github.com/go-gitea/gitea
GTE_NAME=gitea
GTE_BIN=gte
GTE_VERSION=v1.12.3
GTE_FSPATH=$(CWD)/gitea




print:
	@echo
	@echo BUILD_DIR: $(BUILD_DIR)
	@echo BUILD_OS: $(BUILD_OS)
	@echo BUILD_OS_ARCH: $(BUILD_OS_ARCH)
	@echo BUILD_OS_GOPATH: $(BUILD_OS_GOPATH)
	@echo

	@echo
	@echo DRO_NAME: $(DRO_NAME)
	@echo DRO_BIN_SERVER: $(DRO_BIN_SERVER)
	@echo DRO_BIN_AGENT: $(DRO_BIN_AGENT)
	@echo DRO_BIN_CONTROLLER: $(DRO_BIN_CONTROLLER)
	@echo DRO_VERSION: $(DRO_VERSION)
	@echo DRO_FSPATH: $(DRO_FSPATH)
	@echo

	@echo
	@echo DRR_NAME: $(DRR_NAME)
	@echo DRR_BIN: $(DRR_BIN)
	@echo DRR_VERSION: $(DRR_VERSION)
	@echo DRR_FSPATH: $(DRR_FSPATH)
	@echo

	@echo
	@echo DRC_NAME: $(DRC_NAME)
	@echo DRC_BIN: $(DRC_BIN)
	@echo DRC_VERSION: $(DRC_VERSION)
	@echo DRC_FSPATH: $(DRC_FSPATH)
	@echo

	@echo
	@echo GTE_NAME: $(GTE_NAME)
	@echo GTE_BIN: $(GTE_BIN)
	@echo GTE_VERSION: $(GTE_VERSION)
	@echo GTE_FSPATH: $(GTE_FSPATH)
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
	# server
	git clone https://github.com/drone/drone.git
	cd $(DRO_FSPATH) && git checkout $(DRO_VERSION)

	# runner
	git clone https://github.com/drone-runners/drone-runner-exec.git
	cd $(DRR_FSPATH) && git checkout $(DRR_VERSION)

	# cli
	git clone https://github.com/drone/drone-cli.git
	cd $(DRC_FSPATH) && git checkout $(DRC_VERSION)

	# gitea
	git clone https://github.com/go-gitea/gitea.git
	cd $(GTE_FSPATH) && git checkout $(GTE_VERSION)


dep-master:
	# sever
	git clone https://github.com/drone/drone.git
	# runner
	git clone https://github.com/drone-runners/drone-runner-exec.git
	# cli
	git clone https://github.com/drone/drone-cli.git
	# gitea
	git clone https://github.com/go-gitea/gitea.git
	
dep-clean:
	rm -rf $(DRO_FSPATH)
	rm -rf $(DRC_FSPATH)
	rm -rf $(GTE_FSPATH)


dro-build:
	cd $(DRO_FSPATH)/cmd/drone-agent && go build -o $(BUILD_DIR)/$(DRO_BIN_AGENT) .
	cd $(DRO_FSPATH)/cmd/drone-controller && go build -o $(BUILD_DIR)/$(DRO_BIN_CONTROLLER) .
	cd $(DRO_FSPATH)/cmd/drone-server && go build -o $(BUILD_DIR)/$(DRO_BIN_SERVER) .

	# might as well build the CLI here too.
	cd $(DRC_FSPATH)/drone && go build -o $(BUILD_DIR)/$(DRC_BIN) .
	
dro-release:
	# NOT SETUP: Miht not be needed.
	cd $(DRO_FSPATH) && goreleaser --snapshot --rm-dist --skip-validate --skip-publish --parallelism 12
	cd $(DRO_FSPATH) && cp $(BUILD_DIR)/DRO_$(BUILD_OS)_$(BUILD_OS_ARCH)/* $(BUILD_OS_GOPATH)/bin

# Gitea Setup: https://docs.drone.io/server/provider/gitea/
# https://docs.drone.io/server/reference/drone-gitea-client-id/
export DRONE_GITEA_CLIENT_ID
# https://docs.drone.io/server/reference/drone-gitea-client-secret/
export DRONE_GITEA_CLIENT_SECRET
# https://docs.drone.io/server/reference/drone-gitea-server/
export DRONE_GITEA_SERVER
https://docs.drone.io/server/reference/drone-gitea-skip-verify/
export DRONE_GITEA_SKIP_VERIFY


--env=DRONE_GITEA_SERVER={{DRONE_GITEA_SERVER}} \
--env=DRONE_GITEA_CLIENT_ID={{DRONE_GITEA_CLIENT_ID}} \
--env=DRONE_GITEA_CLIENT_SECRET={{DRONE_GITEA_CLIENT_SECRET}} \
--env=DRONE_RPC_SECRET={{DRONE_RPC_SECRET}} \
--env=DRONE_SERVER_HOST={{DRONE_SERVER_HOST}} \
--env=DRONE_SERVER_PROTO={{DRONE_SERVER_PROTO}} \
--publish=80:80 \
--publish=443:443 \
--restart=always \
--detach=true \
--name=drone \
  drone/drone:1

dro-run:
	# localhost:8080
	$(BUILD_DIR)/$(DRO_BIN_SERVER)


	


gte-build:
	cd $(GTE_FSPATH) && make update
	cd $(GTE_FSPATH) && go build -o $(BUILD_DIR)/nas .
gte-release:
	cd $(GTE_FSPATH) && make release
	cd $(GTE_FSPATH) && cp $(BUILD_DIR)/nsc_$(BUILD_OS)_$(BUILD_OS_ARCH)/* $(BUILD_OS_GOPATH)/bin
gte-run:
	$(BUILD_DIR)/nas
gte-open:
	open 127.0.0.0.1:4222
