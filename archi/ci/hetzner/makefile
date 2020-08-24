CWD=$(PWD)

BIN_FSPATH=$(CWD)/bin/hcloud

print:


dep:
	git clone https://github.com/hetznercloud/cli

build:
	cd cli//cmd/hcloud && go build -o $(BIN_FSPATH) .

export  dnstoken=43FRQFTkLNoVlP8CpjzXGGkGRtCoeOXd
export 	apitoken=8t0zsoidutysqkTVt4vCZuAY8r3dygSLX7o8IxGcEI6Pu4C2wXCFdLW28v2x9MZd
run:
	#$(BIN_FSPATH) context create joe-project
	$(BIN_FSPATH) server-type list

