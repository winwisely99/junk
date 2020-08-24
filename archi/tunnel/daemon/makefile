# https://github.com/takama/daemon

CWD=$(PWD)
BIN_FSPATH=$(CWD)/bin

dep:
	git clone https://github.com/takama/daemon

build:
	cd daemon/examples && go build -o $(BIN_FSPATH)/service .
	cd daemon/examples/cron && go build -o $(BIN_FSPATH)/cron .
cron-run:
	$(BIN_FSPATH)

