#https://github.com/googleapis/google-api-go-client/tree/master/google-api-go-generator/internal/disco

# Its 500 MB due to HUGE git log.
# All we want is this: https://github.com/googleapis/google-api-go-client/tree/master/google-api-go-generator


LIB=github.com/googleapis/google-api-go-client
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_SUB_FSPATH=$(LIB_FSPATH)/google-api-go-generator
LIB_BIN=$(PWD)/bin/disco

SRC_LIB_FSPATH=$(PWD)/src/google-api-go-generator



print:
	@echo
	@echo LIB: $(LIB)
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo LIB_SUB_FSPATH: $(LIB_SUB_FSPATH)
	@echo LIB_BIN: $(LIB_BIN)
	@echo
	@echo SRC_LIB_FSPATH: $(SRC_LIB_FSPATH)
	@echo



dep:
	git clone https://$(LIB) $(LIB_FSPATH)
dep-delete:
	rm -rf $(LIB_FSPATH)

vscode-add:
	code -add $(LIB_FSPATH)/google-api-go-generator --reuse-window

hack-copy:
	# we only want this: google-api-go-generator
	mkdir -p src
	cp -R $(LIB_FSPATH)/google-api-go-generator $(SRC_LIB_FSPATH)
hack-replace:
	make dep-delete
	mkdir $(LIB_FSPATH)
	cp -R $(SRC_LIB_FSPATH) $(LIB_FSPATH)/google-api-go-generator


### BUILD

# the JSON files.
DATA_FSPATH=$(PWD)/data
# The golang generated from the json
GEN_OUT_FSPATH=$(PWD)/gen
# the golang binary that holds all the generated golang.
BIN_OUT_SPATH=$(PWD)/gen/bin

build-all:
	 #DONT run this. It gens for the whole repo. takes ages
	cd $(LIB_SUB_FSPATH) && $(MAKE)
build:
	cd $(LIB_SUB_FSPATH) && go build -o $(LIB_BIN) .

### GEN

gen-delete:
	rm -rf $(GEN_OUT_FSPATH)/storage

gen-run: gen-delete
	# test2-api is slimmed down
	$(LIB_BIN) -api_json_file $(DATA_FSPATH)/test-api.json -gendir $(GEN_OUT_FSPATH)
	$(LIB_BIN) -api_json_file $(DATA_FSPATH)/test2-api.json -gendir $(GEN_OUT_FSPATH)
	$(LIB_BIN) -api_json_file $(DATA_FSPATH)/test3-api.json -gendir $(GEN_OUT_FSPATH)
	$(LIB_BIN) -api storage:v3 -gendir $(GEN_OUT_FSPATH)

gen-build:
	# guess path based on .json data
	cd $(GEN_OUT_FSPATH) && go build -o $(BIN_OUT_SPATH) .

	# looks for api-list.json
	#cd $(GEN_OUT_FSPATH) && $(LIB_BIN) -build -gendir $(GEN_OUT_FSPATH)
gen-install:
	#cd $(GEN_OUT_FSPATH) && $(LIB_BIN) -install

### OTHER

get:
	$(LIB_BIN) get urlshortener --openapi3
