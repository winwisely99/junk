#https://github.com/ncabatoff/yurt

LIB=github.com/ncabatoff/yurt
LIB_TAG=v1.19.1
LIB_FSPATH=$(GOPATH)/src/$(LIB)

LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data


print:
	@echo
	@echo GO_OS : $(GO_OS)
	@echo GO_ARCH : $(GO_ARCH)
	@echo GIT_VERSION : $(GIT_VERSION)
	@echo
	@echo
	@echo LIB : $(LIB)
	@echo LIB_FSPATH : $(LIB_FSPATH)
	@echo LIB_BIN_FSPATH : $(LIB_BIN_FSPATH)
	@echo LIB_DATA_FSPATH : $(LIB_DATA_FSPATH)

	@echo LIB_BIN_FSPATH : $(LIB_BIN_FSPATH)
	@echo LIB_DATA_FSPATH : $(LIB_DATA_FSPATH)

	@echo 
dep:
	git clone http://$(LIB) $(LIB_FSPATH)
dep-del:
	rm -rf $(LIB_FSPATH)

build:
	cd $(LIB_FSPATH)/cmd/yurt-cluster && go build -o $(LIB_BIN_FSPATH)/yurt-cluster .
	cd $(LIB_FSPATH)/cmd/yurt-run && go build -o $(LIB_BIN_FSPATH)/yurt-run .

cluster-run:
	$(LIB_BIN_FSPATH)/yurt-cluster -h
	$(LIB_BIN_FSPATH)/yurt-cluster
node-run:
	@echo
	$(LIB_BIN_FSPATH)/yurt-run -h
	@echo
	cp yurt-run.yml $(LIB_BIN_FSPATH)
	@echo
	$(LIB_BIN_FSPATH)/yurt-run -config-file yurt-run.yml
	