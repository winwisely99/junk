# using digital ocean




help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


print: ## Print
	# info is standard. error and warming also work.
	$(info )
	$(info Variables - )


	$(info LIB_NAME: 		$(LIB_NAME))
	$(info LIB: 			$(LIB)) 
	$(info LIB_BRANCH: 		$(LIB_BRANCH))
	$(info LIB_FSPATH: 		$(LIB_FSPATH))
	$(info LIB_BIN_NAME: 	$(LIB_BIN_NAME))
	$(info LIB_BIN_FSPATH: 	$(LIB_BIN_FSPATH)) 

	$(info )
	$(info MAKE_IMPORT: 	$(MAKE_IMPORT)) 

	$(info )
	$(info SAMPLE_NAME: 	$(SAMPLE_NAME))
	$(info SAMPLE_FSPATH: 	$(SAMPLE_FSPATH)) 
	$(info )


##@ di

di-auth: ## di authentication
	doctl auth init