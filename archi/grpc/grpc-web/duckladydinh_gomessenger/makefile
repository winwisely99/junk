# https://github.com/duckladydinh/gomessenger

# WOrks
# Chat App with GRPC go backend demo.

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/duckladydinh/gomessenger
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data
LIB_BIN=$(LIB_BIN_FSPATH)/flamed-$(GO_OS)-$(GO_ARCH)

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
	@echo LIB_BIN : $(LIB_BIN)

dep:
	git clone https://$(LIB).git $(LIB_FSPATH)
dep-delete:
	rm -rf $(LIB_FSPATH)
vscode-add:
	code --add $(LIB_FSPATH) --reuse-window

flu-print:
	@echo flutter devices: 
	flutter devices

### GRPC

grpc-dep:
	#go get github.com/ktr0731/evans
	# OR
	brew tap ktr0731/evans
	brew install evans


grpc-gen:
	@echo
	# NOT working !
	#cd $(LIB_FSPATH) && protoc -Iproto proto/chat_service.proto \
		--go_out=plugins=grpc:gms-go/rpc \
		--dart_out=grpc:gms-flutter/lib/rpc
	@echo
	@echo
	cd $(LIB_FSPATH) && protoc -Iproto proto/chat_service.proto \
		--go-grpc_out=gms-go/rpc \
		--dart_out=grpc:gms-flutter/lib/rpc
	@echo

grpc-evans:
	# CLI for GRPC
	# Must have GRPC Reflection turns on in code.
	evans repl $(LIB_FSPATH)/proto/chat_service.proto

#  --js_out=import_style=commonjs:gms-web/src/rpc/ \
#  --grpc-web_out=import_style=commonjs,mode=grpcwebtext:gms-web/src/rpc/ \

### Server
# :9090

server-buildrun:
	cd $(LIB_FSPATH)/gms-go/main && go build -o $(LIB_BIN)

server-run:
	cd $(LIB_FSPATH)/gms-go/main && go run .

## Web tests GRPCWeb works
flu-web-run:
	cd $(LIB_FSPATH)/gms-flutter && flutter run -d chrome

## DESK tests GRPC works
flu-desk-init:
	cd $(LIB_FSPATH)/gms-flutter && hover init
flu-desk-run:
	cd $(LIB_FSPATH)/gms-flutter && hover run

flu-mob-run:
	cd $(LIB_FSPATH)/gms-flutter && flutter run -d 