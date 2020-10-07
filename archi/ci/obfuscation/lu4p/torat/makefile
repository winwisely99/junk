# https://github.com/lu4p/ToRat

# Good instructions for using 
# https://github.com/lu4p/ToRat/wiki/How-to-use-the-ToRat-Docker-Image

include ./../../../root.mk

LIB_REPO=				github.com/lu4p
LIB_REPO_FSPATH=		$(GOPATH)/src/$(LIB_REPO)

## RAT

RAT_LIB_NAME=ToRat
RAT_LIB_FSPATH=$(LIB_REPO_FSPATH)/$(RAT_LIB_NAME)


this-server-print:
	@echo RAT_LIB_NAME: 		$(RAT_LIB_NAME)
	@echo RAT_LIB_FSPATH: 		$(RAT_LIB_FSPATH)

this-server-build:
	cd $(RAT_LIB_FSPATH) && sudo docker build . -t torat
this-server-run:
	# this runs the Server & 
	# spits out to the host the Server binaries to ./dist/dist/server, wth certs etc. All ready to be deplyoed somewhere.
	# spits out to the host the client binaries to ./dist/dist/client, so you can use them to connect. Pretty nice
	cd $(RAT_LIB_FSPATH) && sudo docker run -it -v "$(pwd)"/dist:/dist_ext torat
this-client-run:
	# linux
	$(RAT_LIB_FSPATH)/dist/dist/client/client_linux
	# windows
	$(RAT_LIB_FSPATH)/dist/dist/client/client_windows.exe 
	# mac
	## Does not have one for mac yet :)

### git


this-print:
	@echo LIB_REPO: 			$(LIB_REPO)
	@echo LIB_REPO_FSPATH: 		$(LIB_REPO_FSPATH)

this-git-clone:
	$(MAKE) git-clone-args LIB=$(LIB_REPO)/ToRat LIB_FSPATH=$(LIB_REPO_FSPATH)/ToRat

this-git-delete:
	rm -rf $(LIB_REPO_FSPATH)

this-vscode-add:
	# copy vscode debug json into project
	mkdir -p $(LIB_REPO_FSPATH)/.vscode
	
	# cp ./launch.json $(LIB_REPO_FSPATH)/.vscode/.

	# copy make file in
	cp ./makefile $(LIB_REPO_FSPATH)/.

	# Now add the project as a workspace
	code --add $(LIB_REPO_FSPATH)


this-vscode-open:
	code $(LIB_REPO_FSPATH)