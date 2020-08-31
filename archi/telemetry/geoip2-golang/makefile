# https://github.com/oschwald/geoip2-golang

dep:
	git clone https://github.com/oschwald/geoip2-golang
	# pull in test data into "test-data" dir.
	cd geoip2-golang && git submodule init && git submodule update

	git clone https://github.com/oschwald/maxminddb-golang
	cd maxminddb-golang && git submodule init && git submodule update

test:
	cd geoip2-golang && go test -v ./...
	cd maxminddb-golang && go test -v ./...
run:
	go run main.go -h