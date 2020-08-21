dep-os:
	go get -u golang.org/x/mobile/cmd/gomobile
dep:
	git clone https://github.com/centrifugal/centrifuge-mobile

build-init:
	GO111MODULE=off gomobile init
build:
	# centrifuge.aar
	# Centrifuge.framework
	gomobile bind -target=ios github.com/centrifugal/centrifuge-mobile
	gomobile bind -target=android github.com/centrifugal/centrifuge-mobile
