
# https://github.com/jerson/flutter-openpgp

# NOTE: currently only the tagged version works, so use "make dep-tag".

LIB_ORG=				github.com/jerson
LIB_ORG_FSPATH=			$(GOPATH)/src/$(LIB_ORG)

# LIB = main LIB
LIB_GO_NAME=				openpgp-mobile
LIB_GO_TAG=					v0.7.1

LIB_FLU_NAME=				flutter-openpgp
LIB_FLU_TAG=				v0.9.9


LIB_GO_FSPATH=$(LIB_ORG_FSPATH)/$(LIB_GO_NAME)

LIB_FLU_SAMEPLE_FSPATH=$(LIB_ORG_FSPATH)/$(LIB_FLU_NAME)/example



print:
	@echo 
	@echo LIB_ORG: 				$(LIB_ORG)
	@echo LIB_ORG_FSPATH: 		$(LIB_ORG_FSPATH)
	@echo 

	@echo 
	@echo LIB_GO_NAME: 			$(LIB_GO_NAME)
	@echo LIB_GO_TAG: 			$(LIB_GO_TAG)
	@echo 

	@echo 
	@echo LIB_FLU_NAME: 		$(LIB_FLU_NAME)
	@echo LIB_FLU_TAG: 			$(LIB_FLU_TAG)
	@echo 

dep-tag: dep
	 #go
	cd $(LIB_ORG_FSPATH)/$(LIB_GO_NAME) && git fetch --all --tags --prune
	cd $(LIB_ORG_FSPATH)/$(LIB_GO_NAME) && git checkout tags/$(LIB_GO_TAG)

	# flu
	cd $(LIB_ORG_FSPATH)/$(LIB_FLU_NAME) && git fetch --all --tags --prune
	cd $(LIB_ORG_FSPATH)/$(LIB_FLU_NAME) && git checkout tags/$(LIB_FLU_TAG)
dep:
	# go
	git clone https://$(LIB_ORG)/$(LIB_GO_NAME) $(LIB_ORG_FSPATH)/$(LIB_GO_NAME)

	# flu
	git clone https://$(LIB_ORG)/$(LIB_FLU_NAME) $(LIB_ORG_FSPATH)/$(LIB_FLU_NAME)

dep-delete:
	rm -rf $(LIB_ORG_FSPATH)

this-vscode-add:
	# copy vscode debug json into project
	mkdir -p $(LIB_ORG_FSPATH)/.vscode
	#cp ./launch.json $(LIB_ORG_FSPATH)/.vscode/.

	# copy make file in
	cp ./makefile $(LIB_ORG_FSPATH)/.

	# Now add the project as a workspace
	code --add $(LIB_ORG_FSPATH)


vscode-open:

	# open vscode
	code $(LIB_ORG_FSPATH)



### GO
	
go-dep:
	# install gomobile 
	cd $(LIB_GO_FSPATH) && $(MAKE) gomobile
go-build: 
	# clean binding android ios wasm
	cd $(LIB_GO_FSPATH) && $(MAKE) clean
	cd $(LIB_GO_FSPATH) && $(MAKE) binding
	# Android is broken on my machine due to freaking Java dependency.
	# TODO Get Docker based one working !!
	#cd $(LIB_GO_FSPATH) && $(MAKE) android
	cd $(LIB_GO_FSPATH) && $(MAKE) ios
	cd $(LIB_GO_FSPATH) && $(MAKE) wasm



### FLU

FLU_PROJECT_NAME=openpgp_example

flu-dep:
	# flu
	flutter channel master
	flutter upgrade --force

	# Needed to bootstrap project up to the structure to match the flutter channels
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter create .
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter pub get

	# flu desk
	GO111MODULE=on go get -u -a github.com/go-flutter-desktop/hover
	# flu web server runner
	go get -u github.com/shurcooL/goexec


## WEB
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
flu-desk-run:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover plugins get 
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover run
flu-desk-build:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover plugins get 
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover build darwin
flu-desk-open:
	open $(LIB_FLU_SAMEPLE_FSPATH)/go/build/outputs/darwin/openpgp_example

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

	


	



