# https://github.com/vugu/vugu
# https://github.com/vugu-examples/tinygo


# https://github.com/vugu/vgrun
VUGO_RUN_LIB=			github.com/vugu/vgrun
VUGO_RUN_FSPATH=		$(GOPATH)/src/$(VUGO_RUN_LIB)

VUGO_LIB=				github.com/vugu/vugu
VUGO_LIB_FSPATH=		$(GOPATH)/src/$(VUGO_LIB)
VUGO_LIB_VERSION=		v2.0.0

## Example tinygo
EX_TINYGO_LIB=			github.com/vugu-examples/tinygo
EX_TINYGO_FSPATH=		$(GOPATH)/src/$(EX_TINYGO_LIB)

## Example todo 
# https://github.com/vugu-examples/todo
EX_TODO_LIB=			github.com/vugu-examples/todo
EX_TODO_LIB_FSPATH=		$(GOPATH)/src/$(EX_TODO_LIB)



print:
	@echo
	@echo -- VUGO RUN --
	@echo VUGO_RUN_LIB: 		$(VUGO_RUN_LIB)
	@echo VUGO_RUN_FSPATH: 		$(VUGO_RUN_FSPATH)
	@echo

	@echo
	@echo -- VUGO --
	@echo VUGO_LIB: 			$(VUGO_LIB)
	@echo VUGO_LIB_FSPATH: 		$(VUGO_LIB_FSPATH)
	@echo VUGO_LIB_VERSION: 	$(VUGO_LIB_VERSION)
	@echo

	@echo
	@echo -- VUGO EX TINYGO --
	@echo EX_TINYGO_LIB: 		$(EX_TINYGO_LIB)
	@echo EX_TINYGO_FSPATH: 	$(EX_TINYGO_FSPATH)
	@echo

	@echo
	@echo -- VUGO EX TODO --
	@echo EX_TODO_LIB: 			$(EX_TODO_LIB)
	@echo EX_TODO_LIB_FSPATH: 	$(EX_TODO_LIB_FSPATH)
	@echo

git-clone:
	git clone https://$(VUGO_RUN_LIB).git $(VUGO_RUN_FSPATH)
	cd $(VUGO_RUN_FSPATH) && git fetch --all --tags --prune
	
	git clone https://$(VUGO_LIB).git $(VUGO_LIB_FSPATH)
	cd $(VUGO_LIB_FSPATH) && git fetch --all --tags --prune
	#cd $(VUGO_LIB_FSPATH) && git checkout tags/$(VUGO_LIB_VERSION)

	git clone https://$(EX_TINYGO_LIB).git $(EX_TINYGO_FSPATH)
	cd $(EX_TINYGO_FSPATH) && git fetch --all --tags --prune

	git clone https://$(EX_TODO_LIB).git $(EX_TODO_LIB_FSPATH)
	cd $(EX_TODO_LIB_FSPATH) && git fetch --all --tags --prune

	
git-delete:
	rm -rf $(VUGO_RUN_FSPATH)
	rm -rf $(VUGO_LIB_FSPATH)
	rm -rf $(EX_TINYGO_FSPATH)
	rm -rf $(EX_TODO_LIB_FSPATH)


### LIB

dep-build:
	mkdir -p $(PWD)/bin
	cd $(VUGO_RUN_FSPATH) && go build -o $(PWD)/bin/vgrun
	# put onto GOBIN
	cp $(PWD)/bin/vgrun $(GOPATH)/bin/.
	which vgrun
	# This fails so i install hem manually below.
	#vgrun -install-tools

	cd $(VUGO_LIB_FSPATH)/cmd/vugugen && go build -o $(PWD)/bin/vugugen
	cd $(VUGO_LIB_FSPATH)/cmd/vugufmt && go build -o $(PWD)/bin/vugufmt

	# put onto GOBIN
	cp $(PWD)/bin/vugugen $(GOPATH)/bin/.
	cp $(PWD)/bin/vugufmt $(GOPATH)/bin/.
	which vugugen
	which vugufmt

dep-clean:
	rm -rf $(PWD)/bin

	rm -rf $(GOPATH)/bin/vugugen
	rm -rf $(GOPATH)/bin/vugufmt
	rm -rf $(GOPATH)/bin/vgrun
	

# EX LIB
ex-new-gen:
	mkdir -p test
	cd test && vgrun -new-from-example=simple .
ex-new-run:
	cd test && vgrun devserver.go
	# Note to force tinygo change the generate.go contents to "//go:generate vugugen -tinygo"
	# open: 127.0.0.1:8844
ex-new-delete:
	rm -rf test

ex-tinygo-run:
	#cd $(EX_TINYGO_FSPATH) && vgrun devserver.go
	cd $(EX_TINYGO_FSPATH) && go run devserver.go
	
ex-todo-run:
	# needs wire
	go get github.com/google/wire/cmd/wire
	cd $(EX_TODO_LIB_FSPATH) && go generate
	cd $(EX_TODO_LIB_FSPATH) && go generate



