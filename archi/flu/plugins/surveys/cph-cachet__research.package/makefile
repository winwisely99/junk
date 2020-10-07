# https://github.com/cph-cachet/research.package

# NOTES
# - Benchmark only works on mobile as it has the SQLite in it.
# - Example works fine.

GO_OS 		:= $(shell go env GOOS)
GO_ARCH		:= $(shell go env GOARCH)
GIT_VERSION	:= $(shell git describe --tags)

LIB=github.com/cph-cachet/research.package
LIB_TAG=
LIB_FSPATH=$(GOPATH)/src/$(LIB)
LIB_BIN_FSPATH=$(PWD)/bin
LIB_DATA_FSPATH=$(PWD)/data


LIB_FLU_SAMEPLE_NAME=example/research_package_demo_app
LIB_FLU_SAMEPLE_FSPATH=$(LIB_FSPATH)/$(LIB_FLU_SAMEPLE_NAME)


export GO111MODULE=on

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
	
	@echo LIB_FLU_SAMEPLE_FSPATH : $(LIB_FLU_SAMEPLE_FSPATH)


dep:
	git clone https://$(LIB).git $(LIB_FSPATH)
dep-tag: dep
	cd $(LIB_FSPATH) && git fetch --all --tags --prune && git checkout tags/$(LIB_TAG)
dep-delete:
	rm -rf $(LIB_FSPATH)
vscode-add:
	code --add $(LIB_FSPATH) --reuse-window


### Build XCADDY
build:
	mkdir -p $(LIB_BIN_FSPATH)
	cd $(LIB_FSPATH)/cmd/xcaddy && go build -o $(LIB_XBIN) .
	
build-delete:
	rm -rf $(LIB_BIN_FSPATH)


flu-dep:
	# flu
	flutter channel master
	flutter upgrade --force

	# Run init after a flutter upgrade, so it upgrade the project code.

	# flu desk
	GO111MODULE=on go get -u -a github.com/go-flutter-desktop/hover
	# flu web server runner
	go get -u github.com/shurcooL/goexec


## WEB
flu-web-init:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter create .
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter pub get
flu-web-run:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter run -d chrome
	#cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter run --release --dart-define=FLUTTER_WEB_USE_SKIA=true -d chrome
flu-web-build:
	flutter config --enable-web
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build web --release
flu-web-buildwasm:
	flutter config --enable-web
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
flu-web-open:
	open http://localhost:8080
	cd $(LIB_FLU_SAMEPLE_FSPATH)/build && goexec -quiet 'http.ListenAndServe(":8080", http.FileServer(http.Dir("web")))'


## DESK
flu-desk-print:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover plugins list
flu-desk-init:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover init

	# https://github.com/boltomli/go-flutter-plugin-sqlite
	

flu-desk-run:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover plugins get 
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover run
flu-desk-build:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover plugins get 
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover build darwin
flu-desk-open:
	open $(LIB_FLU_SAMEPLE_FSPATH)/go/build/outputs/darwin/ufmp

## MOB

flu-mob-list:
	flutter devices
flu-and-run:
	# java eror :)
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter run -d "Nexus 5X (mobile)"
flu-ios-run:
	# works
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter run -d iPhone
flu-ios-clean:
	# this is sometimes needed
	# pod clean
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && rm -f ./Podfile.lock
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && rm -rf ./Pods
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter clean
	# pod setup
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter pub get
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build ios
	
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && pod install
flu-mob-build:
	# ios
	# https://flutter.dev/docs/deployment/ios
	# change to ios 11 in xcode for runner and pods
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && pod install
	cd $(FLU_SLIB_FLU_SAMEPLE_FSPATH) && flutter build ios
	#cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build ios --release --no-codesign