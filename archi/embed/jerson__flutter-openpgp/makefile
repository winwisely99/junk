
# https://github.com/jerson/flutter-openpgp

include ./../../root.mk

LIB_ORG=				github.com/jerson
LIB_ORG_FSPATH=			$(GOPATH)/src/$(LIB_ORG)

# LIB = main LIB
LIB_GO_NAME=				openpgp-mobile
LIB_GO_TAG=					v0.7.1

LIB_FLU_NAME=				flutter-openpgp
LIB_FLU_TAG=				v0.9.9

### CALC
BIN_FSPATH=$(PWD)/bin
DATA_FSPATH=$(PWD)/data

LIB_GO_SPATH=$(LIB_ORG_FSPATH)/$(LIB_GO_NAME)

LIB_FLU_SAMEPLE_FSPATH=$(LIB_ORG_FSPATH)/$(LIB_FLU_NAME)/example



this-print:
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

this-git-clone:
	# go
	$(MAKE) git-clone-args LIB=$(LIB_ORG)/$(LIB_GO_NAME) LIB_FSPATH=$(LIB_ORG_FSPATH)/$(LIB_GO_NAME)
	cd $(LIB_ORG_FSPATH)/$(LIB_GO_NAME) && git fetch --all --tags --prune
	cd $(LIB_ORG_FSPATH)/$(LIB_GO_NAME) && git checkout tags/$(LIB_GO_TAG)

	# flu
	$(MAKE) git-clone-args LIB=$(LIB_ORG)/$(LIB_FLU_NAME) LIB_FSPATH=$(LIB_ORG_FSPATH)/$(LIB_FLU_NAME)
	cd $(LIB_ORG_FSPATH)/$(LIB_FLU_NAME) && git fetch --all --tags --prune
	cd $(LIB_ORG_FSPATH)/$(LIB_FLU_NAME) && git checkout tags/$(LIB_FLU_TAG)


this-git-delete:
	rm -rf $(LIB_ORG_FSPATH)



this-vscode-add:
	# copy vscode debug json into project
	mkdir -p $(LIB_ORG_FSPATH)/.vscode
	#cp ./launch.json $(LIB_ORG_FSPATH)/.vscode/.

	# copy make file in
	cp ./makefile $(LIB_ORG_FSPATH)/.

	# Now add the project as a workspace
	code --add $(LIB_ORG_FSPATH)


this-vscode-open:

	# open vscode
	code $(LIB_ORG_FSPATH)



### GO
	
this-go-dep:
	cd $(LIB_GO_SPATH) && $(MAKE) gomobile
this-go-build: 
	cd $(LIB_GO_SPATH) && $(MAKE) all



### FLU

FLU_PROJECT_NAME=openpgp_example

this-flu-dep:
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
this-flu-web-run:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter run -d chrome
	#cd $(LIB_FLU_SAMEPLE_FSPATH) && 	flutter run --release --dart-define=FLUTTER_WEB_USE_SKIA=true -d chrome
this-flu-web-build:
	flutter config --enable-web
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build web --release
this-flu-web-buildwasm:
	flutter config --enable-web
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
this-flu-web-open:
	open http://localhost:8080
	cd $(LIB_FLU_SAMEPLE_FSPATH)/build && goexec -quiet 'http.ListenAndServe(":8080", http.FileServer(http.Dir("web")))'


## DESK
this-flu-desk-run:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover plugins get 
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover run
this-flu-desk-build:
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover plugins get 
	cd $(LIB_FLU_SAMEPLE_FSPATH) && hover build darwin
this-flu-desk-open:
	open $(LIB_FLU_SAMEPLE_FSPATH)/go/build/outputs/darwin/openpgp_example

## MOB

this-flu-mob-list:
	flutter devices
this-flu-and-run:
	# java eror :)
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter run -d "Nexus 5X (mobile)"
this-flu-ios-run:
	# works
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter run -d iPhone
this-flu-ios-clean:
	# this is sometimes needed
	# pod clean
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && rm -f ./Podfile.lock
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && rm -rf ./Pods
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter clean
	# pod setup
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter pub get
	cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build ios
	
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && pod install
this-flu-mob-build:
	# ios
	# https://flutter.dev/docs/deployment/ios
	# change to ios 11 in xcode for runner and pods
	cd $(LIB_FLU_SAMEPLE_FSPATH)/ios && pod install
	cd $(FLU_SLIB_FLU_SAMEPLE_FSPATH) && flutter build ios
	#cd $(LIB_FLU_SAMEPLE_FSPATH) && flutter build ios --release --no-codesign

	


	



