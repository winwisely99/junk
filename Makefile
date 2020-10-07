
# help

# Note assumes AWK is installed

.DEFAULT_GOAL       := help
HELP_TARGET_MAX_CHAR_NUM := 20

HELP_GREEN  := $(shell tput -Txterm setaf 2)
HELP_YELLOW := $(shell tput -Txterm setaf 3)
HELP_WHITE  := $(shell tput -Txterm setaf 7)
HELP_RESET  := $(shell tput -Txterm sgr0)

## Help
help:

	@echo ''
	@echo 'Usage:'
	@echo '  ${HELP_YELLOW}make${HELP_RESET} ${HELP_GREEN}<target>${HELP_RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${HELP_YELLOW}%-$(HELP_TARGET_MAX_CHAR_NUM)s${HELP_RESET} ${HELP_GREEN}%s${HELP_RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## git-print: see all variables.
git-print:
	@echo
	@echo -- Git Status --
	@git status
	@echo
	@echo User: 
	@git config user.name
	@echo
	@echo Remotes:
	@git remote -v
	@echo
	@echo Branch: 
	@git branch --show-current -v
	@echo
	@echo


GIT_BRANCH=master

## git-add: adds all files locally.
git-add:
	# add all files 
	git add -A

## git-commit: commit all changes locally.
git-commit:
	# commit all files with a message
	git commit -a

## git-push: push changes to your origin.
git-push:
	# Not needed..



## git-sync: merge upsteam and send a PR.
git-sync:
	#NOTE: It is always a good idea to fetch updates from Bioconductor before making more changes. This will help prevent merge conflicts.
	# The following forces this.

	# 1.Make sure you are on the appropriate branch.
	git checkout $(GIT_BRANCH)

	# 2. Fetch content from upstream
	git fetch upstream

	# 3. Merge upstream with the appropriate local branch 
	git merge upstream/$(GIT_BRANCH)

	# 4. If you also maintain a GitHub repository, push changes to GitHub’s (origin) master branch
	git push origin $(GIT_BRANCH)

	# 5. Make a PR from your origin Github Web GUI.
	open https://github.com/joe-getcouragenow
	open https://github.com/getcouragenow/junk



