# https://github.com/GoAdminGroup/example

LIB=github.com/GoAdminGroup/example
LIB_FSPATH=$(GOPATH)/src/$(LIB)

dep:
	git clone https://$(LIB) $(LIB_FSPATH)
dep-del:
	rm -rf $(LIB_FSPATH)

vscode-add:
	code --add $(LIB_FSPATH) --reuse-window

gen:
	# Makes test data
	cd $(LIB_FSPATH) && $(MAKE) generate 
build:
	cd $(LIB_FSPATH) && $(MAKE) build 
run:
	cd $(LIB_FSPATH) && $(MAKE) serve  
	#  http://localhost:9033/admin

