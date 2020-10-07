#https://github.com/kevburnsjr/shackle

LIB=github.com/kevburnsjr/shackle
LIB_FSPATH=$(GOPATH)/src/$(LIB)

print:


dep:
	git clone https://$(LIB) $(LIB_FSPATH)
dep-delete:
	rm -rf $(LIB_FSPATH)
vs-open:
	code $(LIB_FSPATH)

DATA_DIR=$(PWD)/data
BIN_DIR=$(PWD)/bin
DEV_CFG := _example/local_3x2/config.1.yml,_example/local_3x2/config.2.yml,_example/local_3x2/config.3.yml

make-build:
	mkdir -p $(BIN_DIR)
	cd $(LIB_FSPATH) && $(MAKE) build
	cp $(LIB_FSPATH)/_dist/shackle $(BIN_DIR)/shackle
make-build-clean:
	cd $(LIB_FSPATH) && $(MAKE) clean

make-data-clean:
	cd $(LIB_FSPATH) && $(MAKE) clean-data

run:
	@mkdir -p $(DATA_DIR)/node{1,2,3}
	@mkdir -p $(DATA_DIR)/raft{1,2,3}

	cp -r $(LIB_FSPATH)/_example $(BIN_DIR)

	cd $(BIN_DIR) && ./shackle -c $(DEV_CFG)

	




