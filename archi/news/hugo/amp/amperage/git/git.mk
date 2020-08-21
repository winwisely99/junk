# https://github.com/asurbernardo/amperage

# Branch: development
# Fork: None


LIB_NAME=		amperage
LIB=			github.com/asurbernardo/$(LIB_NAME)
LIB_FSPATH=		${GOPATH}/src/$(LIB)


GIT_UPSTREAM_URL=		https://$(LIB)
GIT_UPSTREAM_TAG=		1.87
GIT_UPSTREAM_BRANCH=	development

GIT_FORK_URL=		git@github.com-joe-getcouragenow:joe-getcouragenow/$(LIB_NAME).git

git-print:
	@echo
	@echo -- LIB --
	@echo LIB_FSPATH: 	$(LIB_NAME)
	@echo LIB: 			$(LIB)
	@echo LIB_FSPATH: 	$(LIB_FSPATH)
	
	@echo

	@echo -- GIT --
	@echo GIT_UPSTREAM_URL: 	$(GIT_UPSTREAM_URL)
	@echo GIT_UPSTREAM_TAG: 	$(GIT_UPSTREAM_TAG)
	@echo GIT_UPSTREAM_BRANCH: 	$(GIT_UPSTREAM_BRANCH)
	@echo GIT_FORK_URL: 		$(GIT_FORK_URL)
	@echo

git-upstream-clone:
	# Upstream
	git clone https://$(LIB) $(LIB_FSPATH)

git-upstream-clonetag:
	# Upstream
	git clone https://$(LIB) $(LIB_FSPATH)
	cd $(LIB_FSPATH) && git fetch --tags && git checkout $(GIT_UPSTREAM_TAG)

git-upstream-clonebranch:
	# Upstream
	git clone https://$(LIB) $(LIB_FSPATH)
	cd $(LIB_FSPATH) && git fetch --tags && git checkout $(GIT_UPSTREAM_BRANCH)

git-fork-branch:
	# hardcoded to "sed" since i am working on this branch
	cd $(LIB_FSPATH) && git fetch --tags && git checkout sed

git-fork-clone:
	# Fork
	git clone $(GIT_FORK_URL) $(LIB_FSPATH)

	# Add link back to upstream
	cd $(LIB_FSPATH) && git remote add upstream $(GIT_UPSTREAM_URL)

git-fork-status:
	cd $(LIB_FSPATH) && git remote -v
	cd $(LIB_FSPATH) && git status
	
git-fork-catchup:
	# Get changes from upstream into my local fork
	cd $(LIB_FSPATH) && git fetch upstream
	$(MAKE) git-fork-status
	
git-fork-push:
	# Commit to my github fork, so i can then PR upstream
	cd $(LIB_FSPATH) && git push origin

git-delete:
	rm -rf $(LIB_FSPATH)

vscode-add:

	# copy vscode debug json into project
	mkdir -p $(LIB_FSPATH)/.vscode
	#cp ./launch.json $(LIB_FSPATH)/.vscode/.

	# copy build.mk into actual repo renaming to actual makefile
	#cp ./makefile $(LIB_FSPATH)/makefile

	# Now add the project as a workspace
	code --add $(LIB_FSPATH)
