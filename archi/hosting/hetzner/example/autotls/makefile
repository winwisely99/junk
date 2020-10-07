
# https://raw.githubusercontent.com/gin-gonic/autotls/master/_example/example2/example2.go

build-init:
	go mod init
build:
	go build -o ./bin/autotls .
run:
	./bin/autotls

	# NOTE: will need to ssh in and accept TOS
open:
	#open https://autotls1.getcouragenow.org/ping
	open http://localhost:8080/ping
