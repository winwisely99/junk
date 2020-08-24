CWD=$(PWD)
BIN_FSPATH=$(CWD)/bin

# micro
MIC_FSPATH=$(CWD)/micro
MIC_BIN_FSPATH=$(BIN_FSPATH)/micro
MIC_VERSION=v3.0.0-beta

# m30 services
M3O_SERVICES_FSPATH=$(GOPATH)/src/github.com/m3o/services

# example services
MIC_SERVICES_LIB=github.com/micro/services
MIC_SERVICES_FSPATH=$(GOPATH)/src/$(MIC_SERVICES_LIB)

# clients
CLIENT_LIB=github.com/micro/clients
CLIENT_FSPATH=$(GOPATH)/src/$(CLIENT_LIB)






print:
	@echo
	@echo PATH :$(PATH)
	@echo
	@echo MIC_FSPATH: $(MIC_FSPATH)
	@echo MIC_BIN_FSPATH: $(MIC_BIN_FSPATH)
	@echo MIC_VERSION: $(MIC_VERSION)
	@echo

	@echo
	@echo M3O_SERVICES_FSPATH: $(M3O_SERVICES_FSPATH)
	@echo

	@echo
	@echo MIC_SERVICES_LIB: $(MIC_SERVICES_LIB)
	@echo MIC_SERVICES_FSPATH: $(MIC_SERVICES_FSPATH)
	@echo

	@echo
	@echo CLIENT_LIB: $(CLIENT_LIB)
	@echo CLIENT_FSPATH: $(CLIENT_FSPATH)
	@echo



### Dep
dep:
	# micro boot
	#git clone https://github.com/micro/micro

	# m30 services 
	#git clone https://github.com/m3o/services $(M3O_SERVICES_FSPATH)

	# examples 
	git clone https://$(MIC_SERVICES_LIB) $(MIC_SERVICES_FSPATH)

	# clients
	git clone https://$(CLIENT_LIB) $(CLIENT_FSPATH)

dep-delete:
	#rm -rf micro
	#rm -rf $(M3O_SERVCIES_FSPATH)
	rm -rf $(MIC_SERVICES_FSPATH)
	rm -rf $(CLIENT_FSPATH)

dep-build:
	cd micro && go build -o $(MIC_BIN_FSPATH)
	#cd services && go build -o $(MCO_SERVICES_BIN_FSPATH)

micro-run:
	$(MIC_BIN_FSPATH) env set local
	# cli, http on :8080 or grpc on :8081
	$(MIC_BIN_FSPATH) server

micro-print:
	$(MIC_BIN_FSPATH) env 
	# Spits out:
	# local      127.0.0.1:8081
  	#platform   proxy.m3o.com:443
	
	$(MIC_BIN_FSPATH) services 
	# Spits out:
	# config, events, network, proxy, registry, runtime, server, store

	$(MIC_BIN_FSPATH) auth list

### Examples

hello-run:
	$(MIC_BIN_FSPATH) run github.com/micro/services/helloworld
pubsub-run:
	$(MIC_BIN_FSPATH) run github.com/micro/services/pubsub

### CLIENTS