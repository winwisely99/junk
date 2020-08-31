# https://github.com/Herocod3r/fast-r

LIB_FSPATH=$(PWD)/fast-r
LIB_BIN=$(PWD)/bin

print:
	@echo
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo


dep:
	git clone https://github.com/Herocod3r/fast-r

wasm-build:
	cd $(LIB_FSPATH)/cmd/wasm && GOOS=js GOARCH=wasm go build -o $(LIB_BIN)/wasm .

	# copy into sample the wasm 
	cp $(LIB_BIN)/wasm $(LIB_FSPATH)/samples/wasm/main.wasm

	# copy into sample the golang wasm loader to ensure up to date with the golang version.
	cp $(GOROOT)/misc/wasm/wasm_exec.js $(LIB_FSPATH)/samples/wasm/wasm_exec.js

server-run:
	#cd $(LIB_FSPATH)/samples/wasm && go run . -listen 8090 -dir $(PWD)/samples
	#cd $(LIB_FSPATH)/samples/wasm && go run . -listen 8090

	cd $(LIB_FSPATH)/samples/wasm && go run .
	# 127.0.0.1:8080

cli-run:
	cd $(LIB_FSPATH)/cmd/cli && go run . run 



